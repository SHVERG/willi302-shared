local ConVar_ASS_Enabled = CreateClientConVar("cl_simfphys_advanced_steering_enabled", "1", true, false, "Enable Advanced Steering System")
local ConVar_ASS_Degree = CreateClientConVar("cl_simfphys_advanced_steering_degree", "900", true, false, "Degree of steering wheel", 0, 2000)
local ConVar_ASS_Smoothness = CreateClientConVar("cl_simfphys_advanced_steering_smoothness", "0.8", true, false, "Smoothness", 0, 1)

local k_door_d = CreateClientConVar( "cl_simfphys_bus_door_driver", KEY_PAD_0 , true, true )
local k_door_f = CreateClientConVar( "cl_simfphys_bus_door_front", KEY_PAD_1 , true, true )
local k_door_m = CreateClientConVar( "cl_simfphys_bus_door_middle", KEY_PAD_2 , true, true )
local k_door_r = CreateClientConVar( "cl_simfphys_bus_door_rear", KEY_PAD_3 , true, true )
local k_door_op = CreateClientConVar( "cl_simfphys_bus_doors_open", KEY_PAD_4 , true, true )
local k_door_cl = CreateClientConVar( "cl_simfphys_bus_doors_close", KEY_PAD_5 , true, true )
local k_routes_on = CreateClientConVar( "cl_simfphys_bus_routes_on", KEY_PAD_DECIMAL , true, true )

local k_el_on = CreateClientConVar( "cl_simfphys_els_on", KEY_PAD_ENTER , true, true )
local k_el_switch = CreateClientConVar( "cl_simfphys_els_switch", KEY_PAD_DECIMAL , true, true )
local k_s_off = CreateClientConVar( "cl_simfphys_siren_off", KEY_PAD_0 , true, true )
local k_s_1 = CreateClientConVar( "cl_simfphys_siren_mode_1", KEY_PAD_1 , true, true )
local k_s_2 = CreateClientConVar( "cl_simfphys_siren_mode_2", KEY_PAD_2 , true, true )
local k_s_3 = CreateClientConVar( "cl_simfphys_siren_mode_3", KEY_PAD_3 , true, true )

local k_list = {
	{k_door_d, KEY_PAD_0, "Open/Close Bus Driver's Door"},
	{k_door_f, KEY_PAD_1, "Open/Close Bus Front Door(s)"},
	{k_door_m, KEY_PAD_2, "Open/Close Bus Middle Door(s)"},
	{k_door_r, KEY_PAD_3, "Open/Close Bus Rear Door(s)"},
	{k_door_op, KEY_PAD_4, "Open All Bus Doors"},
	{k_door_cl, KEY_PAD_5, "Close All Bus Doors"},
	{k_routes_on, KEY_PAD_DECIMAL, "On/Off Route Indicator"},
	
	{k_el_on, KEY_PAD_ENTER, "On/Off Emergency Lights"},
	{k_el_switch, KEY_PAD_DECIMAL, "Switch Emergency Lights Mode"},
	{k_s_off, KEY_PAD_0, "Disable Siren"},
	{k_s_1, KEY_PAD_1, "Enable Siren (Mode 1)"},
	{k_s_2, KEY_PAD_2, "Enable Siren (Mode 2)"},
	{k_s_3, KEY_PAD_3, "Enable Siren (Mode 3)"},
}

