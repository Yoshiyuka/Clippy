local Clippy = LibStub("AceAddon-3.0"):NewAddon("Clippy", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0" );

local substitutes = {}

function Clippy:OnInitialize()
  	Clippy:RegisterChatCommand("clippy", "Clippy")
  	Clippy:RegisterChatCommand("clippy-new", "NewSubstitute")
  	Clippy:RegisterChatCommand("clippy-add", "AddSubstitute")
  	Clippy:RegisterChatCommand("clippy-remove", "RemoveSubstitute")
  	Clippy:RegisterChatCommand("clippy-clear", "ClearSubstitutes")
  	Clippy:RegisterChatCommand("clippy-replace", "ReplaceSubstitute")
end

function Clippy:OnEnable()
    Clippy:SecureHook("ChatEdit_ParseText")
end

function Clippy:OnDisable()
	AceGUI:Release(ClippyFrame)
end

function Clippy:ChatEdit_ParseText(chat, send)
	if(send == 1) then
		local old_text = chat:GetText()
		local new_text = string.gsub(old_text, "{(.-)}", function(s) return self:ParseText(s) end)
		chat:SetText(new_text)
	end
end

function Clippy:ParseText(text)
	print(substitutes[text])
	return substitutes[text]
end

function Clippy:Clippy()
	if(ClippyFrame:IsVisible()) then
		ClippyFrame:Hide()
	else
		ClippyFrame:Show()
	end
end

function Clippy:NewSubstitute(arguments)
	local name, default = Clippy:GetArgs(arguments, 2)
	if(substitutes[name] == nil) then
		print("Setting " .. name .. " in substitutes table with default substitution of: " .. default)
		substitutes[name] = {default}
	else
		print("Substitute(s) already exist for " .. name)
	end
end

function Clippy:AddSubstitute(arguments)
	local name, sub = Clippy:GetArgs(arguments, 2)
	if(substitutes[name] ~= nil) then
		print("Adding " .. sub .. " to potential substitutes for " .. name)
		table.insert(substitutes[name], sub)
	else
		print(name .. " is not an existing substitute table. Creating a new table for " .. name)
		Clippy:NewSubstitute(arguments)
	end
end

function Clippy:RemoveSubstitute(arguments)
end

function Clippy:ClearSubstitutes(arguments)
end

function Clippy:ReplaceSubstitute(arguments)
end