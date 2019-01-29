-- ruRU (Russian/Русский) translation
if GetLocale() ~= "ruRU" then return end

local L = AnnounceInterrupts_Locales

L.enable_addon = "Включить аддон"

L.active_raid = "Включить в рейде"
L.active_party = "Включить в подземельях на 5 игроков"
L.active_BG = "Включить на поле боя"
L.active_arena = "Включить на арене"
L.active_scenario = "Включить в сценариях"
L.active_outdoors = "Включить в мире"

L.include_pet_interrupts = "Включить показ прерываний питомцем"
L.channel = "Канал:"

L.channel_say = "Сказать"
L.channel_raid = "Рейд"
L.channel_party = "Группа"
L.channel_instance = "Подземелье"
L.channel_yell = "Крикнуть"
L.channel_self = "Только для меня"
L.channel_emote = "Эмоция"
L.channel_whisper = "Личное сообщение"
L.channel_custom = "Другой канал"

L.output = "Сообщение:"

L.hint = "Синтаксис:\n%t написать имя цели\n%sl отправить ссылку на прерванное заклинание\n%sn написать имя прерванного заклинания\n%sc написать школу прерванного заклинания\n%ys написать название заклинания, которое вы использовали для кика"

L.defualt_message = "Прервал %sl у %t"

L.welcome_message = "Спасибо за установку Announce Interrupts! Для настройки аддона используйте слеш команду /ai"

L.smart_channel = "Автоматический выбор канала"

L.smart_details = "Если выбранный вами канал \nне доступен, аддон выберет\nлюбой канал самостоятельно."
