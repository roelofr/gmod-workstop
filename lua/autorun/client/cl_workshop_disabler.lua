--[[
    Disables the workshop
    This file overrides some sandbox hooks to disable the workshop

    This work is licensed under the GNU General Public Licene version 3.
    The source code is available at https://github.com/roelofr/gmod-workstop
]]--

if not spawnmenu or not spawnmenu.GetCreationTabs then return end

if workstop_creation_tabs_old == nil then
    workstop_creation_tabs_old = spawnmenu.GetCreationTabs
end

surface.CreateFont('WorkstopDisabledIcon', {
    font = "Roboto",
    size = ScrH() / 10,
	antialias = true,
})

local warningText = [[
It looks like you're subscribed to the "Workstop" addon.
This is why you're seeing this message instead of the Workshop dupes and saves you were expecting.
We highly recommend you unsubscribe from this addon, as it's for server-side use only.
]]

local function replaceContentWithSomeNode()

    local cVar, url, innerPanel, panel

    cVar = GetConVar("workshop_disable_url")
    url = cVar:GetString()

    -- Check if we have a domain that's long enough
    local hasUrl = string.len(string.Trim(url)) >= 12 -- http://x.co/ is 12, expect at least that

    -- tmg-clan.com is a spam-domain now (*sad beep*) so blacklist it
    if string.Left(url, 19) == 'http://tmg-clan.com' then
        hasUrl = false
    end

    panel = vgui.Create("DPanel")
    panel:SetPaintBackgroundEnabled( false )
    panel:SetPaintBorderEnabled( false )
    panel:DockMargin( 0, 0, 0, 0 )

    -- Check if we actually want an HTML panel
    if hasUrl then
        innerPanel = vgui.Create( "DHTML", panel )
        innerPanel:OpenURL( url )
    else
        local innerTitle, innerCaption
        innerPanel = vgui.Create( 'DPanel', panel )
        innerPanel:DockPadding( 32, 32, 32, 32 )
        innerPanel:SetContentAlignment( 5 ) -- Align center
        innerPanel:SetBackgroundColor( Color( 45, 55, 72, 255 ) )

        -- Determine sizes
        surface.SetFont('WorkstopDisabledIcon')
        local _, titleHeight = surface.GetTextSize("Workshop unavailable")
        surface.SetFont('DermaLarge')
        local _, captionHeight = surface.GetTextSize("The server owner has disabled Workshop dupes and saves")

        innerTitle = vgui.Create( 'DLabel', innerPanel )
        innerTitle:Dock( TOP )
        innerTitle:DockMargin( 0, 0, 0, 16 )
        innerTitle:SetText( "Workshop unavailable" )
        innerTitle:SetFont( 'WorkstopDisabledIcon' )
        innerTitle:SetContentAlignment( 1 )
        innerTitle:SetTextColor( Color( 226, 232, 240, 255 ) )
        innerTitle:SetPaintBackgroundEnabled( false )
        innerTitle:SetPaintBorderEnabled( false )
        innerTitle:SetHeight( titleHeight * 2 )

        innerCaption = vgui.Create( 'DLabel', innerPanel )
        innerCaption:Dock( TOP )
        innerCaption:SetText( "The server owner has disabled the use of dupes and saves loaded from the Workshop." )
        innerCaption:SetWrap( true )
        innerCaption:SetFont( 'DermaLarge' )
        innerCaption:SetContentAlignment( 4 )
        innerCaption:SetTextColor( Color( 203, 213, 224, 255 ) )
        innerCaption:SetPaintBackgroundEnabled( false )
        innerCaption:SetPaintBorderEnabled( false )
        innerCaption:SetHeight( captionHeight * 3 )
    end

    -- Make sure the panel fills the WHOLE screen
    innerPanel:Dock( FILL )
    innerPanel:DockMargin( 0, 0, 0, 0 )

    if steamworks.IsSubscribed( "256758253" ) or game.SinglePlayer() then
        local unsubscribe, unsubscribeTitle, unsubscribeText, unsubscribeButton, unsubscribeColor

        unsubscribeColor = Color( 192, 86, 33, 255 )

        -- Add unsubscribe panel
        unsubscribe = vgui.Create("DPanel", panel)
        unsubscribe:Dock( TOP )
        unsubscribe:DockMargin( 2, 2, 2, 2 )
        unsubscribe:SetPaintBackgroundEnabled( false )
        unsubscribe:SetPaintBorderEnabled( false )

        -- Warning title
        unsubscribeTitle = vgui.Create( "DLabel", unsubscribe )
        unsubscribeTitle:Dock( TOP )
        unsubscribeTitle:DockMargin( 16, 8, 16, 8 )
        unsubscribeTitle:SetText( "Warning" )
        unsubscribeTitle:SetWrap( true )
        unsubscribeTitle:SetFont( "DermaLarge" )
        unsubscribeTitle:SetPaintBackgroundEnabled( false )
        unsubscribeTitle:SetPaintBorderEnabled( false )
        unsubscribeTitle:SetColor( unsubscribeColor )

        -- Subscribed warning
        unsubscribeText = vgui.Create( "DLabel", unsubscribe )
        unsubscribeText:Dock( TOP )
        unsubscribeText:DockMargin( 16, 8, 16, 8 )
        unsubscribeText:SetText(warningText)
        unsubscribeText:SetWrap( true )
        unsubscribeText:SetFont( "DermaDefault" )
        unsubscribeText:SetPaintBackgroundEnabled( false )
        unsubscribeText:SetPaintBorderEnabled( false )
        unsubscribeText:SetColor( unsubscribeColor )
        unsubscribeText:SetAutoStretchVertical( true )

        -- Unsubscribe button
        unsubscribeButton = vgui.Create( "DButton", unsubscribe )
        unsubscribeButton:Dock( TOP )
        unsubscribeButton:DockMargin( 16, 0, 16, 8 )
        unsubscribeButton:SetText( 4, 8, 4, 8 )
        unsubscribeButton:SetText( "View Workstop on Workshop" )
        unsubscribeButton:SetFont( "DermaDefault" )

        -- Show Workshop addon on click
        function unsubscribeButton:DoClick()
            -- Open Steam Workshop on the correct page
            steamworks.ViewFile( 256758253 )
        end

        -- Make it a warning message
        unsubscribe.Paint = function( w, h )
            local w, h = unsubscribe:GetSize()
            draw.RoundedBox( 4, 0, 0, w, h, Color( 237, 137, 54, 255 ) )
            draw.RoundedBox( 4, 1, 1, w-2, h-2, Color( 255, 250, 240, 255 ) )
        end

        -- Size to contents
        unsubscribe:InvalidateLayout(true)

        -- Resize kids
        unsubscribeTitle:SizeToContentsY(8)
        unsubscribeText:SizeToContentsY(8)
        unsubscribeButton:SizeToContentsY(8)

        -- Reset heights if we need to
        if (unsubscribeTitle:GetTall() + unsubscribeText:GetTall() + unsubscribeButton:GetTall()) > ScrH() then
            local _, height
            -- Determine size of title
            surface.SetFont('DermaLarge')
            _, height = surface.GetTextSize('Words')
            unsubscribeTitle:SetHeight( height * 1 )

            -- Determine size of text
            surface.SetFont('DermaDefaultBold')
            _, height = surface.GetTextSize('Words')
            unsubscribeText:SetHeight( height * 4 )

            -- Determine size of button
            surface.SetFont('DermaDefault')
            _, height = surface.GetTextSize('Words')
            unsubscribeButton:SetHeight( height * 2 )
        end

        -- Re-invalidate layout
        unsubscribe:InvalidateLayout( true )

        -- Resize message height
        unsubscribe:SizeToChildren( false, true )
        unsubscribe:SetHeight(unsubscribe:GetTall() + 16)
    end

    return panel
