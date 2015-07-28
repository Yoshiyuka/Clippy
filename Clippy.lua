local Clippy = LibStub("AceAddon-3.0"):NewAddon("Clippy", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0" );
local AceGUI = LibStub("AceGUI-3.0")

local ClippyFrame = AceGUI:Create("Window")
local TabGroup = AceGUI:Create("TabGroup")

local function DrawMainTab(container)
	local desc = AceGUI:Create("Label")
	desc:SetText("Main Tab")
	desc:SetFullWidth(true)
	container:AddChild(desc)
end

local function DrawSubstitutesTab(container)
	local desc = AceGUI:Create("Label")
	desc:SetText("Substitutes Tab")
	desc:SetFullWidth(true)
	container:AddChild(desc)
end

local function SelectGroup(container, event, group)
	container:ReleaseChildren()
	if group == "main" then
		DrawMainTab(container)
	elseif group == "substitutes" then
		DrawSubstitutesTab(container)
	end
end

local function InitializeClippyFrame()
	ClippyFrame:SetTitle("Clippy")
	--ClippyFrame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    ClippyFrame:SetLayout("Fill")

    TabGroup:SetLayout("Flow")
    TabGroup:SetTabs({ {text="Main Menu", value="main"}, {text="Substitutes", value="substitutes"}})
    TabGroup:SetCallback("OnGroupSelected", SelectGroup)
    TabGroup:SelectTab("main")

    ClippyFrame:AddChild(TabGroup)
end

function Clippy:OnInitialize()
    --ClippyFrame:SetTitle("Clippy")
    InitializeClippyFrame()
    
  	Clippy:RegisterChatCommand("clippy", "Clippy")
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
	return "test"
end

function Clippy:Clippy()
	if(ClippyFrame:IsVisible()) then
		ClippyFrame:Hide()
	else
		ClippyFrame:Show()
	end
end