local function Binder( x, y, tbl, num, parent)
	local sizex = 500
	local sizey = 40
	
	local kentry = tbl[num]
	local key = kentry[1]
	local setdefault = key:GetInt()
	
	local Shape = vgui.Create( "DShape", parent)
	Shape:SetType( "Rect" )
	Shape:SetPos( x, y )
	Shape:SetSize( 300, sizey )
	Shape:SetColor( Color( 0, 0, 0, 255 ) )
	
	local Shape = vgui.Create( "DShape", parent)
	Shape:SetType( "Rect" )
	Shape:SetPos( x + 1, y + 1 )
	Shape:SetSize( 298 - 2, sizey - 2 )
	Shape:SetColor( Color( 241, 241, 241, 255 ) )

	local binder = vgui.Create( "DBinder", parent)
	binder:SetPos( 300 + x, y )
	binder:SetSize( 500 - 300, sizey )
	binder:SetValue( setdefault )
	
	function binder:SetSelectedNumber( num )
		self.m_iSelectedNumber = num
		self:ConVarChanged( num ) 
		self:UpdateText() 
		self:OnChange( num ) 
		key:SetInt( num )
	end
	
	local TextLabel = vgui.Create( "DPanel", parent)
	TextLabel:SetPos( x, y )
	TextLabel:SetSize( 300, sizey )
	TextLabel.Paint = function()
		draw.SimpleText( kentry[3], "DSimfphysFont", 300 * 0.5, sizey * 0.5, Color( 100, 100, 100, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER ) 
	end
	
	return binder
end

local function BuildMenu( self )
	local Shape = vgui.Create( "DShape", self.PropPanel )
	Shape:SetType( "Rect" )
	Shape:SetPos( 20, 20 )
	Shape:SetSize( 350, 120 )
	Shape:SetColor( Color( 0, 0, 0, 200 ) )

	local box_ass_enabled = vgui.Create( "DCheckBoxLabel", self.PropPanel)
	box_ass_enabled:SetPos( 25,25 )
	box_ass_enabled:SetText( ConVar_ASS_Enabled:GetHelpText() )
	box_ass_enabled:SetConVar( ConVar_ASS_Enabled:GetName() )
	box_ass_enabled:SetValue( ConVar_ASS_Enabled:GetInt() )
	box_ass_enabled:SizeToContents()

	local slider_ass_degree = vgui.Create( "DNumSlider", self.PropPanel)
	slider_ass_degree:SetPos( 30,55 )
	slider_ass_degree:SetSize( 345,20 )
	slider_ass_degree:SetText( ConVar_ASS_Degree:GetHelpText() )
	slider_ass_degree:SetMin( ConVar_ASS_Degree:GetMin() )
	slider_ass_degree:SetMax( ConVar_ASS_Degree:GetMax() )
	slider_ass_degree:SetDecimals( 0 )
	slider_ass_degree:SetConVar( ConVar_ASS_Degree:GetName() )
	slider_ass_degree:SetValue( ConVar_ASS_Degree:GetFloat() )

	local slider_ass_smoothness = vgui.Create( "DNumSlider", self.PropPanel)
	slider_ass_smoothness:SetPos( 30,75 )
	slider_ass_smoothness:SetSize( 345, 20 )
	slider_ass_smoothness:SetText( ConVar_ASS_Smoothness:GetHelpText() )
	slider_ass_smoothness:SetMin( ConVar_ASS_Smoothness:GetMin() )
	slider_ass_smoothness:SetMax( ConVar_ASS_Smoothness:GetMax() )
	slider_ass_smoothness:SetDecimals( 2 )
	slider_ass_smoothness:SetConVar( ConVar_ASS_Smoothness:GetName() )
	slider_ass_smoothness:SetValue( ConVar_ASS_Smoothness:GetFloat() )
	
	local reset_ass = vgui.Create( "DButton" )
	reset_ass:SetParent( self.PropPanel )
	reset_ass:SetText( "Reset" )
	reset_ass:SetPos( 25, 105 )
	reset_ass:SetSize( 340, 25 )
	reset_ass.DoClick = function()
		box_ass_enabled:SetValue( 1 )
		slider_ass_degree:SetValue( 900 )
		slider_ass_smoothness:SetValue( 0.8 )

		ConVar_ASS_Enabled:SetInt( 1 )
		ConVar_ASS_Degree:SetFloat( 900 )
		ConVar_ASS_Smoothness:SetFloat( 0.8 )
	end
	
	local Background = vgui.Create( "DShape", self.PropPanel)
	Background:SetType( "Rect" )
	Background:SetPos( 20, 40+105 )
	Background:SetColor( Color( 0, 0, 0, 200 ) )
	
	local yy = 45+105
	local binders = {}
	for i = 1, table.Count( k_list ) do
		binders[i] = Binder(25,yy,k_list,i,self.PropPanel)
		yy = yy + 45
	end
	
	local ResetButton = vgui.Create( "DButton" )
	ResetButton:SetParent( self.PropPanel )
	ResetButton:SetText( "Reset" )
	ResetButton:SetPos( 25, yy + 10 )
	ResetButton:SetSize( 500, 25 )
	ResetButton.DoClick = function()
		for i = 1, table.Count( binders ) do
			local kentry = k_list[i]
			local key = kentry[1]
			local default = kentry[2]
			
			key:SetInt( default )
			binders[i]:SetValue( default )
		end
	end
	
	Background:SetSize( 510, yy-105 )
end

local function OpenRoutesMenu(v) --- Routes Menu
	local size_x = 600
	local size_y = 200
	
	local pos_x = ScrW()/2-size_x/2
	local pos_y = ScrH()/2-size_y/2
	
	local DFrame = vgui.Create("DFrame") --- Main Frame
	
	DFrame:SetPos(pos_x, pos_y)
	DFrame:SetSize(size_x, size_y)
	DFrame:SetTitle("Change Route")
	DFrame:MakePopup()
	
	local DPanel = vgui.Create("DPanel", DFrame)
	DPanel:Dock(TOP)
	DPanel:SetPaintBackground(false)
	
	--- Route Number
	
	local Num_Label = vgui.Create("DLabel", DPanel)
	Num_Label:Dock(LEFT)
	Num_Label:SetText("Route Number")
	Num_Label:SizeToContents()
	
	local Num_Text = vgui.Create("DTextEntry", DPanel)
	Num_Text:Dock(LEFT)
	Num_Text:SetMultiline(false)
	Num_Text:SetEditable(true)
	Num_Text:SetNumeric(true)
	Num_Text:SetAllowNonAsciiCharacters(true)
	Num_Text:SetValue(v.route_num or "")
	
	--- Route Letter
	
	local Let_Label = vgui.Create("DLabel", DPanel)
	Let_Label:Dock(LEFT)
	Let_Label:SetText("Route Letter")
	Let_Label:SizeToContents()
	
	local Let_Text = vgui.Create("DTextEntry", DPanel)
	Let_Text:Dock(LEFT)
	Let_Text:SetMultiline(false)
	Let_Text:SetEditable(true)
	Let_Text:SetAllowNonAsciiCharacters(true)
	Let_Text:SetValue(v.route_letter or "")
	
	--- First Route
	
	local Route1_Label = vgui.Create("DLabel", DFrame)
	Route1_Label:Dock(TOP)
	Route1_Label:SetText("First Route")
	
	local Route1_Text = vgui.Create("DTextEntry", DFrame)
	Route1_Text:Dock(TOP)
	Route1_Text:SetMultiline(false)
	Route1_Text:SetEditable(true)
	Route1_Text:SetAllowNonAsciiCharacters(true)
	Route1_Text:SetValue(v.route1 or "")
	
	--- Last Route
	
	local Route2_Label = vgui.Create("DLabel", DFrame)
	Route2_Label:Dock(TOP)
	Route2_Label:SetText("Last Route")
	
	local Route2_Text = vgui.Create("DTextEntry", DFrame)
	Route2_Text:Dock(TOP)
	Route2_Text:SetMultiline(false)
	Route2_Text:SetEditable(true)
	Route2_Text:SetAllowNonAsciiCharacters(true)
	Route2_Text:SetValue(v.route2 or "")
	
	
	local Change_Button = vgui.Create("DButton", DFrame)
	Change_Button:DockMargin(50, 0, 50, 0)
	Change_Button:Dock(BOTTOM)
	Change_Button:SetText("Change")
	
	Change_Button.DoClick = function()
		net.Start( "Simfphys_Routes_Menu" )
			net.WriteEntity( v )
			net.WriteString( Num_Text:GetValue() )
			net.WriteString( Let_Text:GetValue() )
			net.WriteString( Route1_Text:GetValue() )
			net.WriteString( Route2_Text:GetValue() )
		net.SendToServer()
	end
end

hook.Add( "SimfphysPopulateVehicles", "Willi302_Settings", function( pnlContent, tree, node )
	local node = tree:AddNode( "Willi302", "icon16/car.png" )
	node.DoPopulate = function( self )
		if self.PropPanel then return end
		
		self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
		self.PropPanel:SetVisible( false )
		self.PropPanel:SetTriggerSpawnlistChange( false )

		BuildMenu( self )
	end
	
	node.DoClick = function( self )
		self:DoPopulate()
		pnlContent:SwitchPanel( self.PropPanel )
	end
end )

concommand.Add("simfphys_change_route", function()
	local ply = LocalPlayer()
	if ply:GetSimfphys() != NULL then
		local v = ply:GetSimfphys()
		for k, veh in pairs(vehs_routes) do
			if v:GetModel() == veh.model then
				OpenRoutesMenu(v)
			end
		end
	end
end)

list.Set( "ContentCategoryIcons", "[simfphys] - Willi302's Cars", "icon16/willi302.png" )