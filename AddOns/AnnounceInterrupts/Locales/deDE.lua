-- deDE (German) translation
if GetLocale() ~= "deDE" then return end

local L = AnnounceInterrupts_Locales

L.enable_addon = "Addon aktivieren"

L.active_raid = "in Raid-Instanzen aktivieren"
L.active_party = "in 5-Mann-Instanzen aktivieren"
L.active_BG = "in Schlachtfeldern aktivieren"
L.active_arena = "in der Arena aktivieren"
L.active_scenario = "in Szenarien aktivieren"
L.active_outdoors = "in der offenen Welt aktivieren"

L.include_pet_interrupts = "Unterbrechungen durch Diener mit einbeziehen"
L.channel = "Ausgabe-Kanal:"

L.channel_say = "Sagen"
L.channel_raid = "Schlachtzug"
L.channel_party = "Gruppe"
L.channel_instance = "Instanzchat"
L.channel_yell = "Schreien"
L.channel_self = "Nur mir selbst"
L.channel_emote = "Emote"
L.channel_whisper = "Flüstern"
L.channel_custom = "Spez. Chat-Kanal"

L.output = "Ausgabe:"

L.hint = "Hinweis:\n%t: Name des Ziels\n%sl: Verknüpfung des unterbrochenen Zaubers\n%sn: Name des unterbrochenen Zaubers\n%sc: Zauberschule des unterbrochenen Zaubers\n%ys: Name des Unterbrechungszaubers"

L.defualt_message = "%sl von %t unterbrochen"

L.welcome_message = "Danke, dass Sie Announce Interrupts installiert haben! Mit dem Befehl /ai können Sie das Addon konfigurieren."

L.smart_channel = "Automatische Ausgabe-Kanal-Erkennung"

L.smart_details = "Wenn der Ausgabe-Kanal den Sie gewählt\nhaben nicht verfügbar ist, sucht\ndas Addon automatisch einen anderen aus."
