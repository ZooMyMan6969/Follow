local plugin_label = "Follow"
local menu = {}

menu.elements = {
  main_tree = tree_node:new(0),
  main_toggle = checkbox:new(false, get_hash(plugin_label .. "_main_toggle")),
  follow_toggle = checkbox:new(false, get_hash(plugin_label .. "Follow")),
  keybind = keybind:new(0x0A, true, get_hash("keybind")),
}

function menu.render()
  if not menu.elements.main_tree:push("Follow") then
    return
  end

  menu.elements.main_toggle:render("Enable", "")
  if not menu.elements.main_toggle:get() then
    menu.elements.main_tree:pop()
    return
  end

  menu.elements.follow_toggle:render("Follow Leader", "Folows Party Leader")
  menu.elements.keybind:render("Keybind for Ally ID", "")

end

return menu
