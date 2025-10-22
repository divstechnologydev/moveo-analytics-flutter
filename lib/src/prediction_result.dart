/// Represents the result of a prediction request to the Dolphin service
class PredictionResult {
  /// Whether the prediction request was successful
  final bool success;
  
  /// Status of the prediction (success, pending, error types, etc.)
  final String status;
  
  /// Prediction probability (only available when success is true)
  final double? predictionProbability;
  
  /// Binary prediction result (only available when success is true)
  final bool? predictionBinary;
  
  /// Error message (only available when success is false)
  final String? message;

  const PredictionResult({
    required this.success,
    required this.status,
    this.predictionProbability,
    this.predictionBinary,
    this.message,
  });

  /// Create PredictionResult from a Map (for internal use)
  factory PredictionResult.fromMap(Map<String, dynamic> map) {
    return PredictionResult(
      success: map['success'] as bool,
      status: map['status'] as String,
      predictionProbability: map['prediction_probability']?.toDouble(),
      predictionBinary: map['prediction_binary'] as bool?,
      message: map['message'] as String?,
    );
  }

  /// Convert to Map (for internal use)
  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'status': status,
      'prediction_probability': predictionProbability,
      'prediction_binary': predictionBinary,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'PredictionResult(success: $success, status: $status, '
           'predictionProbability: $predictionProbability, '
           'predictionBinary: $predictionBinary, message: $message)';
  }
}
