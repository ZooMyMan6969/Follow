-- Load the custom menu
local menu = require("menu")

-- Function to follow the ally with the specific ID (524390)
local function follow_ally()
    -- Get the local player object and position
    local local_player = get_local_player()
    local player_position = get_player_position()

    if not player_position or not local_player then
        console.print("Local player or position is invalid.")
        return
    end

    -- Get a list of ally players
    local allies = actors_manager.get_ally_actors()
    
    -- Add debug print to check if any allies are retrieved
    if not allies or #allies == 0 then
        console.print("No ally players retrieved.")
    else
        console.print("Number of ally players found: ", #allies)
    end

    -- Filter to find the ally with the ID 524390
    local specific_ally = nil
    local specific_ally_id = 1573328

    for _, ally in ipairs(allies) do
        local ally_id = ally:get_id()
        local ally_position = ally:get_position()

        -- Add debug to print each ally's ID
        console.print("Found ally with ID: ", ally_id)

        -- Check if this ally's ID matches the specific one we want
        if ally_id == specific_ally_id then
            specific_ally = ally
            console.print("Found ally with specific ID: ", specific_ally_id)
        end
        
        -- Check if ally is within 2 units of distance from the player
        local distance_to_ally = player_position:dist_to(ally_position)
        if distance_to_ally <= 2 then
            console.print("Ally within 2 units: ID ", ally_id, " at distance ", distance_to_ally)
        end
    end

    -- If the specific ally was found, follow them
    if specific_ally then
        local ally_position = specific_ally:get_position()

        if not ally_position then
            console.print("Specific ally player's position is invalid.")
            return
        end

        -- If the ally is moving, follow them
        if specific_ally:is_moving() then
            local move_dest = specific_ally:get_move_destination()
            if move_dest then
                console.print("Following ally player to destination: ", move_dest)
                pathfinder.request_move(move_dest)  -- Move to the ally's destination
            else
                console.print("Ally player is moving but no move destination found.")
            end
        else
            console.print("Ally player is stationary, moving to position: ", ally_position)
            pathfinder.request_move(ally_position)  -- Follow directly if they're stationary
        end
    else
        console.print("No ally with the specific ID (524390) found.")
    end
end

-- Keybind functionality to print ally ID within 2 units of the cursor
local function print_ally_id_near_cursor()
    local cursor_position = get_cursor_position()
    if not cursor_position then
        console.print("Cursor position is invalid.")
        return
    end

    local allies = actors_manager.get_ally_actors()
    if not allies or #allies == 0 then
        console.print("No ally players found.")
        return
    end

    for _, ally in ipairs(allies) do
        local ally_position = ally:get_position()
        local distance_to_cursor = cursor_position:dist_to(ally_position)
        if distance_to_cursor <= 2 then
            console.print("Ally ID within 2 units of cursor: ", ally:get_id())
        end
    end
end

-- Register the keybind
on_key_press(function(key)
    if key == 0x20 then  -- Check if spacebar is pressed (0x20 is the key code for spacebar)
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
