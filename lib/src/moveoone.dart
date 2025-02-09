import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'moveo_one_entity.dart';
import 'moveo_one_data.dart';

class MoveoOne {
  static const String tag = "MOVEO_ONE";
  static const String apiEndpoint = "https://api.moveo.one/api/analytic/event";

  static final MoveoOne _instance = MoveoOne._internal();
  factory MoveoOne() => _instance;

  final List<MoveoOneEntity> _buffer = [];
  Timer? _flushTimer;
  final int _maxThreshold = 500;
  final Duration _flushInterval = const Duration(seconds: 10);

  String _token = "";
  String _userId = "";
  bool _logging = false;
  bool _started = false;
  String _context = "";
  String _sessionId = "";
  bool _customPush = false;

  MoveoOne._internal();

  // Initialize MoveoOne with an API token
  void initialize(String token) {
    _token = token;
    _log("Initialized");
  }

  // Identify the user
  void identify(String userId) {
    _userId = userId;
  }

  bool isCustomFlush() => _customPush;

  // Start tracking session
  void start(String context) {
    _log("start");
    if (!_started) {
      _flushOrRecord(true);
      _started = true;
      _context = context;
      _sessionId = "sid_${_generateUUID()}";
      _addEventToBuffer(
        context,
        MoveoOneEventType.startSession,
        {},
        _userId,
        _sessionId,
        {},
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

  // Update session metadata
  void updateSessionMetadata(Map<String, String> metadata) {
    _log("update session metadata");
    if (_started) {
      _addEventToBuffer(
        _context,
        MoveoOneEventType.updateMetadata,
        {},
        _userId,
        _sessionId,
        metadata,
      );
      _flushOrRecord(false);
    }
  }

  // Internal method to track events
  void _trackInternal(String context, Map<String, String> properties, Map<String, String> metadata) {
    if (!_started) {
      start(context);
    }
    _addEventToBuffer(context, MoveoOneEventType.track, properties, _userId, _sessionId, metadata);
    _flushOrRecord(false);
  }

  // Internal method for ticking events
  void _tickInternal(Map<String, String> properties, Map<String, String> metadata) {
    if (_context.isEmpty) {
      start("default_ctx");
    }
    _addEventToBuffer(_context, MoveoOneEventType.track, properties, _userId, _sessionId, metadata);
    _flushOrRecord(false);
  }

  // Add event to buffer
  void _addEventToBuffer(
    String context,
    MoveoOneEventType type,
    Map<String, String> prop,
    String userId,
    String sessionId,
    Map<String, String> meta,
  ) {
    int now = DateTime.now().millisecondsSinceEpoch;
    _buffer.add(MoveoOneEntity(
      c: context,
      type: type.value,
      userId: userId,
      t: now,
      prop: prop,
      meta: meta,
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
      final response = await http.post(
        Uri.parse(apiEndpoint),
        headers: {
          'Authorization': '$_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data.map((e) => e.toJson()).toList()),
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