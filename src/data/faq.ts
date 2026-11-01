import type { Locale } from '../i18n';

// FAQ shown on every home page. Edit all four languages together.
// Menu and settings names match the app's localized strings and macOS 26.
type QA = { question: string; answer: string };
export type FAQEntry = { id: string } & Record<Locale, QA>;

export const faq: FAQEntry[] = [
  {
    id: 'restore-purchase',
    en: {
      question: 'Why can’t I restore my purchase although I did make the purchase before?',
      answer: 'Please verify if you’re signing in to the Mac App Store with the Apple ID you used to make the in-app purchase.',
    },
    de: {
      question: 'Warum kann ich meinen Kauf nicht wiederherstellen, obwohl ich ihn bereits getätigt habe?',
      answer: 'Bitte prüfe, ob du im Mac App Store mit der Apple-ID angemeldet bist, mit der du den In-App-Kauf getätigt hast.',
    },
    ja: {
      question: '以前に購入したのに、購入を復元できないのはなぜですか？',
      answer: 'App内課金を行ったときと同じApple IDで、Mac App Storeにサインインしているかご確認ください。',
    },
    zh: {
      question: '我之前已经购买过，为什么无法恢复购买？',
      answer: '请确认你在 Mac App Store 登录的 Apple ID 与进行 App 内购买时使用的是同一个。',
    },
  },
  {
    id: 'google-outlook',
    en: {
      question: 'How can I get WallCal to display my Google/Outlook calendars?',
      answer: 'Please go to System Settings > Internet Accounts and sign in to your Google/Microsoft account, and enable Calendar/Reminder inside each account afterwards.',
    },
    de: {
      question: 'Wie zeigt WallCal meine Google-/Outlook-Kalender an?',
      answer: 'Öffne Systemeinstellungen > Internetaccounts, melde dich mit deinem Google-/Microsoft-Account an und aktiviere anschließend in jedem Account Kalender/Erinnerungen.',
    },
    ja: {
      question: 'Google/OutlookのカレンダーをWallCalに表示するには？',
      answer: '「システム設定」>「インターネットアカウント」でGoogle/Microsoftアカウントにサインインし、各アカウントでカレンダー/リマインダーを有効にしてください。',
    },
    zh: {
      question: '如何让 WallCal 显示我的 Google/Outlook 日历？',
      answer: '请前往“系统设置”>“互联网账户”，登录你的 Google/Microsoft 账户，然后在每个账户中启用日历/提醒事项。',
    },
  },
  {
    id: 'subscription',
    en: {
      question: 'Is WallCal a subscription or one-time purchase?',
      answer: 'Currently, WallCal offers features as distinct add-ons, which necessitate a one-time in-app purchase for lifetime access. New features may be introduced as separate add-ons and sold individually. For Setapp users, WallCal is available at no extra cost.',
    },
    de: {
      question: 'Ist WallCal ein Abo oder ein Einmalkauf?',
      answer: 'Derzeit bietet WallCal Funktionen als einzelne Add-ons an, die per einmaligem In-App-Kauf dauerhaft freigeschaltet werden. Neue Funktionen können als separate Add-ons erscheinen und einzeln verkauft werden. Für Setapp-Nutzer ist WallCal ohne Aufpreis enthalten.',
    },
    ja: {
      question: 'WallCalはサブスクリプションですか？買い切りですか？',
      answer: '現在WallCalは、機能ごとに個別の拡張として提供しており、一度きりのApp内課金で永久に利用できます。新しい機能は別の拡張として追加され、個別に販売される場合があります。Setappユーザーは追加料金なしでWallCalを利用できます。',
    },
    zh: {
      question: 'WallCal 是订阅制还是一次性购买？',
      answer: '目前 WallCal 以独立插件的形式提供功能，只需一次性 App 内购买即可永久使用。新功能可能会以单独的插件推出并单独销售。Setapp 用户无需额外付费即可使用 WallCal。',
    },
  },
  {
    id: 'no-events',
    en: {
      question: 'I don’t see any events or reminders being shown on WallCal?',
      answer: 'Please check if you already granted calendar or reminder access permission to WallCal in System Settings > Privacy & Security > Calendars (or Reminders).',
    },
    de: {
      question: 'In WallCal werden keine Termine oder Erinnerungen angezeigt?',
      answer: 'Bitte prüfe unter Systemeinstellungen > Datenschutz & Sicherheit > Kalender (bzw. Erinnerungen), ob du WallCal den Zugriff erlaubt hast.',
    },
    ja: {
      question: 'WallCalに予定やリマインダーが表示されません。',
      answer: '「システム設定」>「プライバシーとセキュリティ」>「カレンダー」（または「リマインダー」）で、WallCalへのアクセスを許可しているかご確認ください。',
    },
    zh: {
      question: 'WallCal 上没有显示任何事件或提醒事项？',
      answer: '请在“系统设置”>“隐私与安全性”>“日历”（或“提醒事项”）中确认已授予 WallCal 访问权限。',
    },
  },
  {
    id: 'free-trial',
    en: {
      question: 'Do you offer add-on function’s free trial?',
      answer: 'For now we cannot offer in-app free trial, but you can take a look at each add-on’s feature description and preview before making purchase! Alternatively you can try WallCal for free through Setapp (please scroll up to see the Setapp link). Please contact us at support@wallcal.app if you still have any question or concern.',
    },
    de: {
      question: 'Gibt es eine kostenlose Testversion der Add-ons?',
      answer: 'Eine Testphase in der App können wir derzeit leider nicht anbieten. Du kannst dir aber vor dem Kauf die Funktionsbeschreibung und Vorschau jedes Add-ons ansehen! Alternativ kannst du WallCal kostenlos über Setapp testen (den Setapp-Link findest du weiter oben). Bei weiteren Fragen oder Anliegen schreib uns an support@wallcal.app.',
    },
    ja: {
      question: '拡張機能の無料トライアルはありますか？',
      answer: '現在、App内での無料トライアルは提供していませんが、購入前に各拡張の機能説明とプレビューをご確認いただけます。また、Setappを通じてWallCalを無料でお試しいただくこともできます（Setappのリンクはこのページの上部にあります）。ご不明な点があれば support@wallcal.app までお問い合わせください。',
    },
    zh: {
      question: '插件功能提供免费试用吗？',
      answer: '目前我们无法提供 App 内免费试用，但你可以在购买前查看每个插件的功能介绍和预览！你也可以通过 Setapp 免费试用 WallCal（Setapp 链接见本页上方）。如仍有任何疑问，请发邮件至 support@wallcal.app。',
    },
  },
  {
    id: 'edit-events',
    en: {
      question: 'Does WallCal support adding new events/reminders, or editing existing events/reminders?',
      answer: 'Unfortunately, WallCal doesn’t support these actions at the moment. Please use Apple’s stock Calendar/Reminder app, or any other 3rd party apps which support this function to manipulate calendar events/reminders.',
    },
    de: {
      question: 'Kann ich in WallCal neue Termine/Erinnerungen hinzufügen oder bestehende bearbeiten?',
      answer: 'Leider unterstützt WallCal das derzeit nicht. Bitte nutze dafür Apples Kalender- bzw. Erinnerungen-App oder eine andere App, die diese Funktion bietet.',
    },
    ja: {
      question: 'WallCalで予定やリマインダーを追加・編集できますか？',
      answer: '申し訳ありませんが、現在WallCalはこれらの操作に対応していません。予定やリマインダーの追加・編集には、Apple純正のカレンダー/リマインダーアプリや、この機能に対応した他社製アプリをご利用ください。',
    },
    zh: {
      question: 'WallCal 支持添加新的事件/提醒事项，或编辑现有事件/提醒事项吗？',
      answer: '很抱歉，WallCal 目前不支持这些操作。请使用 Apple 自带的日历/提醒事项应用，或其他支持该功能的第三方应用来管理日历事件和提醒事项。',
    },
  },
  {
    id: 'move-monitor',
    en: {
      question: 'Can I move WallCal to the monitor of my choice?',
      answer: 'Yes! When you reposition WallCal (see “How can I reposition WallCal?”) you can drag it to the destination monitor to place it there.',
    },
    de: {
      question: 'Kann ich WallCal auf einen Monitor meiner Wahl verschieben?',
      answer: 'Ja! Wenn du WallCal verschiebst (siehe „Wie kann ich WallCal verschieben?“), ziehst du es einfach auf den gewünschten Monitor.',
    },
    ja: {
      question: 'WallCalを好きなモニタに移動できますか？',
      answer: 'はい！WallCalの位置を変更するとき（「WallCalの位置を変更するには？」を参照）、移動先のモニタまでドラッグすれば、そこに配置できます。',
    },
    zh: {
      question: '可以把 WallCal 移到我想要的显示器上吗？',
      answer: '可以！调整 WallCal 位置时（参见“如何调整 WallCal 的位置？”），把它拖到目标显示器即可。',
    },
  },
  {
    id: 'reposition',
    en: {
      question: 'How can I reposition WallCal?',
      answer: 'After putting it in frontmost state (by using “Toggle frontmost state / Resize” in the menu bar), click anywhere inside the calendar and drag to reposition, like how you do to position windows.',
    },
    de: {
      question: 'Wie kann ich WallCal verschieben?',
      answer: 'Stelle WallCal zuerst in den Vordergrund (über „Kalender in den Vordergrund stellen / Anpassen“ in der Menüleiste). Klicke dann irgendwo in den Kalender und ziehe ihn an die gewünschte Stelle – wie bei einem Fenster.',
    },
    ja: {
      question: 'WallCalの位置を変更するには？',
      answer: 'メニューバーの「カレンダーを画面の最前にする・サイズ変更」でWallCalを最前面にしたあと、カレンダー内の任意の場所をクリックしてドラッグすれば、ウインドウと同じように位置を変更できます。',
    },
    zh: {
      question: '如何调整 WallCal 的位置？',
      answer: '先通过菜单栏中的“切换日历的最前显示状态/调整大小”将其置于最前，然后在日历内任意位置点击并拖动即可调整位置，就像移动窗口一样。',
    },
  },
  {
    id: 'resize',
    en: {
      question: 'How can I resize WallCal?',
      answer: 'After putting it in frontmost state (by using “Toggle frontmost state / Resize” in the menu bar), hover over its edge and drag to resize, like how you do to resize windows.',
    },
    de: {
      question: 'Wie kann ich die Größe von WallCal ändern?',
      answer: 'Stelle WallCal zuerst in den Vordergrund (über „Kalender in den Vordergrund stellen / Anpassen“ in der Menüleiste). Bewege dann den Zeiger auf den Rand und ziehe, um die Größe zu ändern – wie bei einem Fenster.',
    },
    ja: {
      question: 'WallCalのサイズを変更するには？',
      answer: 'メニューバーの「カレンダーを画面の最前にする・サイズ変更」でWallCalを最前面にしたあと、端にポインタを合わせてドラッグすれば、ウインドウと同じようにサイズを変更できます。',
    },
    zh: {
      question: '如何调整 WallCal 的大小？',
      answer: '先通过菜单栏中的“切换日历的最前显示状态/调整大小”将其置于最前，然后将指针移到边缘并拖动即可调整大小，就像调整窗口大小一样。',
    },
  },
  {
    id: 'settings',
    en: {
      question: 'Where can I access WallCal settings?',
      answer: 'Look for the WallCal icon in the menu bar. That is the entry to all WallCal settings.',
    },
    de: {
      question: 'Wo finde ich die Einstellungen von WallCal?',
      answer: 'Klicke auf das WallCal-Symbol in der Menüleiste. Dort erreichst du alle Einstellungen.',
    },
    ja: {
      question: 'WallCalの設定はどこにありますか？',
      answer: 'メニューバーのWallCalアイコンをクリックしてください。すべての設定はそこから開けます。',
    },
    zh: {
      question: '在哪里可以打开 WallCal 设置？',
      answer: '在菜单栏中找到 WallCal 图标，所有设置都从这里进入。',
    },
  },
];
