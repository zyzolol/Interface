local L = AceLibrary("AceLocale-2.2"):new("Automaton_Mailer")
Automaton_Mailer = Automaton:NewModule("Mailer", "AceHook-2.1", "AceEvent-2.0", "AceConsole-2.0", "AceDebug-2.0")
local module = Automaton_Mailer

L:RegisterTranslations("enUS", function() return {
	["Mailer"] = true,
	["Options for easy mailing."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Mailer"] = "수취인",
	["Options for easy mailing."] = "쉬운 우송을 위한 옵션을 설정합니다.",
} end)

L:RegisterTranslations("esES", function() return {
	["Mailer"] = "Correo",
	["Options for easy mailing."] = "Opciones para facilitar el env\195\173o de cartas",
} end)

L:RegisterTranslations("zhTW", function() return {
["Mailer"] = "簡易郵件",
["Options for easy mailing."] = "使收發郵件更加快捷",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Options for easy mailing."] = "使邮件收发更加简单",
} end)


module.description = L["Options for easy mailing."]
module.options = {
}

function module:OnInitialize()
	self.db = Automaton:AcquireDBNamespace("Mailer")
	Automaton:RegisterDefaults('Mailer', 'profile', {
		lastSent = ""
	})
	self:RegisterOptions(self.options)
end

function module:OnEnable()
	self:SecureHook("SendMail")
	self:RegisterEvent("MAIL_SHOW")
	self:RegisterEvent("MAIL_CLOSED")
	self:RegisterEvent("MAIL_SEND_SUCCESS")
end

function module:MAIL_SEND_SUCCESS()
	SendMailNameEditBox:SetText(self.db.profile.lastSent)
end

function module:SendMail(recipient)
	if recipient then
		self.db.profile.lastSent = recipient
	end
end

function module:MAIL_SHOW()
	self:SecureHook("ContainerFrameItemButton_OnModifiedClick")
end

function module:MAIL_CLOSED()
	self:Unhook("ContainerFrameItemButton_OnModifiedClick")
end

function module:ContainerFrameItemButton_OnModifiedClick(button)
	if button == "RightButton" and IsAltKeyDown() then
		PickupContainerItem(this:GetParent():GetID(), this:GetID())
		ClickSendMailItemButton()
		SendMailFrame_SendMail()
	end
end