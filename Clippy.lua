local Clippy = LibStub("AceAddon-3.0"):NewAddon("Clippy", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0" );

local substitutes = {}

function Clippy:OnInitialize()
	print("on init")
	self.db = LibStub("AceDB-3.0"):New("ClippyDB")
	if(self.db.profile.substitutes ~= nil) then
		print("db substitutes not nil. Loading.")
		substitutes = self.db.profile.substitutes
	else
		print("db substitutes is nil. Ignoring.")
	end
  	Clippy:RegisterChatCommand("clippy", "Clippy")
  	Clippy:RegisterChatCommand("clippy-new", "NewSubstitute")
  	Clippy:RegisterChatCommand("clippy-add", "AddSubstitute")
  	Clippy:RegisterChatCommand("clippy-remove", "RemoveSubstitute")
  	Clippy:RegisterChatCommand("clippy-clear", "ClearSubstitutes")
  	Clippy:RegisterChatCommand("clippy-replace", "ReplaceSubstitute")
  	Clippy:RegisterChatCommand("clippy-index", "SubstituteIndex")
end

function Clippy:OnEnable()
	print("On Enable")
    Clippy:SecureHook("ChatEdit_ParseText")
end

function Clippy:OnLoad()
	print("On Load")
	if(self.db.profile.substitutes ~= nil) then
		substitutes = self.db.profile.substitutes
	end
end

function Clippy:OnDisable()
	self.db.profile.substitutes = substitutes
end

function Clippy:ChatEdit_ParseText(chat, send)
	if(send == 1) then
		local old_text = chat:GetText()
		local new_text = string.gsub(old_text, "{(.-)}", function(s) return self:ParseText(s) end)
		chat:SetText(new_text)
	end
end

function Clippy:ParseText(text)
	if(substitutes[text] ~= nil) then
		return (substitutes[text][math.random(#substitutes[text])])
	else
		return text
	end
end

function Clippy:Clippy()
end

function Clippy:NewSubstitute(arguments)
	local name, default = Clippy:GetArgs(arguments, 2)
	if(substitutes[name] == nil) then
		print("Setting " .. name .. " in substitutes table with default substitution of: " .. default)
		substitutes[name] = {default}
		self.db.profile.substitutes = substitutes
	else
		print("Substitute(s) already exist for " .. name)
	end
end

function Clippy:AddSubstitute(arguments)
	local name, sub = Clippy:GetArgs(arguments, 2)
	if(substitutes[name] ~= nil) then
		print("Adding " .. sub .. " to potential substitutes for " .. name)
		table.insert(substitutes[name], sub)
		table.insert(self.db.profile.substitutes[name], sub)
	else
		print(name .. " is not an existing substitute table. Creating a new table for " .. name)
		Clippy:NewSubstitute(arguments)
	end
end

function Clippy:RemoveSubstitute(arguments)
end

function Clippy:ClearSubstitutes(arguments)
	name = Clippy:GetArgs(arguments, 1)

	for k in pairs(substitutes[name]) do
		substitutes[name][k] = nil
	end
	for k in pairs(self.db.profile.substitutes[name]) do
		self.db.profile.substitutes[name][k] = nil
	end
	substitutes[name] = nil
	self.db.profile.substitutes[name] = nil
end

function Clippy:ReplaceSubstitute(arguments)
end

function Clippy:SubstituteIndex(arguments)
end