end

--[[
    Override the tabs so we can insert our own content here
]]--
spawnmenu.GetCreationTabs = function()

    local _tabs = workstop_creation_tabs_old()
    local out = {}

    local Hide = { "saves", "dupes" }
    for key, val in pairs( _tabs ) do
        local skip = false
        for _, hid in pairs( Hide ) do
            local _x = "." .. hid
            if string.Right( key, string.len( _x ) ) == _x then
                skip = true
            end
        end

        if not skip then
            out[key]=val
        else
            out[key]=val
            table.Merge( out[key], { Function = function()
                return replaceContentWithSomeNode()
            end } )
        end
    end
    return out
end

--[[
    Override the spawnmenu tabs,
    Main way to add tabs, although it fails sometimes
]]--

local function overrideSpawnmenuTabs()
    spawnmenu.AddCreationTab( "#spawnmenu.category.dupes", function()
        return replaceContentWithSomeNode()
    end, "icon16/control_repeat_blue.png", 200 )

    spawnmenu.AddCreationTab( "#spawnmenu.category.saves", function()
        return replaceContentWithSomeNode()
    end, "icon16/disk_multiple.png", 200 )
end

overrideSpawnmenuTabs()

timer.Simple( 0, overrideSpawnmenuTabs )
hook.Add( "PlayerSpawn", overrideSpawnmenuTabs )

print( " --[ Workshop disabler loaded ]-- " )
