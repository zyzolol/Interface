-- frFR (French) translation
if GetLocale() ~= "frFR" then return end

local L = AnnounceInterrupts_Locales

L.enable_addon = "Activer l'addon"

L.active_raid = "Actif en groupe de raid"
L.active_party = "Actif en groupe de donjon"
L.active_BG = "Actif en champs de bataille"
L.active_arena = "Actif en arènes"
L.active_scenario = "Actif en scénarios"
L.active_outdoors = "Actif en extérieur"

L.include_pet_interrupts = "Inclure les interruptions du pet"
L.channel = "Canal:"

L.channel_say = "Dire"
L.channel_raid = "Raid"
L.channel_party = "Groupe"
L.channel_instance = "Instance"
L.channel_yell = "Crie"
L.channel_self = "Soi"
L.channel_emote = "Emote"
L.channel_whisper = "Chuchote"
L.channel_custom = "Canal personnalisé"

L.output = "Sortie:"

L.hint = "Référence:\n%t copie la cible\n%sl copie un lien du sort interrompu\n%sn copie le nom du sort interrompu\n%sc copie la nature du sort interrompu\n%ys copie le sort utilisé pour interrompre"

L.defualt_message = "Interrompu %sl sur %t"

L.welcome_message = "Merci d'avoir installé Announce Interrupts ! Pour configurer l'addon, utilisez la commande /ai"

L.smart_channel = "Détection de canal intelligente"

L.smart_details = "Si le canal sélectionné est\nindisponible, l'addon en sélectionnera\nautomatiquement un nouveau."
