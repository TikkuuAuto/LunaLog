import '../i18n/app_strings.dart';
import '../models/daily_log.dart';
import '../models/log_enums.dart';

String moodLabel(AppStrings strings, Mood value) {
  switch (value) {
    case Mood.calm:
      return strings.isZh ? '平静' : 'Calm';
    case Mood.bright:
      return strings.isZh ? '明亮' : 'Bright';
    case Mood.low:
      return strings.isZh ? '低落' : 'Low';
    case Mood.restless:
      return strings.isZh ? '躁动' : 'Restless';
    case Mood.tender:
      return strings.isZh ? '柔软' : 'Tender';
  }
}

String energyLabel(AppStrings strings, Energy value) {
  switch (value) {
    case Energy.low:
      return strings.isZh ? '偏低' : 'Low';
    case Energy.steady:
      return strings.isZh ? '稳定' : 'Steady';
    case Energy.high:
      return strings.isZh ? '高' : 'High';
  }
}

String focusLabel(AppStrings strings, Focus value) {
  switch (value) {
    case Focus.scattered:
      return strings.isZh ? '分散' : 'Scattered';
    case Focus.gentle:
      return strings.isZh ? '柔和' : 'Gentle';
    case Focus.sharp:
      return strings.isZh ? '清晰' : 'Sharp';
  }
}

String sleepLabel(AppStrings strings, Sleep value) {
  switch (value) {
    case Sleep.poor:
      return strings.isZh ? '不足' : 'Poor';
    case Sleep.okay:
      return strings.isZh ? '一般' : 'Okay';
    case Sleep.good:
      return strings.isZh ? '良好' : 'Good';
  }
}

String frequencyLabel(AppStrings strings, FrequencyTag value) {
  switch (value) {
    case FrequencyTag.lofi:
      return 'Lo-fi';
    case FrequencyTag.lunarRadio:
      return strings.isZh ? '月面电台' : 'Lunar Radio';
    case FrequencyTag.deepSpace:
      return strings.isZh ? '深空' : 'Deep Space';
  }
}

String sceneSummary(AppStrings strings, LunaEntry entry) {
  final String sky = switch (entry.mood) {
    Mood.calm => strings.isZh ? '夜空平稳' : 'steady sky',
    Mood.bright => strings.isZh ? '天幕偏亮' : 'bright horizon',
    Mood.low => strings.isZh ? '云层偏低' : 'dim horizon',
    Mood.restless => strings.isZh ? '电流浮动' : 'drifting current',
    Mood.tender => strings.isZh ? '月雾柔和' : 'soft moon mist',
  };
  final String station = switch (entry.energy) {
    Energy.low => strings.isZh ? '基地低功耗运转' : 'low-power base',
    Energy.steady => strings.isZh ? '系统稳定值守' : 'steady systems',
    Energy.high => strings.isZh ? '舱段灯光更活跃' : 'lively modules',
  };
  return strings.isZh ? '$sky，$station。' : '$sky, with $station.';
}

String buildSignal(AppStrings strings, LunaEntry entry) {
  final String moodTone = switch (entry.mood) {
    Mood.calm => strings.isZh ? '主站通信平稳' : 'Main relay is calm',
    Mood.bright => strings.isZh ? '采样舱亮度上升' : 'The sample bay is brighter',
    Mood.low =>
      strings.isZh ? '基地把灯调暗了一格' : 'The base dims its lights slightly',
    Mood.restless =>
      strings.isZh ? '信号边缘带着一点漂移' : 'The signal edge drifts a little',
    Mood.tender => strings.isZh ? '今晚的月雾很软' : 'Tonight\'s moon mist feels soft',
  };
  final String energyTone = switch (entry.energy) {
    Energy.low =>
      strings.isZh
          ? '值班系统维持最低但稳定的输出'
          : 'keeping only the minimum steady output',
    Energy.steady =>
      strings.isZh ? '主系统保持着均匀供能' : 'with balanced station power',
    Energy.high =>
      strings.isZh ? '几个舱段都亮起了回应灯' : 'and more modules answer with light',
  };
  final String focusTone = switch (entry.focus) {
    Focus.scattered =>
      strings.isZh
          ? '频道有些分叉，但仍能听清自己'
          : 'The channel branches a little, but your voice still comes through',
    Focus.gentle =>
      strings.isZh
          ? '回波很柔和，像慢慢对齐轨道'
          : 'The echo stays gentle, like easing into orbit',
    Focus.sharp =>
      strings.isZh
          ? '航迹线清楚，回传坐标很干净'
          : 'The course line is sharp and the coordinates come back clean',
  };
  final String sleepTone = switch (entry.sleep) {
    Sleep.poor =>
      strings.isZh
          ? '基地提醒你今晚尽量提前回舱休整。'
          : 'The base suggests an earlier return to rest tonight.',
    Sleep.okay =>
      strings.isZh
          ? '补给足够，今晚可以慢一点收尾。'
          : 'Supplies look fine; you can close the day gently.',
    Sleep.good =>
      strings.isZh
          ? '你的休整记录让整座站更安定。'
          : 'Your recovery record steadies the whole station.',
  };
  return strings.isZh
      ? '$moodTone，$energyTone。$focusTone。$sleepTone'
      : '$moodTone, $energyTone. $focusTone. $sleepTone';
}
