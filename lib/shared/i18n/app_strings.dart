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
  String get archive => isZh ? '记录' : 'Log';
  String get settings => isZh ? '设置' : 'Settings';
  String get navHome => isZh ? '首页' : 'Home';
  String get navLog => isZh ? '记录' : 'Log';
  String get navAdd => isZh ? '添加' : 'Add';
  String get navData => isZh ? '数据' : 'Stats';
  String get navMe => isZh ? '个人设置' : 'Me';
  String get todaySignal => isZh ? '今日信号' : 'Today\'s Signal';
  String get statusSummary => isZh ? '状态摘要' : 'State Summary';
  String get logNow => isZh ? '记录今天' : 'Log Today';
  String get noEntryYet =>
      isZh ? '今天还没有新的记录。' : 'No entry has been logged today.';
  String get stationBrief => isZh ? '基地简报' : 'Station Brief';
  String get frequency => isZh ? '声轨' : 'Soundtrack';
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
  String get logTitle => isZh ? '快速记录' : 'Quick Log';
  String get logSubtitle => isZh
      ? '快速写下今天的状态，先听见它会变成怎样的月面信号。'
      : 'Capture today quickly and preview the lunar signal it creates.';
  String get note => isZh ? '备注' : 'Note';
  String get noteHint => isZh
      ? '写一点今天的感受、碎片想法，或者想留给自己的话。'
      : 'Leave a short note, feeling, or small thought for today.';
  String get preview => isZh ? '信号预览' : 'Signal Preview';
  String get saveEntry => isZh ? '保存记录' : 'Save Entry';
  String get saved => isZh ? '已写入月面日志。' : 'Saved to lunar log.';
  String get archiveTitle => isZh ? '信号记录' : 'Signal Log';
  String get archiveSubtitle => isZh
      ? '回看基地保存下来的日期、状态和那天的回传。'
      : 'Revisit the dates, states, and signals your station has kept.';
  String get monthView => isZh ? '月度扫描' : 'Monthly Scan';
  String get timeline => isZh ? '时间线' : 'Timeline';
  String get emptyArchive => isZh ? '还没有历史记录。' : 'No archive entries yet.';
  String get statsTitle => isZh ? '基地数据' : 'Station Stats';
  String get statsSubtitle => isZh
      ? '轻轻看一眼最近的轨迹，不做压力排行。'
      : 'A gentle look at recent patterns, without pressure.';
  String get statsReflection => isZh ? '近期回响' : 'Recent Reflection';
  String get streakRelay => isZh ? '连续信标' : 'Streak Beacon';
  String get stationRhythm => isZh ? '基地节奏' : 'Station Rhythm';
  String get companionStatus => isZh ? '陪伴信号' : 'Companion Signal';
  String get memorySummary => isZh ? '记忆概览' : 'Memory Summary';
  String get preservedSignal => isZh ? '保存的信号' : 'Preserved Signal';
  String get monthLoggedDays => isZh ? '本月点亮天数' : 'Lit days this month';
  String get statsEmptyReflection => isZh
      ? '基地还在等待第一段信号。添加一次记录后，这里会开始出现轻量反馈。'
      : 'The station is waiting for its first signal. Add one log and gentle feedback will appear here.';
  String get statsReadyReflection => isZh
      ? '基地正在保存你的日常回响。慢慢来，稳定的小信号也算数。'
      : 'The station is keeping your daily echoes. Small steady signals count too.';
  String get logsThisMonth => isZh ? '本月记录' : 'Logs This Month';
  String get currentStreak => isZh ? '当前连续' : 'Current Streak';
  String get longestStreak => isZh ? '最长连续' : 'Longest Streak';
  String get commonMood => isZh ? '常见情绪' : 'Common Mood';
  String get commonSoundtrack => isZh ? '常用声轨' : 'Common Soundtrack';
  String get daysUnit => isZh ? '天' : 'days';
  String get noneYet => isZh ? '暂无' : 'None yet';
  String streakLine(int count) {
    if (count <= 0) {
      return isZh
          ? '信标正在待机，下一次记录会重新点亮它。'
          : 'The beacon is waiting; your next log will light it again.';
    }
    if (count == 1) {
      return isZh
          ? '今天的信标已经亮起，基地收到了你的回传。'
          : 'Today\'s beacon is lit; the station received your signal.';
    }
    return isZh
        ? '信标已连续亮起 $count 天，稳定的小信号正在累积。'
        : 'The beacon has stayed lit for $count days; small steady signals are adding up.';
  }

  String companionLine(int count) {
    if (count <= 0) {
      return isZh
          ? '月面小伙伴还在舱门边打盹，等第一条信号。'
          : 'A tiny moon companion naps by the hatch, waiting for the first signal.';
    }
    if (count < 3) {
      return isZh
          ? '月面小伙伴抬头看了看信标，确认你安全抵达。'
          : 'The moon companion checks the beacon and sees you made it back.';
    }
    return isZh
        ? '月面小伙伴已经认得你的节奏，正守在基地灯下。'
        : 'The moon companion knows your rhythm now and waits under the base light.';
  }

  String get settingsTitle => isZh ? '个人设置' : 'Settings';
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
      ? 'Luna Log 是一个像素风月面基地情绪日志 MVP：在首页查看场景与信号，在添加页写入状态，在记录页回看历史，在数据页获得轻量反馈。'
      : 'Luna Log is a pixel-art lunar-base mood journal MVP with a scene-driven home, a quick log flow, preserved signal history, and gentle stats.';
  String get helpAndInfo => isZh ? '帮助与信息' : 'Help & Info';
  String get contactSupport => isZh ? '联系与支持' : 'Contact & Support';
  String get contactSupportText => isZh
      ? '如果你在使用 Luna Log 时遇到问题，或者想反馈月面基地的小建议，可以先记录问题发生的页面、时间和设备信息。正式发布前，这里会接入支持邮箱与反馈渠道。'
      : 'If you run into an issue or want to share feedback, note the page, time, and device details. Before release, this section will connect to the support email and feedback channel.';
  String get usageGuide => isZh ? '使用教学' : 'How to Use';
  String get usageGuideText => isZh
      ? '每天只需要添加一次状态：选择情绪、能量、专注、睡眠和声轨，可选写一小段备注。当天再次保存会更新今天的主信号，不会生成重复记录。首页显示今日或最近信号，记录页回看历史，数据页查看轻量连续反馈。'
      : 'Add one daily state: choose mood, energy, focus, sleep, and soundtrack, with an optional note. Saving again on the same day updates today’s main signal instead of creating duplicates. Home shows today or the latest signal, Log keeps history, and Stats gives gentle streak feedback.';
  String get privacyPolicy => isZh ? '隐私政策' : 'Privacy Policy';
  String get privacyPolicyText => isZh
      ? '当前 MVP 的日志与设置保存在本机设备中，不包含云同步、账号系统或外部音乐服务。正式发布前，需要补充完整隐私政策，说明本地数据、未来可能的反馈渠道以及应用不会用于医疗诊断。'
      : 'In this MVP, logs and settings are stored locally on the device. There is no cloud sync, account system, or external music service. Before release, a full privacy policy should clarify local data, future feedback channels, and that the app is not for medical diagnosis.';
  String get openDetail => isZh ? '查看' : 'Open';
}
