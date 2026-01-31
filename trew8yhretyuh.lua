local menuOpen = false
local selectedIndex = 1
local currentMenu = "main"

----------------------------------------
-- MENU SCALE
----------------------------------------

local MENU_SCALE = 0.8

----------------------------------------
-- MENU STRUCTURE
----------------------------------------

local menus = {
    main = {
        title = "MAIN MENU",
        items = {
            { label = "Triggery", action = "triggery" },
        }
    },

    triggery = {
        title = "TRIGGERY",
        items = {
            { label = "Ogolne", action = "ogolne" },
            { label = "NeonRP", action = "neonrp" },
            { label = "FutureRP", action = "futurerp" },
        }
    },

    neonrp = {
        title = "NEONRP",
        items = {
            { 
                label = "Revive", 
                action = function() 
                    TriggerEvent('neon_ambulancejob:revivee', true)
                end 
            },
            { 
                label = "Job Policjanta", 
                action = function() 
                    TriggerEvent('esx:setJob', {name = "police", label = "Police", grade = 12, grade_name = "boss", grade_label = "Assistant Chief Of Police"})
                end 
            },
        }
    },

    ogolne = {
        title = "OGOLNE",
        items = {
            { label = "Hulk", action = function() 
                print("slisko")
            end },
        }
    },

    futurerp = {
        title = "FUTURERP",
        items = {
            { label = "AntyTroll", action = function()
                TriggerEvent("esx_identity:startProtection", -1)
            end },
        }
    }
}

----------------------------------------
-- OPEN / CLOSE MENU
----------------------------------------

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, 104) then -- H
            menuOpen = not menuOpen
            currentMenu = "main"
            selectedIndex = 1
        end
    end
end)

----------------------------------------
-- MENU CONTROLS
----------------------------------------

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if not menuOpen then goto skip end

        local items = menus[currentMenu].items
        local maxItems = #items

        -- UP
        if IsControlJustPressed(0, 172) then
            selectedIndex = selectedIndex - 1
            if selectedIndex < 1 then selectedIndex = maxItems end
        end

        -- DOWN
        if IsControlJustPressed(0, 173) then
            selectedIndex = selectedIndex + 1
            if selectedIndex > maxItems then selectedIndex = 1 end
        end

        -- ENTER
        if IsControlJustPressed(0, 176) then
            local action = items[selectedIndex].action
            if type(action) == "function" then
                action()
            elseif type(action) == "string" and menus[action] then
                currentMenu = action
                selectedIndex = 1
            end
        end

        -- BACKSPACE = zamyka menu od razu
        if IsControlJustPressed(0, 177) then
            menuOpen = false
            currentMenu = "main"
            selectedIndex = 1
        end

        ::skip::
    end
end)

----------------------------------------
-- DRAW MENU
----------------------------------------

function DrawMenu()
    local menuX = 0.20
    local startY = 0.30

    local menuWidth = 0.22 * MENU_SCALE
    local bannerHeight = 0.10 * MENU_SCALE
    local headerHeight = 0.03 * MENU_SCALE -- cieńszy nagłówek
    local itemHeight = 0.035 * MENU_SCALE

    local bannerY = startY - bannerHeight / 2

    DrawRect(menuX, bannerY, menuWidth, bannerHeight, 15, 15, 15, 240)

    SetTextFont(4)
    SetTextScale(0.60 * MENU_SCALE, 0.60 * MENU_SCALE)
    SetTextColour(0, 0, 0, 180)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString("STAR MARKET")
    DrawText(menuX + 0.0015, bannerY - 0.017 * MENU_SCALE)

    SetTextFont(4)
    SetTextScale(0.60 * MENU_SCALE, 0.60 * MENU_SCALE)
    SetTextColour(255, 215, 0, 255)
    SetTextCentre(true)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString("STAR MARKET")
    DrawText(menuX, bannerY - 0.017 * MENU_SCALE)

    local headerY = startY + headerHeight / 2
    DrawRect(menuX, headerY, menuWidth, headerHeight, 35, 35, 35, 230)

    SetTextFont(0)
    SetTextScale(0.35 * MENU_SCALE, 0.35 * MENU_SCALE)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(menus[currentMenu].title)
    local fontOffset = 0.35 * MENU_SCALE * 0.035
    DrawText(menuX, headerY - fontOffset)

    for i, item in ipairs(menus[currentMenu].items) do
        local y = startY + headerHeight + (i - 0.5) * itemHeight
        local selected = (i == selectedIndex)

        DrawRect(
            menuX,
            y,
            menuWidth,
            itemHeight,
            selected and 232 or 25, -- R
            selected and 206 or 25,  -- G
            selected and 2 or 25,  -- B
            selected and 230 or 200 -- alfa
        )

        SetTextFont(0)
        SetTextScale(0.28 * MENU_SCALE, 0.28 * MENU_SCALE)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        AddTextComponentString(item.label)
        DrawText(menuX - menuWidth / 2 + 0.010, y - 0.010)
    end
end

----------------------------------------
-- RENDER LOOP
----------------------------------------

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if menuOpen then
            DrawMenu()
        end
    end
end)

----------------------------------------
-- START MESSAGE
----------------------------------------

print("Star Market Menu Loaded - Press H to open menu")