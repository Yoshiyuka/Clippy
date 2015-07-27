--[[
Clippy
]]

local Clippy = CreateFrame("FRAME", "ClippyFrame")

Clippy:RegisterEvent("CHAT_MSG");

local function eventHandler(self, event, ...)
	print("AN EVENT");
end

Clippy:SetScript("OnEvent", eventHandler);

function Clippy_ChatEdit_ParseText(text, send)
	if(send == 1) then
		text:SetText(text:GetText() .. " wooo");
	end
end
function Clippy_SendChatMessage(text, chatType, languageIndex, channel)
	message("clippy send chat message");
end

hooksecurefunc("ChatEdit_ParseText", Clippy_ChatEdit_ParseText)
hooksecurefunc("SendChatMessage", Clippy_SendChatMessage)
