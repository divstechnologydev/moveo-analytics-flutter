import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'moveo_one_entity.dart';
import 'moveo_one_data.dart';
import 'prediction_result.dart';

class MoveoOne {
  static const String tag = "MOVEO_ONE";
  static const String apiEndpoint = "https://api.moveo.one/api/analytic/event";

  static final MoveoOne _instance = MoveoOne._internal();
  factory MoveoOne() => _instance;

  final List<MoveoOneEntity> _buffer = [];
  Timer? _flushTimer;
  final int _maxThreshold = 500;
  final Duration _flushInterval = const Duration(milliseconds: 150);

  String _token = "";
  bool _logging = false;
  bool _started = false;
  String _context = "";
  String _sessionId = "";
  bool _customPush = false;
  Map<String, String> _metadata = {};
  Map<String, String> _additionalMeta = {};


  MoveoOne._internal();

  // Initialize MoveoOne with an API token
  void initialize(String token) {
    _token = token;
    _log("Initialized");
  }



  bool isCustomFlush() => _customPush;

  // Start tracking session
  void start(String context, {Map<String, String> metadata = const {}}) {
    _log("start");
    if (!_started) {
      _flushOrRecord(true);
      _started = true;
      _context = context;
      _sessionId = "sid_${_generateUUID()}";

      final mergedMetadata = Map<String, String>.from(metadata);
      mergedMetadata['libVersion'] = libVersion;

      // Store the initial metadata
      _metadata = Map<String, String>.from(mergedMetadata);

      _addEventToBuffer(
        context,
        MoveoOneEventType.startSession,
        {},
        _sessionId,
        mergedMetadata,
        additionalMeta: {},
      );
      _flushOrRecord(false);
    }
  }

  // Track an event
  void track(String context, MoveoOneData data) {
    _log("track");
    Map<String, String> properties = {
      'sg': data.semanticGroup,
      'eID': data.id,
      'eA': data.action.value,
      'eT': data.type.value,
      'eV': _convertValueToString(data.value),
    };

    _trackInternal(context, properties, data.metadata);
  }

  // Tick event
  void tick(MoveoOneData data) {
    _log("tick");
    Map<String, String> properties = {
      'sg': data.semanticGroup,
      'eID': data.id,
      'eA': data.action.value,
      'eT': data.type.value,
      'eV': _convertValueToString(data.value),
    };

    _tickInternal(properties, data.metadata);
  }


  void updateSessionMetadata(Map<String, String> newMetadata) {
    _log("update session metadata");
    if (_started) {
      // Merge new metadata with existing metadata
      _metadata.addAll(newMetadata);

      // Send the complete merged metadata object
      _addEventToBuffer(
        _context,
        MoveoOneEventType.updateMetadata,
        {},
        _sessionId,
        Map<String, String>.from(_metadata), // Send the whole metadata object
        additionalMeta: {},
      );
      _flushOrRecord(false);
    }
  }

  void updateAdditionalMetadata(Map<String, String> newAdditionalMeta) {
    _log("update additional metadata");
    if (_started) {
      // Merge new additional metadata with existing additional metadata
      _additionalMeta.addAll(newAdditionalMeta);

      // Send the complete merged additional metadata object
      _addEventToBuffer(
        _context,
        MoveoOneEventType.updateMetadata,
        {},
        _sessionId,
        {},
        additionalMeta: Map<String, String>.from(_additionalMeta), // Send the whole additional metadata object
      );
      _flushOrRecord(false);
    }
  }

