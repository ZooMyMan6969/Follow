-- Load the custom menu
local menu = require("menu")

-- Function to follow the ally with specific ID 
local function follow_ally()
    local local_player = get_local_player()
    local player_position = get_player_position()

    if not player_position or not local_player then
        console.print("Local player or position is invalid.")
        return
    end

    local allies = actors_manager.get_ally_actors()

    if not allies or #allies == 0 then
        console.print("No ally players retrieved.")
    else
    end

    -- Ally ID
    local specific_ally = nil
    local specific_ally_id =

    for _, ally in ipairs(allies) do
        local ally_id = ally:get_id()
        local ally_position = ally:get_position()

        -- Check if this ally's ID matches the specific one we want
        if ally_id == specific_ally_id then
            specific_ally = ally
        end

        -- Check if ally is within 2 units of distance from the player
        local distance_to_ally = player_position:dist_to(ally_position)
        if distance_to_ally <= 5 then
        end
    end

    -- If the specific ally was found, follow them
    if specific_ally then
        local ally_position = specific_ally:get_position()

        if not ally_position then
            return
        end

        -- If the ally is moving, follow them
        if specific_ally:is_moving() then
            local move_dest = specific_ally:get_move_destination()
            if move_dest then
                console.print("Following ally player to destination: ", move_dest)
                pathfinder.request_move(move_dest)  -- Move to the ally's destination
            else
            end
        else
            pathfinder.request_move(ally_position)  -- Follow directly if they're stationary
        end
    else
        console.print("No ally with the specific ID found.")
    end
end

-- Keybind functionality to print ally ID within 1 unit of the cursor
local function print_ally_id_near_cursor()
    local cursor_position = get_cursor_position()
    if not cursor_position then
        console.print("Cursor position is invalid.")
        return
    end

    local allies = actors_manager.get_ally_actors()
    local local_player = get_local_player()

    if not allies or #allies == 0 then
        console.print("No ally players found.")
        return
    end

    for _, ally in ipairs(allies) do
        local ally_position = ally:get_position()

        -- Exclude local player
        if ally:get_id() ~= local_player:get_id() then
            local distance_to_cursor = cursor_position:dist_to(ally_position)
            if distance_to_cursor <= 1 then
                console.print("Ally ID within 1 units of cursor: ", ally:get_id())
            end
        else
            console.print("Skipping local player.")
        end
    end
end
-- Register the keybind
on_key_press(function(key)
    if key == 0x52 then  -- Check if spacebar is pressed (0x20 is the key code for spacebar)
        print_ally_id_near_cursor()
    end
end)

-- Main update function
on_update(function()
    local local_player = get_local_player()

    -- Ensure player exists and the main toggle is enabled
    if not local_player or not menu.elements.main_toggle:get() then
        return
    end

    -- Check if the follow toggle is enabled
    local follow_toggle = menu.elements.follow_toggle:get()

    -- If follow toggle is active, call the follow function
    if follow_toggle then
        follow_ally()
    end
end)

-- Register the menu render callback
on_render_menu(menu.render)
