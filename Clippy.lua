local Hyponym = LibStub("AceAddon-3.0"):NewAddon("Hyponym", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0" );

local substitutes = {}

function Hyponym:OnInitialize()
	print("on init")
	self.db = LibStub("AceDB-3.0"):New("HyponymDB")
	if(self.db.profile.substitutes ~= nil) then
		print("db substitutes not nil. Loading.")
		substitutes = self.db.profile.substitutes
	else
		print("db substitutes is nil. Ignoring.")
	end
  	Hyponym:RegisterChatCommand("hyponym", "Hyponym")
  	Hyponym:RegisterChatCommand("hyponym-new", "NewSubstitute")
  	Hyponym:RegisterChatCommand("hyponym-add", "AddSubstitute")
  	Hyponym:RegisterChatCommand("hyponym-remove", "RemoveSubstitute")
  	Hyponym:RegisterChatCommand("hyponym-clear", "ClearSubstitutes")
  	Hyponym:RegisterChatCommand("hyponym-replace", "ReplaceSubstitute")
  	Hyponym:RegisterChatCommand("hyponym-index", "SubstituteIndex")
end

function Hyponym:OnEnable()
	print("On Enable")
    Hyponym:SecureHook("ChatEdit_ParseText")
end

function Hyponym:OnLoad()
	print("On Load")
	if(self.db.profile.substitutes ~= nil) then
		substitutes = self.db.profile.substitutes
	end
end

function Hyponym:OnDisable()
	self.db.profile.substitutes = substitutes
end

function Hyponym:ChatEdit_ParseText(chat, send)
	if(send == 1) then
		local old_text = chat:GetText()
		local new_text = string.gsub(old_text, "{(.-)}", function(s) return self:ParseText(s) end)
		chat:SetText(new_text)
	end
end

function Hyponym:ParseText(text)
	if(substitutes[text] ~= nil) then
		return (substitutes[text][math.random(#substitutes[text])])
	else
		return text
	end
end

function Hyponym:Hyponym()
end

function Hyponym:NewSubstitute(arguments)
	local name, default = Hyponym:GetArgs(arguments, 2)
	if(substitutes[name] == nil) then
		print("Setting " .. name .. " in substitutes table with default substitution of: " .. default)
		substitutes[name] = {default}
		self.db.profile.substitutes = substitutes
	else
		print("Substitute(s) already exist for " .. name)
	end
end

function Hyponym:AddSubstitute(arguments)
	local name, sub = Hyponym:GetArgs(arguments, 2)
	if(substitutes[name] ~= nil) then
		print("Adding " .. sub .. " to potential substitutes for " .. name)
		table.insert(substitutes[name], sub)
		table.insert(self.db.profile.substitutes[name], sub)
	else
		print(name .. " is not an existing substitute table. Creating a new table for " .. name)
		Hyponym:NewSubstitute(arguments)
	end
end

function Hyponym:RemoveSubstitute(arguments)
end

function Hyponym:ClearSubstitutes(arguments)
	name = Hyponym:GetArgs(arguments, 1)

	for k in pairs(substitutes[name]) do
		substitutes[name][k] = nil
	end
	for k in pairs(self.db.profile.substitutes[name]) do
		self.db.profile.substitutes[name][k] = nil
	end
	substitutes[name] = nil
	self.db.profile.substitutes[name] = nil
end

function Hyponym:ReplaceSubstitute(arguments)
end

function Hyponym:SubstituteIndex(arguments)
end