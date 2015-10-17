local Synonym = LibStub("AceAddon-3.0"):NewAddon("Synonym", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0" );

local substitutes = {}

function Synonym:OnInitialize()
	print("on init")
	self.db = LibStub("AceDB-3.0"):New("SynonymDB")
	if(self.db.profile.substitutes ~= nil) then
		print("db substitutes not nil. Loading.")
		substitutes = self.db.profile.substitutes
	else
		print("db substitutes is nil. Ignoring.")
	end
  	Synonym:RegisterChatCommand("synonym", "Synonym")
  	Synonym:RegisterChatCommand("synonym-new", "NewSubstitute")
  	Synonym:RegisterChatCommand("synonym-add", "AddSubstitute")
  	Synonym:RegisterChatCommand("synonym-remove", "RemoveSubstitute")
  	Synonym:RegisterChatCommand("synonym-clear", "ClearSubstitutes")
  	Synonym:RegisterChatCommand("synonym-replace", "ReplaceSubstitute")
  	Synonym:RegisterChatCommand("synonym-index", "SubstituteIndex")
end

function Synonym:OnEnable()
	print("On Enable")
    Synonym:SecureHook("ChatEdit_ParseText")
end

function Synonym:OnLoad()
	print("On Load")
	if(self.db.profile.substitutes ~= nil) then
		substitutes = self.db.profile.substitutes
	end
end

function Synonym:OnDisable()
	self.db.profile.substitutes = substitutes
end

function Synonym:ChatEdit_ParseText(chat, send)
	if(send == 1) then
		local old_text = chat:GetText()
		local new_text = string.gsub(old_text, "{(.-)}", function(s) return self:ParseText(s) end)
		chat:SetText(new_text)
	end
end

function Synonym:ParseText(text)
	if(substitutes[text] ~= nil) then
		return (substitutes[text][math.random(#substitutes[text])])
	else
		return text
	end
end

function Synonym:Synonym()
end

function Synonym:NewSubstitute(arguments)
	local name, default = Synonym:GetArgs(arguments, 2)
	if(substitutes[name] == nil) then
		print("Setting " .. name .. " in substitutes table with default substitution of: " .. default)
		substitutes[name] = {default}
		self.db.profile.substitutes = substitutes
	else
		print("Substitute(s) already exist for " .. name)
	end
end

function Synonym:AddSubstitute(arguments)
	local name, sub = Synonym:GetArgs(arguments, 2)
	if(substitutes[name] ~= nil) then
		print("Adding " .. sub .. " to potential substitutes for " .. name)
		table.insert(substitutes[name], sub)
		table.insert(self.db.profile.substitutes[name], sub)
	else
		print(name .. " is not an existing substitute table. Creating a new table for " .. name)
		Synonym:NewSubstitute(arguments)
	end
end

function Synonym:RemoveSubstitute(arguments)
end

function Synonym:ClearSubstitutes(arguments)
	name = Synonym:GetArgs(arguments, 1)

	for k in pairs(substitutes[name]) do
		substitutes[name][k] = nil
	end
	for k in pairs(self.db.profile.substitutes[name]) do
		self.db.profile.substitutes[name][k] = nil
	end
	substitutes[name] = nil
	self.db.profile.substitutes[name] = nil
end

function Synonym:ReplaceSubstitute(arguments)
end

function Synonym:SubstituteIndex(arguments)
end