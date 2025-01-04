import 'package:health2mama/Utils/constant.dart';

class StageConverter {
  static final Map<String, String> _stageMapping = {
    'TRYINGTOCONCEIVE': Constants.stage1,
    'PREGNANT': Constants.stage2,
    'POSTPARTUM': Constants.stage3,
    'BEYOND': Constants.stage41,
    // Add other mappings as needed
  };

  // Method to convert API stage value to human-readable string
  static String formatStage(String stage) {
    String formattedStage = _stageMapping[stage] ?? stage; // Default to original if not found
    return formattedStage.length > 40
        ? formattedStage.substring(0, 40) + "..."
        : formattedStage;
  }
}