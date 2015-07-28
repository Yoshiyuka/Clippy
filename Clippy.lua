local Clippy = LibStub("AceAddon-3.0"):NewAddon("Clippy", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0" );
local AceGUI = LibStub("AceGUI-3.0")

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

	--local KeywordFrame = AceGUI:Create("Dropdown")
	--KeywordFrame:SetList({ ["one"] = "Text One", ["two"] = "Text Two"})
	--KeywordFrame:SetValue("one")

	local KeywordCluster = AceGUI:Create("InlineGroup")
	local KeywordGroup = AceGUI:Create("SimpleGroup")
	local SubstituteCluster = AceGUI:Create("InlineGroup")
	local SubstituteGroup = AceGUI:Create("SimpleGroup")
	local item1 = AceGUI:Create("InteractiveLabel")
	local item2 = AceGUI:Create("InteractiveLabel")
	KeywordCluster:SetLayout("Flow")
	KeywordCluster:SetRelativeWidth(0.5)
	KeywordCluster:SetFullHeight(true)
	KeywordCluster:SetTitle("Keywords")
	KeywordGroup:SetLayout("Flow")

	SubstituteCluster:SetLayout("Flow")
	SubstituteCluster:SetRelativeWidth(0.5)
	SubstituteCluster:SetFullHeight(true)
	SubstituteCluster:SetTitle("Substitute Phrases")
	SubstituteGroup:SetLayout("Flow")

	item1:SetText("Something")
	KeywordGroup:AddChild(item1)
	item2:SetText("Else")
	SubstituteGroup:AddChild(item2)

	local NewKeyword = AceGUI:Create("Button")
	local NewPhrase = AceGUI:Create("Button")
	NewKeyword:SetText("New")
	NewKeyword:SetWidth(60)
	NewKeyword:SetHeight(30)

	NewKeyword:ClearAllPoints()
	NewKeyword:SetPoint("CENTER", 200, 22)
	NewPhrase:SetText("New")
	NewPhrase:SetWidth(60)
	NewPhrase:SetHeight(30)
	
	
	KeywordCluster:AddChild(NewKeyword)
	KeywordCluster:AddChild(KeywordGroup)
	SubstituteCluster:AddChild(NewPhrase)
	SubstituteCluster:AddChild(SubstituteGroup)

	container:AddChild(KeywordCluster)
	container:AddChild(SubstituteCluster)
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
	ClippyFrame = AceGUI:Create("Window")
	ClippyFrame:SetTitle("Clippy")
	ClippyFrame:SetHeight(768)
	ClippyFrame:SetWidth(1024)
	--ClippyFrame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    ClippyFrame:SetLayout("Fill")

    local TabGroup = AceGUI:Create("TabGroup")
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