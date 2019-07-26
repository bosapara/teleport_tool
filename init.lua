context = {}

minetest.register_tool("teleport_tool:tool", {
	description = "Teleport Tool",
	inventory_image = "tp_tool.png",
	range = 0,
	groups = {not_in_creative_inventory=1},
	on_use = function(itemstack, user, pointed_thing)

		local player = user:get_player_name()

		local players = {}

		local formspec = {
            "size[7.4,7.1] bgcolor[#080808BB;true] background[5,5;1,1;guibg.png;true] image[2.3,0.2;3.15,0.6;teleport_logo.png]image_button_exit[0.1,5.8;1.5,1.5;cancel.png;tpn;;false;false;cancel_pressed.png] image_button_exit[2,5.8;1.5,1.5;yellow.png;tphr;;false;false;yellow_pressed.png] image_button_exit[3.9,5.8;1.5,1.5;blue.png;tp;;false;false;blue_pressed.png] image_button_exit[5.8,5.8;1.5,1.5;accept.png;tpy;;false;false;accept_pressed.png] textlist[0.1,1;7.03,4.5;playerlist;"
        }		
		
        local is_first = true
        for _ , player in pairs(minetest.get_connected_players()) do
            local player_name = player:get_player_name()
            players[#players + 1] = player_name
            if not is_first then
                formspec[#formspec + 1] = ","
            end
            formspec[#formspec + 1] = minetest.formspec_escape(player_name)
            is_first = false
        end
        formspec[#formspec + 1] = "]"
		
		minetest.show_formspec(user:get_player_name(), "tool_form",table.concat(formspec, ""), false)

		context.limit_players = players
	end,
})


minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname=="tool_form" then
		
		if fields.playerlist then
			local event = minetest.explode_textlist_event(fields.playerlist)
			if event.type == "CHG" then
				context.limit_selected_idx = event.index
			end

		elseif fields.tp then
			local receiver = context.limit_players[context.limit_selected_idx]
			local privs = minetest.get_player_privs(player:get_player_name()).interact
			if privs and receiver and minetest.registered_chatcommands["tpr"] then
			local sender = player:get_player_name(player)	
			minetest.registered_chatcommands["tpr"]["func"](sender,receiver)
			end
			
		elseif fields.tphr then
			local receiver = context.limit_players[context.limit_selected_idx]
			local privs = minetest.get_player_privs(player:get_player_name()).interact
			if privs and receiver and minetest.registered_chatcommands["tphr"] then
			local sender = player:get_player_name(player)	
			minetest.registered_chatcommands["tphr"]["func"](sender,receiver)
			end
		elseif fields.tpy then
			--local receiver = context.limit_players[context.limit_selected_idx]
			local privs = minetest.get_player_privs(player:get_player_name()).interact
			if privs and minetest.registered_chatcommands["tpy"] then
			local name = player:get_player_name(player)

			minetest.registered_chatcommands["tpy"]["func"](name)
			end
		elseif fields.tpn then
			--local receiver = context.limit_players[context.limit_selected_idx]
			local privs = minetest.get_player_privs(player:get_player_name()).interact
			if privs and minetest.registered_chatcommands["tpn"] then
			local name = player:get_player_name(player)

			minetest.registered_chatcommands["tpn"]["func"](name)
			end
		end	

	end
end)


