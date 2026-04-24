import '../models/log_enums.dart';

class AppStrings {
  const AppStrings(this.appLanguage);

  final AppLanguage appLanguage;

  bool get isZh => appLanguage == AppLanguage.zh;

  String get appTitle => isZh ? 'Luna Log / 月面日志' : 'Luna Log';
  String get appSubtitle =>
      isZh ? '把今天的状态写进一座安静运转的月面基地。' : 'Turn today into a quiet lunar-base log.';
  String get home => isZh ? '首页' : 'Home';
  String get log => isZh ? '记录' : 'Log';
  String get archive => isZh ? '归档' : 'Archive';
  String get settings => isZh ? '设置' : 'Settings';
  String get todaySignal => isZh ? '今日信号' : 'Today\'s Signal';
  String get statusSummary => isZh ? '状态摘要' : 'Status Summary';
  String get logNow => isZh ? '记录今天' : 'Log Today';
  String get noEntryYet =>
      isZh ? '今天还没有新的记录。' : 'No entry has been logged today.';
  String get stationBrief => isZh ? '基地简报' : 'Station Brief';
  String get frequency => isZh ? '频段' : 'Frequency';
  String get noNote => isZh ? '没有补充备注。' : 'No extra note today.';
  String get emptySignal => isZh
      ? '基地尚未收到今日回传。先记录一次状态，月面会亮起第一盏灯。'
      : 'The base has not received today\'s return signal yet. Log once to light the first window.';
  String get sceneTitle => isZh ? '月面场景' : 'Lunar Scene';
  String get sceneEmpty => isZh
      ? '基地处于待机状态，跑道安静，通信塔维持低功耗守望。'
      : 'The base is idle, the runway is quiet, and the relay tower stays on low power watch.';
  String get mood => isZh ? '情绪' : 'Mood';
  String get energy => isZh ? '能量' : 'Energy';
  String get focus => isZh ? '专注' : 'Focus';
  String get sleep => isZh ? '睡眠' : 'Sleep';
  String get logTitle => isZh ? '今日记录' : 'Daily Log';
  String get logSubtitle => isZh
      ? '快速写下今天的状态，生成一条月面信号。'
      : 'Capture today quickly and generate a lunar signal.';
  String get note => isZh ? '备注' : 'Note';
  String get noteHint => isZh
      ? '写一点今天的感受、碎片想法或想留给自己的话。'
      : 'Leave a short note, feeling, or small thought for today.';
  String get preview => isZh ? '信号预览' : 'Signal Preview';
  String get saveEntry => isZh ? '保存记录' : 'Save Entry';
  String get saved => isZh ? '已写入月面日志。' : 'Saved to lunar log.';
  String get archiveTitle => isZh ? '归档' : 'Archive';
  String get archiveSubtitle => isZh
      ? '以时间线和月视图回看这座基地的变化。'
      : 'Review the base through a timeline and a month grid.';
  String get monthView => isZh ? '月视图' : 'Month View';
  String get timeline => isZh ? '时间线' : 'Timeline';
  String get emptyArchive => isZh ? '还没有历史记录。' : 'No archive entries yet.';
  String get settingsTitle => isZh ? '设置' : 'Settings';
  String get settingsSubtitle => isZh
      ? '切换语言与主题，让基地更贴近你的节奏。'
      : 'Tune language and theme for your own orbit.';
  String get language => isZh ? '语言' : 'Language';
  String get chinese => isZh ? '中文' : 'Chinese';
  String get english => isZh ? '英文' : 'English';
  String get theme => isZh ? '主题' : 'Theme';
  String get darkTheme => isZh ? '深色' : 'Dark';
  String get lightTheme => isZh ? '浅色' : 'Light';
  String get about => isZh ? '关于' : 'About';
  String get aboutText => isZh
      ? 'Luna Log 是一个像素风月面基地情绪日志 MVP：在首页查看场景与信号，在记录页写入状态，在归档页回看历史，在设置页切换语言与主题。'
      : 'Luna Log is a pixel-art lunar-base mood journal MVP with a scene-driven home, a compact log flow, an archive view, and bilingual theme settings.';
}
