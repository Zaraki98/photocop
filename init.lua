minetest.register_node("photocop:photocopieuse_inactive", {
  description = "Photocopieuse",
  drawtype = "nodebox",
  tiles = {
    'photocopieuse2b.png',
    'photocopieuse2.png',
    'photocopieuse2.png',
    'photocopieuse2.png',
    'photocopieuse2.png',
    'photocopieuse.png',
  },
  groups = {oddly_breakable_by_hand = 2},
  selection_box = {
    type = 'fixed',
    fixed = {-0.5,-0.5,-0.5,0.5,0.5,0.5}
  },
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.375,0.25,0.25,0.125}, 
			{-0.375,-0.4375,-0.5,0.0625,0.125,-0.375}, 
			{0.25,-0.0625,-0.3125,0.5,0.0625,0.0625}, 
		}
	},
  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    meta:set_string("infotext", "Photocopieuse")
    meta:set_string("formspec",
      "invsize[10,11;]"..
      "list[context;phinput;2,1;1,1;]"..
      "list[context;phoutput;6,1;2,2;]"..
      "list[context;phpapin;1,4;2,1;]"..
      "list[context;phinkin;3,4;1,1;]"..
      "list[context;phinkout;4,4;1,1;]"..
      "list[current_player;main;1,6;8,4;]"..
      "field[2,2;3.5,1;qttcopies;Copies : ;0]"..
      "image[4,1;1,1;photocop_fleche.png]"..
      "image[1.5,3;1,1;default_paper.png]"..
      "image[3,3;1,1;photocop_ink.png]"..
      "image[4,3;1,1;vessels_glass_bottle_inv.png]"..
      "image[6,4;1,1;photocop_ink.png^photocop_ink_level_monitor_font.png]"..
      "image[7,4;1,1;default_paper.png^photocop_ink_level_monitor_font.png]"
    )
    inv:set_size("phinput",1*1)
    inv:set_size("phoutput",2*2)
    inv:set_size("phpapin",2*1)
    inv:set_size("phinkin",1*1)
    inv:set_size("phinkout",1*1)
  end,
  allow_metadata_inventory_put = function(pos, listname, index, stack, player)
    if listname == "phinput" and stack:get_name() == "memorandum:letter" then return stack:get_count() end
    if listname == "phoutput" then return 0 end
    if listname == "phpapin" and stack:get_name() == "default:paper" then return stack:get_count() end
    if listname == "phinkin" and stack:get_name() == "photocop:encre" then return stack:get_count() end
    if listname == "phinkout" then return 0 end
    return 0
  end,
  on_metadata_inventory_put = function(pos, listname, index, stack, player)
    if listname == "phinkin" then
      if stack:get_metadata() == "" then
        stack:set_metadata("100")
      end
    end
    if (not inv:is_empty("phinput")) and (not inv:is_empty("phpapin")) and (not inv:is_empty("phinkin")) then
      phinputinv = inv:get_list("phinput")
      phinkininv = inv:get_list("phinkin")
      phpapininv = inv:get_list("phpapin")
      phoutputinv = inv:get_list("phoutput")
      phinkoutinv = inv:get_list("phinkout")
      minetest.set_node(pos, "photocop:photocopieuse_active")
      inv:set_list("phinput",phinputinv)
      inv:set_list("phoutput",phoutputinv)
      inv:set_list("phpapin",phpapininv)
      inv:set_list("phinkin",phinkininv)
      inv:set_list("phinkout",phinkoutinv)
      --photocopier(pos, inv)
    end
  end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
    if listname == "phinput" then return stack:get_count() end
    if listname == "phoutput" then return stack:get_count() end
    if listname == "phpapin" then return stack:get_count() end
    if listname == "phinkin" then return stack:get_count() end
    if listname == "phinkout" then return stack:get_count() end
    return 0
  end,
  allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
    if from_list == "phpapin" then
      if to_list == "phpapin" then return stack:get_count()
      end
    end
    if from_list == "phoutput" then
      if to_list == "phoutput" then return stack:get_count()
      end
    end
    return 0
  end
})

minetest.register_craftitem("photocop:encre", {
  inventory_image = "photocop_ink.png",
  description = "Cartouche d'encre",
  stack_max = 1
})

minetest.register_craft({
  output = "photocop:encre",
  recipe = {
    {"default:stick"},
    {"default:coal_lump"},
    {"vessels:glass_bottle"}
  }
})

minetest.register_craft({
  output = "photocop:photocopieuse_inactive",
  recipe = {
    {"default:steelblock", "default:glass", "default:steelblock"},
    {"default:chest", "pipeworks:sand_tube_000000", "default:chest"},
    {"default:steelblock", "default:steelblock", "default:steelblock"}
  }
})
