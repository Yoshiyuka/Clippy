local Clippy = LibStub("AceAddon-3.0"):NewAddon("Clippy", "AceConsole-3.0", "AceHook-3.0")

function Clippy:OnInitialize()
  Clippy:RegisterChatCommand("clippy", "Clippy")
end

function Clippy:OnEnable()
    Clippy:SecureHook("ChatEdit_ParseText")
end

function Clippy:OnDisable()
end

function Clippy:ChatEdit_ParseText(chat, send)
	if(send == 1) then
		local old_text = chat:GetText()
		local new_text = string.gsub(old_text, "{(.-)}", function(s) return self:ParseText(s) end)
		chat:SetText(new_text)
	end
end

function Clippy:ParseText(text)
	return "test"
end

function Clippy:Clippy()
	print("hey")
end