local L = AceLibrary("AceLocale-2.2"):new("Talented")

L:RegisterTranslations("ruRU", function () return {
	["Talented - Talent Editor"] = "Talented - Редактор талантов",
	["Mode"] = "Режим",
	["Mode of operation."] = "Режим работы.",
	["Edit template"] = "Редактировать шаблон",
	["Toggle editing of the template."] = "Переключает режим редактирования шаблона.",
	["Apply template"] = "Применить шаблон",
	["Apply the current template to your character."] = "Применяет выбранный шаблон к вашему персонажу.",
	["Are you sure that you want to apply the current template's talents?"] = "Вы уверены что хотите раскидать таланты по выбранному шаблону?",
	["Delete template"] = "Удалить шаблон",
	["Delete the current template."] = "Удалить текущий шаблон.",
	["Are you sure that you want to delete this template?"] = "Вы уверены что хотите удалить этот шаблон?",
	["Import template"] = "Импорт шаблона",
	["Import a template from Blizzard's talent calculator."] = "Импорт шаблона из калькулятора талантов Blizzard.",
	["<full url of the template>"] = "<полная ссылка на шаблон>",
	["Export template"] = "Экспорт шаблона",
	["Export this template to your current chat channel."] = "Экспорт этого шаблона в ваш текущий канал чата.",
	["Write template link"] = "Вывод ссылки на шаблон",
	["Write a link to the current template in chat."] = "Вывод в чат ссылки на текущий шаблон.",
	["Template"] = "Шаблон",
	["New Template"] = "Новый шаблон",
	["Create a new Template."] = "Создать новый шаблон.",
	["New empty template"] = "Новый пустой шаблон",
	["Create a new template from scratch."] = "Создание нового шаблона с нуля.",
	["Copy current talent spec"] = "Копировать текущие таланты",
	["Create a new template from your current spec."] = "Создание нового шаблона на основе ваших талантов.",
	["Current template"] = "Текущий шаблон",
	["Select the current template."] = "Выбрать текущий шаблон.",
	["Sorry, I can't apply this template because you don't have enough talent points available (need %d)!"] = "Невозможно применить данный шаблон так как у вас недостаточно очков талантов (нужно %d)!",
	["Please wait while I set your talents..."] = "Подождите пока я раскидаю ваши таланты...",
	["Select %s"] = "Выбрать %s",
	["Copy from %s"] = "Копировать из %s",
	["Create a new template from %s."] = "Создать новый шаблон на основе %s.",
	["%s (%d)"] = "%s (%d)",
	["Copy of %s"] = "Копия %s",
	["Empty"] = "Пустой",
	["\"%s\" does not appear to be a valid URL!"] = "\"%s\" не является подходящей ссылкой!",
	["Imported"] = "Импортировано",
	["The given template is not a valid one! (%s)"] = "Представленный шаблон не корректен! (%s)",
	["Error while applying talents! Not enough talent points!"] = "Ошибка при применении талантов! Не хватает очков талантов!",
	["Template applied successfully, %d talent points remaining."] = "Шаблон применен успешно, осталось %d очков талантов.",
	["Talented - Template \"%s\" - %s :"] = "Talented - Шаблон \"%s\" - %s :",
	["%s :"] = "%s :",
	["_ %s"] = "_ %s",
	["_ %s (%d/%d)"] = "_ %s (%d/%d)",
	["Remove all talent points from this tree."] = "Удалить все очки талантов из этой ветки.",
	["%d/%d"] = "%d/%d",
	["Error! Talented window has been closed during template application. Please reapply later."] = "Ошибка! Talented был закрыт во время применения талантов. Повторите операцию позже.",
	["Talent application has been cancelled. %d talent points remaining."] = "Применение талантов было прервано. Осталось %d очков талантов.",
	["Are you sure that you want to learn \"%s (%d/%d)\" ?"] = "Вы уверены что хотите выучить \"%s (%d/%d)\" ?",
	["Options"] = "Настройки",
	["Options of Talented"] = "Настройки Talented",
	["Options for Talented."] = "Настройки Talented.",
	["Confirm Learning"] = "Подтверждать обучение",
	["Ask for user confirmation before learning any talent."] = "Спрашивать подтверждения пользователя при изучении каждого таланта.",
	["CHAT_COMMANDS"] = { "/talented" },
	["Layout options"] = "Параметры окна",
	["Options that change the visual layout of Talented."] = "Настройки, отвечающие за внешний вид Talented.",
	["Icon offset"] = "Смещение значков",
	["Distance between icons."] = "Расстояние между значками талантов.",
	["Frame scale"] = "Масштаб окна",
	["Overall scale of the Talented frame."] = "Общий масштаб окна Talented.",
	["Effective tooltip information not available"] = "Последняя версия информации о талантах недоступна",
	["Right-click to unlearn"] = "Правый клик для отмены",
	["Back to normal mode"] = "Назад в нормальный режим",
	["Return to the normal talents mode."] = "Вернуться в нормальный режим редактирования талантов.",
	["Switch to template mode"] = "Переключиться в режим шаблонов",
	["Enter template editing mode."] = "Войти в режим редактирования шаблонов.",
	["Edit talents"] = "Редактировать таланты",
	["Toggle editing of talents."] = "Переключает режим редактирования талантов.",
	["Talented cannot perform the required action because it does not have the required talent data available for class %s. You should inspect someone of this class."] = "Talented не может выполнить данную операцию так как отсутствуют необходимые данные о талантах для класса %s. Вы должны осмотреть какого-нибудь персонажа данного класса.",
	["You must install the Talented_Data helper addon for this action to work."] = "Для этого действия вы должны установить дополнительный аддон Talented_Data.",
	["You can download it from http://files.wowace.com/ ."] = "Вы можете загрузить его с сайта http://files.wowace.com/ .",
	["Export the template."] = "Экспортировать шаблон.",
	["Export to chat"] = "Экспорт в чат",
	["Export as URL"] = "Экспорт в виде ссылки",
	["Export to ..."] = "Экспорт для ...",
	["Send the template to another Talented user."] = "Отправить шаблон другому пользователю Talented.",
	["<name>"] = "<имя>",
	["Do you want to add the template \"%s\" that %s sent you ?"] = "Вы хотите добавить шаблон \"%s\", полученный вами от %s ?",
	["http://www.worldofwarcraft.com/info/classes/%s/talents.html?%s"] = "http://www.wow-europe.com/ru/info/basics/talents/%s/talents.html?%s",
	["Error while applying talents! Invalid template!"] = "Ошибка при распределении талантов! Неверный шаблон!",
	["Talent cap"] = "Лимит талантов",
	["Restrict templates to a maximum of 61 points."] = "Ограничить шаблоны максимум 61 очком талантов.",
	["Level %d"] = "Уровень %d",
	["Level restriction"] = "Ограничение по уровню",
	["Show the required level for the template, instead of the number of points."] = "Показывать требуемый для шаблона уровень персонажа вместо количества очков талантов.",
	["http://www.wowhead.com/?talent=%s"] = "http://www.wowhead.com/?talent=%s",
	["Export the template as a URL."] = "Экспорт шаблона в виде ссылки.",
	["WoW Talent Calculator"] = "Калькулятор талантов ВоВ",
	["Export the template as a URL to the official talent calculator"] = "Экспорт шаблона в виде ссылки для официального калькулятора талантов.",
	["Wowhead Talent Calculator"] = "Калькулятор талантов Wowhead",
	["Export the template as a URL to the wowhead talent calculator."] = "Экспорт шаблона в виде ссылки для калькулятора талантов Wowhead.",
	["Wowdb Talent Calculator"] = "Калькулятор талантов Wowdb",
	["Export the template as a URL to the wowdb talent calculator."] = "Экспорт шаблона в виде ссылки для калькулятора талантов Wowdb.",
	["Don't Confirm when applying"] = "Не подтверждать при применении шаблона",
	["Don't ask for user confirmation when applying full template."] = "Не спрашивать подтверждения талантов при применении шаблона. ",
	["Always try to learn talent"] = "Всегда пытаться выучить талант",
	["Always call the underlying API when a user input is made, even when no talent should be learned from it."] = "Всегда вызывать API для обучения талантов, даже если в результате этого вызова не должно быть ничего выучено.",
	["Default to edit"] = "Редактировать сразу",
	["Always show templates and talent in edit mode by default."] = "Всегда по-умолчанию показывать таланты и шаблоны в режиме редактирования.",
	["Talented_Data is outdated. It was created for %q, but current build is %q. Please update."] = "Talented_Data устарел. Он был создан для %q, а текущий билд %q. Обновитесь пожалуйста.",
	["Set as target"] = "Сделать целью",
	["Set this template as the target template, so that you may use it as a guide in normal mode."] = "Сделать этот шаблон целевым шаблоном чтобы вы могли использовать его как подсказку в нормальном режиме.",
	["Load outdated data"] = "Загружать устаревшие данные",
	["Load Talented_Data, even if outdated."] = "Загружать Talented_Data даже если он устарел.",
	["Loading outdated data. |cffff1010WARNING:|r Recent changes in talent trees might not be included in this data."] = "Загружаем устаревшие данные. |cffff1010ВНИМАНИЕ:|r Последние изменения в талантах могут быть не учтены в этих данных.",
	["Talented Links options."] = "Параметры ссылок Talented.",
	["Color Template"] = "Цветные шаблоны",
	["Toggle the Template color on and off."] = "Включает и выключает цветные шаблоны.",
	["Set Color"] = "Установить цвет",
	["Change the color of the Template."] = "Меняет цвет шаблона.",
	["Query Talent Spec"] = "Запрос специализации талантов",
	["From Rock"] = "От Rock",
	["Received talent information from LibRock."] = "Полученная информация о талантах от LibRock.",
	["Query"] = "Опрос пользователя",
	["Request a player's talent spec."] = "Запрос специализации талантов игрока.",
	["Query group"] = "Опрос группы",
	["Request talent information for your whole group (party or raid)."] = "Опрос информации о талантах у всей вашей группы или рейда.",
	["Clone selected"] = "Клонировать выбранный",
	["Make a copy of the current template."] = "Создаёт копию вашего текущего шаблона.",
	["Target: %s"] = "Цель: %s",
	["You have %d talent points left"] = "У вас осталось %d очков талантов",
	["Inspection of %s"] = "Осмотр %s",
	["Inspected Players"] = "Осмотренные игроки",
	["Talent trees of inspected players."] = "Деревья талантов осмотренных игроков.",
	["Hook Inspect UI"] = "Интеграция в ИП осмотра",
	["Hook the Talent Inspection UI."] = "Интеграция с ИП осмотра талантов.",
	["You can edit the name of the template here. You must press the Enter key to save your changes."] = "Здесь вы можете изменить название шаблона. Для сохранения изменений вы должны нажать Enter.",
} end)
