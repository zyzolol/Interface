-- Russian Translation by  Ynitron(Argonavt), fixed by Dr. Jet Cheshirsky
if GetLocale() ~= "ruRU" then return end

local L = AceLibrary("AceLocale-2.2"):new("Postal")

L:RegisterTranslations("ruRU", function() return {
-- main
	["Module Options"] = "Опции Модуля",
	["Opening Speed"] = "Скорость Открытия",
	["The time in seconds between opening each mail/item/money. Setting this to a very fast speed may disconnect you while opening mail."] = "Время в секундах между открытием каждого письма/вещи/денег. Установка слишком быстрой скорости может привести к дисконнекту.",
-- blackbook
["BlackBook"] = "Черный Список",
	["A Black Book to write down your addresses."] = "Добавляет в Чёрный Список Выбранные адреса",
	["Contacts"] = "Контакты",
	["Friends"] = "Друзья",
	["Guild"] = "Гильдия",
	["Add Contact"] = "Добавить Контакты",
	["Remove Contact"] = "Удалить Контакты",
	["Part %d"] = "Группа %d",
--dejavu
	["DejaVu"] = "Дежавю",
	["Autofills the last recipient in the To: field."] = "Автоматически добавляет последнего получателя в строку адреса.",
--express
	["Express"] = "Экспресс",
	["Mouse click short cuts for mail."] = "Особые щелчки мыши при открытой почте",
	["|cffeda55fShift-Click|r to take the contents."] = "|cffeda55fShift+Щелчок|r взять содержимое.",
	["|cffeda55fCtrl-Click|r to return it to sender."] = "|cffeda55fCtrl+Щелчок|r вернуть отправителю.",
	["|cffeda55fAlt-Click|r to send this item to %s."] = "|cffeda55fAlt+Щелчок|r выслать предмет в адрес %s.",
	
	["Express options"] = "Экспресс Опции",
	["Options for the Express module"] = "Опции для модуля Экспресс",
	["Enable Alt-Click to send mail"] = "Включить посылку почты по Alt+Щелчок",
	["If this option is on, Alt-Clicking an item in your bags will send it instantly to the player in the To: field"] = "Если опция включена, Alt-Кликонье по предмету в вашей сумке позволяет отправить его по почте.",
	["Auto-Send on Alt-Click"] = "Автопосылка по Alt+Щелчок",
	["With this option on, Postal will mail an item as soon as it is attached if there is a recipient filled in."] = "Если опция включена, Postal немедленно отправит посылку, если заполнено имя получателя.",
	["Mousewheel to scroll Inbox"] = "Просмотр ящика колёсиком мыши",
	["Scroll Inbox pages using the Mousewheel."] = "Прокручивает почту в ящике колёсиком мыши",
--forward
	["Forward"] = "Переслать",
	["Forward a message. (Currently Broken)"] = "Переслать сообщение. (Сейчас Сломан)",
	["FW:"] = "FW:", -- в русском нет устойчивого сокращения для "переслать"
--openall
	["OpenAll"] = "ОткрытьВсе",
	["A button that collects all attachments and coins from mail."] = "Кнопка, которая собирает все монеты и предметы с почты.",
	["Open All"] = "Открыть Все",
	["Some Messages May Have Been Skipped."] = "Возможно были пропущены некоторые сообщения",
	["In Progress"] = "В Процессе",
	["Insufficient Bag Space"] = "Недостаточно места в сумках",
	["Processing Message"] = "Обработка сообщения",
	
	["OpenAll options"] = "Настройки \"Открыть Все\"",
	["Options for the OpenAll module"] = "Настройки модуля \"Открыть Все\"",
	["AH-related mail"] = "Письма с Аукциона",
	["Options for AH-related mail"] = "Настройки для писем с Аукциона",
	["Open all Auction cancelled mail"] = "Открывать все письма о прерванных аукционах",
	["If this option is off, Postal will skip opening Auction cancelled mails"] = "Если опция включена, Postal не будет открывать письма о прерванных аукционах",
	["Open all Auction expired mail"] = "Открывать все письма об истекшем сроке аукциона",
	["If this option is off, Postal will skip opening Auction expired mails"] = "Если опция включена, Postal не будет открывать письма об истекшем сроке аукциона",
	["Open all Outbid on mail"] = "Открывать все письма о побитых ставках аукциона",
	["If this option is off, Postal will skip opening Outbid on mails"] = "Если опция выключена, Postal не будет открывать письма о побитых ставках аукциона",
	["Open all Sale Pending mail"] = "Открывать все письма об ожидаемых продажах",
	["If this option is off, Postal will skip opening Sale Pending mails"] = "Если опция отключена, Postal не будет открывать письма об ожидаемых продажах",
	["Open all Auction successful mail"] = "Открывать все письма об успешно завершённых аукционах",
	["If this option is off, Postal will skip opening Auction successful mails"] = "Если опция отключена, Postal не будет открывать письма об успешно завершённых аукционах",
	["Open all Auction won mail"] = "Открывать все письма о выигранных Вами аукционах",
	["If this option is off, Postal will skip opening Auction won mails"] = "Если опция отключена, Postal не будет открывать письма о выигранных Вами аукционах",
	["Non-AH related mail"] = "Не связанная с аукционами почта",
	["Options for non-AH related mail"] = "Опции для не связанной с аукционами почты",
	["Open all mail with attachments"] = "Окрывать все письма с вложениями",
	["If this option is off, Postal will skip opening mails from players that has attachments"] = "Если эта опция выключена, Postal не будет открывать письма с вложениями от других игроков",
	["Other options"] = "Прочие Опции",
	["Verbose mode"] = "Детальный режим",
	["If this option is on, Postal will spam the chat with messages while opening mail"] = "Если опция включена, Postal будет отсылать в чат сообщения о проведённых операциях при получении почты",
--rake
	["Rake"] = "Подсчёт",
	["Prints the amount of money collect during a mail session."] = "Печатает сумму денег, собранных за сеанс работы с почтой",
	["Collected"] = "Собрано",
--select
	["Select"] = "Выбор",
	["Add check boxes to the inbox for multiple mail operations."] = "Добавляет окно для пометки в входящей почте для многочисленных операций.",
	["Open"] = "Окрыть",
	["Return"] = "Вернуть",
	["COD"] = "ОПД", -- Оплата При Доставке
	["Skipping"] = "Пропускаем",

	["Select options"] = "Опции выбора",
	["Options for the Select module"] = "Опции для модуля Выбора",
--tradeblock
	["TradeBlock"] = "Блокировать Торговлю",
	["Block incoming trade requests while in a mail session."] = "Блокировать все запросы на Торговлю во время отправки массовой почты",
--wire
	["Wire"] = "Оценка",
	["Set subject field to value of coins sent if subject is blank."] = "Пишет в теме письма количество монет, если тема не задана",
	["^%[%d+g %d+s %d+c%]$"] = "^%[%d+з %d+с %d+м%]$",
	["^%[%d+s %d+c%]$"] = "^%[%d+с %d+м%]$",
	["^%[%d+c%]$"] = "^%[%d+м%]$",
} end)
