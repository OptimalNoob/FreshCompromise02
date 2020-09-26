#region CONTROLS

function control_inventory(){
	item_id = 0;
	item_used = false;
	var inventory_max = ds_list_size(player_inventory) - 1;
	if(input_UP) {
		if(selected_inventory > 0) audio_play_sound(sndMenu_up,10,0);
		selected_inventory = max(0, --selected_inventory);
	};
	if(input_DOWN) {
		if(selected_inventory < inventory_max) audio_play_sound(sndMenu_down,10,0);
		selected_inventory = min(inventory_max, ++selected_inventory);
	};
	if(input_ACTION1 && alarm[0] == -1){
		item_id = player_inventory[| selected_inventory];
		use_inventory_item(item_id);
	};
};

#endregion

#region DRAW UI

function draw_inventory(){
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	// Draw Base Inventory UI
	draw_sprite(sBP_inventory_itemList,0,336,112);
	draw_sprite(sBP_inventory_stats,0,736,112);
	draw_sprite(sBP_inventory_itemDescription,0,736,496);
	if(inMenu){
		draw_set_color(c_white);
		// Draw Item Cursor
		if(!ds_list_empty(player_inventory)) draw_rectangle(344,128 + (item_padding * selected_inventory),710,160 + (item_padding * selected_inventory),0);
		draw_set_color(c_black);
	};
	
	// Draw Item Inventory List
	if (!ds_list_empty(player_inventory)) {
		var item_dic_height = ds_grid_height(dict_items) - 1;
		var invyy = 0; repeat(ds_list_size(player_inventory)){
			var item_current = player_inventory[| invyy];
			var item_row = ds_grid_value_y(dict_items, dic_i.ID, 0, dic_i.ID, item_dic_height, item_current);
			var item_display = dict_items[# dic_i.NAME, item_row]; // Assign the Display Name column value from item_row
			var item_icon = dict_items[# dic_i.SPRITE, item_row]; // Assign the Sprite column value for item_row
			draw_sprite(item_icon,0,368,160 + (item_padding * invyy));
			draw_text(400,134 + (item_padding * invyy),item_display); // Draw the Display Name for the item
			invyy++;
		};
	};
	
	// Draw Stats
	draw_text(752,160,"HP: " + string(spud_hp) + "/" + string(spud_max_hp));
	
	// Draw Monies
	var player_money = format_number(spud_money);
	draw_text(752,432,"Money: " + player_money);
};

function draw_quests(){
	var quest_height = ds_grid_height(dict_quests) - 1;
	var questxx = 0 repeat(ds_list_size(spud_quests)){
		var quest_row = ds_grid_value_y(dict_quests, 0,0,0,quest_height, spud_quests[|questxx]);
		var quest_name = dict_quests[# dic_q.NAME, quest_row];
		draw_text(384,136 + (item_padding * questxx),quest_name)
		questxx++;
	};
};


#endregion

#region OTHER

function use_inventory_item(_itemid) {
	var item_row = ds_grid_value_y(dict_items, dic_i.ID, 0, dic_i.ID, ds_grid_height(dict_items), _itemid);
	var item_type = string_copy(string(_itemid),3,2);
	switch (item_type) {
		case "00":
			if (spud_hp < spud_max_hp) {
				item_used = true;
				audio_play_sound(sndItem_usePotion,10,0);
				var healing_factor = dict_items[# dic_i.HEAL, item_row];
				spud_hp = min(spud_max_hp, floor(spud_hp + (spud_max_hp * healing_factor)));
				ds_list_delete(player_inventory, selected_inventory);
				if (selected_inventory > 0) {
					selected_inventory--;	
				} else {
					selected_inventory = 0;
				};
			};
			break;
		default: break;
	};
	if (ds_list_empty(player_inventory)) inMenu = false;
};

function format_number(_number){ // Adds Commas in 4+ digit numbers
	var str = string(_number);
	var len = string_length(str);
	for(i = len - 3; i > 0; i -= 3){
		str = string_insert(",",str,i + 1);	
	}
	return str;
};

#endregion







	