  /// Makes a prediction request to the Dolphin service
  /// 
  /// Returns a PredictionResult with prediction results or error information.
  /// This method is non-blocking and follows Flutter best practices.
  /// Sends all current buffer events along with the session ID for prediction.
  /// 
  /// Parameters:
  /// - [modelId]: The model ID to use for prediction
  /// 
  /// Returns:
  /// Future<PredictionResult>: Result object with typed properties:
  /// - success: bool - whether the operation completed successfully
  /// - status: String - specific status (success, error types, etc.)
  /// - predictionProbability: double? - probability if successful
  /// - predictionBinary: bool? - binary result if successful  
  /// - message: String? - error message if not successful
  Future<PredictionResult> predict(String modelId) async {
    // Validate model ID
    if (modelId.trim().isEmpty) {
      return PredictionResult(
        success: false,
        status: 'invalid_model_id',
        message: 'Model ID is required and must be a non-empty string',
      );
    }

    // Check if token is available
    if (_token.trim().isEmpty) {
      return PredictionResult(
        success: false,
        status: 'not_initialized',
        message: 'MoveoOne must be initialized with a valid token before using predict method',
      );
    }

    // Ensure session is started
    if (!_started || _sessionId.isEmpty) {
      return PredictionResult(
        success: false,
        status: 'no_session',
        message: 'Session must be started before making predictions. Call start() method first.',
      );
    }

    _log('predict - request for model: "$modelId"');
    
    try {
      const timeoutDuration = Duration(seconds: 5);
      final uri = Uri.parse('${dolphinBaseUrl}/api/models/${Uri.encodeComponent(modelId)}/predict');
      
      final response = await http.post(
        uri,
        headers: {
          'Authorization': _token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'events': _buffer.map((e) => e.toJson()).toList(),
          'session_id': _sessionId,
        }),
      ).timeout(timeoutDuration);

      _log('predict - response for model "$modelId": Status ${response.statusCode}');
      
      // Handle 202 responses (pending states)
      if (response.statusCode == 202) {
        try {
          final data = jsonDecode(response.body);
          return PredictionResult(
            success: false,
            status: 'pending',
            message: data['message'] ?? 'Model is loading, please try again',
          );
        } catch (e) {
          return PredictionResult(
            success: false,
            status: 'pending',
            message: 'Model is loading, please try again',
          );
        }
      }
      
      // Handle successful prediction (200)
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          if (data != null) {
            return PredictionResult(
              success: true,
              status: 'success',
              predictionProbability: data['prediction_probability']?.toDouble(),
              predictionBinary: data['prediction_binary'],
            );
          }
        } catch (e) {
          _log('predict - parse error for model "$modelId": $e');
          return PredictionResult(
            success: false,
            status: 'server_error',
            message: 'Invalid response format from server',
          );
        }
      }
      
      // Handle HTTP error responses
      String errorMessage = 'Server error processing prediction request';
      try {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          errorMessage = data['detail'] ?? data['message'] ?? errorMessage;
        }
      } catch (e) {
        // Use default error message if JSON parsing fails
      }

      switch (response.statusCode) {
        case 401:
          return PredictionResult(
            success: false,
            status: 'unauthorized',
            message: 'Authentication token is invalid or expired',
          );
        case 403:
          return PredictionResult(
            success: false,
            status: 'forbidden',
            message: 'Access denied to this model',
          );
        case 404:
          return PredictionResult(
            success: false,
            status: 'not_found',
            message: 'Model not found or not accessible',
          );
        case 409:
          return PredictionResult(
            success: false,
            status: 'conflict',
            message: 'Conditional event not found',
          );
        case 422:
          return PredictionResult(
            success: false,
            status: 'invalid_data',
            message: errorMessage,
          );
        case 500:
          return PredictionResult(
            success: false,
            status: 'server_error',
            message: 'Server error processing prediction request',
          );
        default:
          return PredictionResult(
            success: false,
            status: 'server_error',
            message: errorMessage,
          );
      }

    } on TimeoutException {
      _log('predict - timeout for model "$modelId"');
      return PredictionResult(
        success: false,
        status: 'timeout',
        message: 'Request timed out after 5 seconds',
      );
    } catch (error) {
      _log('predict - error for model "$modelId": $error');
      
      if (error.toString().contains('SocketException') || 
          error.toString().contains('NetworkException')) {
        return PredictionResult(
          success: false,
          status: 'network_error',
          message: 'Network error - please check your connection',
        );
      }

      return PredictionResult(
        success: false,
        status: 'unknown_error',
        message: 'An unexpected error occurred: ${error.toString()}',
      );
    }
  }

  // Internal method to track events
  void _trackInternal(String context, Map<String, String> properties, Map<String, String> metadata) {
    if (!_started) {
      start(context);
    }
    _addEventToBuffer(context, MoveoOneEventType.track, properties, _sessionId, metadata, additionalMeta: {});
    _flushOrRecord(false);
  }

  // Internal method for ticking events
  void _tickInternal(Map<String, String> properties, Map<String, String> metadata) {
    if (_context.isEmpty) {
      start("default_ctx");
    }
    _addEventToBuffer(_context, MoveoOneEventType.track, properties, _sessionId, metadata, additionalMeta: {});
    _flushOrRecord(false);
  }

  // Add event to buffer
  void _addEventToBuffer(
    String context,
    MoveoOneEventType type,
    Map<String, String> prop,
    String sessionId,
    Map<String, String> meta,
      {Map<String, String> additionalMeta = const {}}
  ) {
    int now = DateTime.now().millisecondsSinceEpoch;
    _buffer.add(MoveoOneEntity(
      c: context,
      type: type.value,
      t: now,
      prop: prop,
      meta: meta,
      additionalMeta: additionalMeta,
      sId: sessionId,
    ));
  }

  // Flush or record events
  void _flushOrRecord(bool isStopOrStart) {
    if (!_customPush) {
      if (_buffer.length >= _maxThreshold || isStopOrStart) {
        _flush();
      } else if (_flushTimer == null) {
        _setFlushTimeout();
      }
    }
  }

  // Flush the buffer (send data)
  void _flush() {
    if (!_customPush && _buffer.isNotEmpty) {
      _log("Flushing data...");

      _clearFlushTimeout();
      List<MoveoOneEntity> dataToSend = List.from(_buffer);
      _buffer.clear();

      _sendData(dataToSend);
    }
  }

  // Send data to API endpoint
  Future<void> _sendData(List<MoveoOneEntity> data) async {
    try {
      final events = data.map((e) => e.toJson()).toList();
      final body = jsonEncode({"events": events});

      final response = await http.post(
        Uri.parse(apiEndpoint),
        headers: {
          'Authorization': _token,
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        _log("Data sent successfully");
      } else {
        _log("Failed to send data: ${response.statusCode}");
      }
    } catch (e) {
      _log("Error sending data: $e");
    }
  }

  // Set automatic flush timeout
  void _setFlushTimeout() {
    _log("Setting flush timeout");
    _flushTimer = Timer(_flushInterval, () => _flush());
  }

  // Clear flush timeout
  void _clearFlushTimeout() {
    _flushTimer?.cancel();
    _flushTimer = null;
  }

  // Convert various data types to string
  String _convertValueToString(dynamic value) {
    if (value is String) return value;
    if (value is List<String>) return value.join(",");
    if (value is int || value is double) return value.toString();
    return "-";
  }

  // Generate a UUID (similar to Java's UUID.randomUUID())
  String _generateUUID() {
    final random = Random.secure();
    return List.generate(16, (_) => random.nextInt(256)).map((e) => e.toRadixString(16).padLeft(2, '0')).join();
  }

  // Logging function
  void _log(String message) {
    if (_logging) {
      print("[$tag] $message");
    }
  }
}