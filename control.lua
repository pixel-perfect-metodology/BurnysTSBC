
--[[
=====BURNYS TRAIN STATION BLUEPRINT CREATOR=====

Depending on setting on the GUI, this mod will convert the GUI input into some commands which create a blueprint.
This mod is handy for situations where you don't want to spend 5-30 minutes on designing a train station, instead use this mod and build a station in 10 seconds!
Sadly not everyone will be satisfied, since I can only offer a few layouts / variants of stations layouts, since they had to be compatible with scaling (trains station designs for 1000 cargo wagons were possible).
--]]

--[[stuff that broke the mod in 0.15:
assigning sprites to variables somehow broke it
the technology for blueprints is gone, so i changed it to requirement "construction robots" tech
]]--

local str_versionCheck = "0.0.8"

local btn_menu = "btn_menu"
local btn_menu2 = "btn_menu2"
local frame_menu = "frame_menu"
local chk_double_head = "chk_double_head"
local txt_locos = "txt_locos"
local txt_cargo = "txt_cargo"
local btn_station_type = "btn_station_type"
local btn_inserter_type = "btn_inserter_type"
local chk_use_filter = "chk_use_filter"
local btn_resource_type = "btn_resource_type"
local chk_use_chests = "chk_use_chests"
local btn_chest_type = "btn_chest_type"
local txt_chest_limit = "txt_chest_limit"
local btn_belt_type = "btn_belt_type"
local btn_direction_belt = "btn_direction_belt"
local btn_sides = "btn_sides"
local txt_fuel_request_amount = "txt_fuel_request_amount"
local chk_refuel = "chk_refuel"
local btn_fuel_type = "btn_fuel_type"
local chk_evenly_load = "chk_evenly_load"
local chk_connect_chests = "chk_connect_chests"
local chk_signals = "chk_signals"
local chk_lamps = "chk_lamps"
local btn_create_blueprint = "btn_create_blueprint"
local lbl_error_message = "lbl_error_message"


--tables for "lookups"
local station_types = {"loading","unloading"}--,"refuel"}
local inserter_types = {"inserter","fast-inserter","stack-inserter"}
--local resource_types = {"iron-ore","copper-ore","stone","coal","iron-plate","copper-plate","steel-plate","empty-barrel","crude-oil-barrel","iron-gear-wheel","copper-cable","electronic-circuit","advanced-circuit"}
local chest_types = {"iron-chest","steel-chest","logistic-chest-requester","logistic-chest-passive-provider","logistic-chest-active-provider","logistic-chest-storage"}
local belt_types = {"transport-belt", "fast-transport-belt", "express-transport-belt"}
local sides = {"both", "right", "left"}
local flow_directions = {"none","front","back"}--,"side"}
local fuel_types = {"raw-wood", "coal", "solid-fuel", "rocket-fuel", "uranium-fuel-cell"}

--setting initial data of players, if player is using the mod for the first time then default settings will be applied
function set_global_variables(player, data)
	if global["BurnysTSBC"] then
		if global["BurnysTSBC"][player.name] then
			global["BurnysTSBC"][player.name].versionCheck = str_versionCheck

			--player.print("Set new data to "..tostring(global["BurnysTSBC"][player.name].versionCheck).." "..str_versionCheck)

			global["BurnysTSBC"][player.name].bool_menu_open = data.bool_menu_open or false

			global["BurnysTSBC"][player.name].bool_double_head = true
			if data.bool_double_head ~= nil then
				global["BurnysTSBC"][player.name].bool_double_head = data.bool_double_head
			end

			global["BurnysTSBC"][player.name].int_locos = data.int_locos or 1
			global["BurnysTSBC"][player.name].int_cargo = data.int_cargo or 2
			global["BurnysTSBC"][player.name].int_station_type = data.int_station_type or 1
			global["BurnysTSBC"][player.name].int_inserter_type = data.int_inserter_type or 1

			global["BurnysTSBC"][player.name].bool_use_filter = true
			if data.bool_use_filter ~= nil then
				global["BurnysTSBC"][player.name].bool_use_filter = data.bool_use_filter
			end

			--global["BurnysTSBC"][player.name].int_resource_type = data.int_resource_type or 1 --obsolete since v0.0.5
			global["BurnysTSBC"][player.name].str_resource_type = "none"
			if data.str_resource_type ~= nil then
				global["BurnysTSBC"][player.name].str_resource_type = data.str_resource_type
			end

			global["BurnysTSBC"][player.name].bool_use_chest = true
			if data.bool_use_chest ~= nil then
				global["BurnysTSBC"][player.name].bool_use_chest = data.bool_use_chest
			end

			global["BurnysTSBC"][player.name].int_chest_type = data.int_chest_type or 1
			global["BurnysTSBC"][player.name].int_chest_limit = data.int_chest_limit or 5
			global["BurnysTSBC"][player.name].int_belt_type = data.int_belt_type or 1
			global["BurnysTSBC"][player.name].int_use_side = data.int_use_side or 1
			global["BurnysTSBC"][player.name].int_direction = data.int_direction or 1

			global["BurnysTSBC"][player.name].bool_refuel = false
			if data.bool_refuel ~= nil then
				global["BurnysTSBC"][player.name].bool_refuel = data.bool_refuel
			end
			global["BurnysTSBC"][player.name].int_refuel_type = data.int_refuel_type or 3
			global["BurnysTSBC"][player.name].int_refuel_request_amount = data.int_refuel_request_amount or 20

			global["BurnysTSBC"][player.name].bool_evenly_load = false
			if data.bool_evenly_load ~= nil then
				global["BurnysTSBC"][player.name].bool_evenly_load = data.bool_evenly_load
			end

			global["BurnysTSBC"][player.name].bool_connect_chests = false
			if data.bool_connect_chests ~= nil then
				global["BurnysTSBC"][player.name].bool_connect_chests = data.bool_connect_chests
			end

			global["BurnysTSBC"][player.name].bool_signals = true
			if data.bool_signals ~= nil then
				global["BurnysTSBC"][player.name].bool_signals = data.bool_signals
			end

			global["BurnysTSBC"][player.name].bool_lamps = true
			if data.bool_lamps ~= nil then
				global["BurnysTSBC"][player.name].bool_lamps = data.bool_lamps
			end

			global["BurnysTSBC"][player.name].str_error_message = data.str_error_message or "Errors will appear here"

			return global["BurnysTSBC"][player.name]
		else
			global["BurnysTSBC"][player.name] = {}
			set_global_variables(player, data)
		end
	else
		global["BurnysTSBC"] = {}
		set_global_variables(player, data)
	end
end

-- since lua didnt have a built in table-index function, this figures out the index / position of a "value" in a "table" (starting with 1), returns -1 if not found
local function index(table, value)
	for i = 1, #table, 1 do
		if table[i] == value then
			return i
		end
	end
	return -1
end

-- create a string from a list of items in a table (useful for converting tables to tooltips on the buttons)
local function tableToString(table)
	returnString = ""
	for i, value in ipairs(table) do
		if returnString ~= "" then
			returnString = returnString..", "
		end
		returnString = returnString..tostring(value)
	end
	return returnString
end

--create the main mod-gui menu with all the buttons and text inputs and stuffs
local function create_menu(player)
	--/c game.player.insert{name="blueprint", count=100}
	--player.print("helloo "..tostring(player))
	if global["BurnysTSBC"] == nil then
		global["BurnysTSBC"] = {}
	end
	data = global["BurnysTSBC"][player.name]
	if data == nil then
		data = set_global_variables(player, {})
	end

	frame = player.gui.left.add{type="frame", name=frame_menu, direction="vertical"}
	frame.add{type="checkbox", name=chk_double_head, state=data.bool_double_head, caption="Locomotives at each end? (double headed?)", tooltip="Does your train have locomotive(s) at both ends or only at the front end?"}

	frame.add{type="flow", name="flow_locos", direction="horizontal"}
	frame.flow_locos.add{type="textfield", name=txt_locos, text=tostring(data.int_locos), tooltip="How many locomotives does your train have at EACH end? Divide the total number of locomotives in half if you are using double headed trains."}
	frame.flow_locos.add{type="label", caption="# of locomotives per end"}

	frame.add{type="flow", name="flow_cargos", direction="horizontal"}
	frame.flow_cargos.add{type="textfield", name=txt_cargo, text=tostring(data.int_cargo), tooltip="How many cargo wagons does your train have?"}
	frame.flow_cargos.add{type="label", caption="# of cargo wagons"}

	frame.add{type="flow", name="flow_station_type", direction="horizontal"}
	frame.flow_station_type.add{type="label", caption="Station type:"}
	frame.flow_station_type.add{type="button", name=btn_station_type, caption=station_types[data.int_station_type], tooltip=tableToString(station_types)}

	frame.add{type="flow", name="flow_inserter_type", direction="horizontal"}
	frame.flow_inserter_type.add{type="label", caption="Inserter type:"}
	frame.flow_inserter_type.add{type="button", name=btn_inserter_type, caption=inserter_types[data.int_inserter_type], tooltip=tableToString(inserter_types)}
	--spr_inserter_type = frame.flow_inserter_type.add{type="sprite", name=spr_inserter_type, sprite="item/"..inserter_types[data.int_inserter_type]}
	frame.flow_inserter_type.add{type="sprite", name=spr_inserter_type, sprite="item/"..inserter_types[data.int_inserter_type]}

	frame.add{type="flow", name="flow_filter", direction="horizontal"}
	frame.flow_filter.add{type="checkbox", name=chk_use_filter, state=data.bool_use_filter, caption="use filter inserters?", tooltip="If yes: If previously normal or fast inserter is selected, then normal filter inserters will be used. If stack inserter is selected, then stack-filter-inserter will be used."}
	frame.flow_filter.add{type="label", caption="resource type:", tooltip="Enter the transported resource type here, even if you aren't using filter inserters. This setting is applied to requester chests or the \"load/unload chests evenly\" option, if ticked."}
	--frame.flow_filter.add{type="button", name=btn_resource_type, caption=resource_types[data.int_resource_type], tooltip=tableToString(resource_types)}
	--spr_resource_type = frame.flow_filter.add{type="sprite", name=spr_resource_type, sprite="item/"..resource_types[data.int_resource_type]}
	frame.flow_filter.add{type="button", name=btn_resource_type, caption=data.str_resource_type, tooltip="Hold an item in your mouse cursor and click this button, and the filter will be set to it. This way you don't accidently load copper-ore into a iron-ore train, or unload copper-ore into a iron-ore station.\n\nIf you are using \"load/unload chests evenly?\" then this item will be used for counting. If no item specified, then the total number of items in the chests will be used for counting."}
	if data.str_resource_type ~= "none" then
		--spr_resource_type = frame.flow_filter.add{type="sprite", name=spr_resource_type, sprite="item/"..data.str_resource_type}
		frame.flow_filter.add{type="sprite", name=spr_resource_type, sprite="item/"..data.str_resource_type}
	end

	frame.add{type="checkbox", name=chk_use_chests, state=data.bool_use_chest, caption="use chests as buffer?", tooltip="Please don't uncheck this unless you are a masochist. Trains would be stuck on this station forever! :s"}

	frame.add{type="flow", name="flow_chests", direction="horizontal"}
	frame.flow_chests.add{type="label", caption="Chest type:", tooltip="If you use logistic chests, belts and splitters will automatically be removed so that you can build thin and compact stations!"}
	frame.flow_chests.add{type="button", name=btn_chest_type, caption=chest_types[data.int_chest_type], tooltip=tableToString(chest_types)}
	--spr_chest_type = frame.flow_chests.add{type="sprite", name=spr_chest_type, sprite="item/"..chest_types[data.int_chest_type]}
	frame.flow_chests.add{type="sprite", name=spr_chest_type, sprite="item/"..chest_types[data.int_chest_type]}

	frame.add{type="flow", name="flow_chests_limit", direction="horizontal"}
	frame.flow_chests_limit.add{type="label", caption="Chest limit:"}
	frame.flow_chests_limit.add{type="textfield", name=txt_chest_limit, text=tostring(data.int_chest_limit), tooltip="Type in a negative number for no limit/restriction, or write in a number of how many slots are allowed to be filled up\nStack limits: ore=50, plates=100, circuits=200"}

	frame.add{type="flow", name="flow_belt_type", direction="horizontal"}
	frame.flow_belt_type.add{type="label", caption="Belt type:", tooltip="The splitter tech-equivalent will be automatically chosen."}
	frame.flow_belt_type.add{type="button", name=btn_belt_type, caption=belt_types[data.int_belt_type], tooltip=tableToString(belt_types)}
	--spr_belt_type = frame.flow_belt_type.add{type="sprite", name=spr_belt_type, sprite="item/"..belt_types[data.int_belt_type]}
	frame.flow_belt_type.add{type="sprite", name=spr_belt_type, sprite="item/"..belt_types[data.int_belt_type]}

	frame.add{type="flow", name="flow_direction", direction="horizontal"}
	frame.flow_direction.add{type="label", caption="Belt direction:", tooltip="The mod sends belts towards this direction (back = train station entrance). If you choose \"none\" then no additional belts will be created except for the ones at the start."}
	frame.flow_direction.add{type="button", name=btn_direction_belt, caption=flow_directions[data.int_direction], tooltip=tableToString(flow_directions)}

	frame.add{type="flow", name="flow_side", direction="horizontal"}
	frame.flow_side.add{type="label", caption="Sides to be used:", tooltip="Choose \"right\" and items will be placed only on the right side of the station. Choose \"both\" for highest load/unload throughput."}
	frame.flow_side.add{type="button", name=btn_sides, caption=sides[data.int_use_side], tooltip=tableToString(sides)}

	frame.add{type="flow", name="flow_fuel_request_amount", direction="horizontal"}
	frame.flow_fuel_request_amount.add{type="checkbox", name=chk_refuel, state=data.bool_refuel, caption="refill at this station?", tooltip="Places one requester chest with inserter next to each locomotive."}
	frame.flow_fuel_request_amount.add{type="textfield", name=txt_fuel_request_amount, text=tostring(data.int_refuel_request_amount), tooltip="How much fuel should be requested per requester chest next to each locomotive?"}

	frame.add{type="flow", name="flow_fuel_type", direction="horizontal"}
	frame.flow_fuel_type.add{type="label", caption="Fuel type:", tooltip="If using \"refill at this station?\" then here you can choose which fuel type to be requested."}
	frame.flow_fuel_type.add{type="button", name=btn_fuel_type, caption=fuel_types[data.int_refuel_type], tooltip=tableToString(fuel_types)}

	frame.add{type="checkbox", name=chk_evenly_load, state=data.bool_evenly_load, caption="load/unload chests evenly?", tooltip="This option makes use of MadZuri's smart loading/unloading trick with combintators and wires. \nChoose a resource next to \"use filter inserters?\" to set the combinator-counting to the specific item. \nThis will NOT work together with logistic chests and is a belt-only feature."}
	frame.add{type="checkbox", name=chk_connect_chests, state=data.bool_connect_chests, caption="connect all chests with green wire?", tooltip="Will connect all chests of each side with green wire. \nYou will have to do one more connection from left to right side, so the circuit network will count the number of items all chests contain. \nLeave a comment on the factorio mod website if you want this option for red wire too!"}
	frame.add{type="checkbox", name=chk_signals, state=data.bool_signals, caption="place signals next to station?", tooltip="If double headed train is used, two signals are placed near the rear of the train as it is expected that this train will exit the station where it came in. \nIf single headed train is used, one normal signal will be placed at the rear and one chain signal in the front."}
	frame.add{type="checkbox", name=chk_lamps, state=data.bool_lamps, caption="place lamps near poles?", tooltip="To brighten up the mood!"}

	frame.add{type="flow", name="flow_create", direction="horizontal"}
	frame.flow_create.add{type="button", name=btn_create_blueprint, caption="CREATE BLUEPRINT", tooltip="Hold an empty blueprint in your cursor (pick it up) and click this button, and the setup will be stored in the blueprint. \nIf any errors occur, it should show up next to the button. \nIf the game breaks, please leave a comment on the factorio mod website and I try to fix it as soon as I see the post!"}
	frame.flow_create.add{type="label", name=lbl_error_message, caption=data.str_error_message}
	return frame
	--player.print("You clicked the button!")
end

--reads data from the GUI and stores them into variables, so they can be processed by this mod without having to read the GUI twice
local function readGUIdata(player, frame)
	if (frame) then
		GUIdata = {}
		g = GUIdata
		g["versionCheck"] = global["BurnysTSBC"][player.name].versionCheck
		if g.versionCheck ~= str_versionCheck then
			--player.print("GUI read error: "..tostring(g["versionCheck"]).." "..str_versionCheck)
			set_global_variables(player, {})
			return "versionMismatch"
		end
		g["bool_double_head"] = frame.chk_double_head.state
		g["int_locos"] = tonumber(frame.flow_locos.txt_locos.text)
		g["int_cargo"] = tonumber(frame.flow_cargos.txt_cargo.text)
		g["int_station_type"] = index(station_types, frame.flow_station_type.btn_station_type.caption)
		g["int_inserter_type"] = index(inserter_types, frame.flow_inserter_type.btn_inserter_type.caption)
		g["bool_use_filter"] = frame.flow_filter.chk_use_filter.state
		--g["int_resource_type"] = index(resource_types, frame.flow_filter.btn_resource_type.caption) --obsolete since v0.0.5
		g["str_resource_type"] = frame.flow_filter.btn_resource_type.caption or "none"
		g["bool_use_chest"] = frame.chk_use_chests.state
		g["int_chest_type"] = index(chest_types, frame.flow_chests.btn_chest_type.caption)
		g["int_chest_limit"] = tonumber(frame.flow_chests_limit.txt_chest_limit.text)
		--if g["int_chest_limit"] < 0 then
			--g["int_chest_limit"] = 9999
		--end
		g["int_belt_type"] = index(belt_types, frame.flow_belt_type.btn_belt_type.caption)
		g["int_direction"] = index(flow_directions, frame.flow_direction.btn_direction_belt.caption)
		g["int_use_side"] = index(sides, frame.flow_side.btn_sides.caption)
		g["bool_refuel"] = frame.flow_fuel_request_amount.chk_refuel.state
		g["int_refuel_request_amount"] = tonumber(frame.flow_fuel_request_amount.txt_fuel_request_amount.text)
		g["int_refuel_type"] = index(fuel_types, frame.flow_fuel_type.btn_fuel_type.caption)
		g["bool_evenly_load"] = frame.chk_evenly_load.state
		g["bool_connect_chests"] = frame.chk_connect_chests.state
		g["bool_signals"] = frame.chk_signals.state
		g["bool_lamps"] = frame.chk_lamps.state
		return g
	end
	return nil
end

-- this is the function for "evenly loading / unloading" chests, was pretty difficult to create (i mean the code, the actual idea is rather easy to understand), since nobody has done a mod like this before
function add_madzuri_wire_setup(bpt, data, itemname, x1, y1, direction, yoffset)
	if not data.bool_evenly_load then
		return nil
	end
	yoffset = yoffset or 0
	start = #bpt - 4
	for j = #bpt - 4, #bpt do
		--creates connections between the inserters, between each chests, and connection inserter <-> chest
		bpt[j].connections={{green={{entity_id=j-1, circuit_id = 1}}, red = {{entity_id=j-6}}}}
		bpt[j-6].connections={{green={{entity_id=j-6-1}}}}
		if j ==  #bpt - 4 then
			bpt[j-1].connections = {{red={{entity_id=j-7}}, green={{entity_id=j}}}}
		end
	end
	actualx1 = x1
	actualx2 = x1 + 0.5
	direction1 = 2
	if x1 < 0 then
		actualx1 = x1
		actualx2 = x1 - 0.5
		direction1 = 6
	end

	--this creates the first combinator. only one is needd for loading station, two for unloading stations
	if data.str_resource_type ~= "none" then
		bpt[#bpt+1] = {
			entity_number = #bpt+1,
			name = itemname,
			position = {x=actualx1, y=y1 + 7 + 0.5 + yoffset},
			direction = direction1,
			connections={{green={{entity_id=#bpt-6, circuit_id = 1}}}},
			control_behavior={arithmetic_conditions={first_signal={
				type="item",
				--name=resource_types[data.int_resource_type],},
				name=data.str_resource_type,},
				constant=-6,
				operation="/",
				output_signal={type="item",
				--name=resource_types[data.int_resource_type]}},--resource_types[data.int_resource_type]}
				name=data.str_resource_type,}},
			}}
	else
		bpt[#bpt+1] = {
			entity_number = #bpt+1,
			name = itemname,
			position = {x=actualx1, y=y1 + 7 + 0.5 + yoffset},
			direction = direction1,
			connections={{green={{entity_id=#bpt-6, circuit_id = 1}}}},
			control_behavior={arithmetic_conditions={first_signal={
				type="virtual",
				--name=resource_types[data.int_resource_type],},
				name="signal-each",},
				constant=-6,
				operation="/",
				output_signal={type="virtual",
				--name=resource_types[data.int_resource_type]}},--resource_types[data.int_resource_type]}
				name="signal-each",}},
			}}
	end

	--i thought at first a 2nd arithmetic-combinator is required for unloading, but actually isnt. instead, what has to be reverse from
	--loading to unloading is: the "<" to ">" in the inserter, and "1" to "-1" in inserter in the condition setting
	if false then --station_types[data.int_station_type] == "unloading" then
		bpt[#bpt+1] = {
			entity_number = #bpt+1,
			name = itemname,
			position = {x=actualx2, y=y1 + 7 + 0.5 - 1.5 + yoffset},
			direction = 0,
			control_behavior={arithmetic_conditions={first_signal={
				type="item",
				--name=resource_types[data.int_resource_type],},
				name=data.str_resource_type,},
				constant=0,
				operation="+",
				output_signal={type="item",
				--name=resource_types[data.int_resource_type]}},
				name=data.str_resource_type}},
			},
			connections={{green={{entity_id=#bpt, circuit_id=2}},
		}}}
		bpt[#bpt-3].connections[1].green[2] = {entity_id=#bpt, circuit_id=2}
	else
		-- this connects the output signal of the first combinator back to the inserters
		bpt[#bpt-2].connections[1].green[2] = {entity_id=#bpt, circuit_id=2}
	end
end

--just a function that will be constantly used. even though i entered filter, request filter and control behaviour, not all items will have those properties.
--only entities / items that actually have a wire, will have the control_behavior property set up
-- only requester chests can have the request filter, only filter inserters can have the filter property
function place_item(bpt, data, itemname, x1, y1, direction, yoffset)
	yoffset = yoffset or 0
	comparatorr = "<"
	control_constant = 3
	if station_types[data.int_station_type] == "unloading" then
		comparatorr = ">"
		control_constant = -3
	end
	prevValue = data.int_chest_limit
	if data.int_chest_limit < 0 then
		data.int_chest_limit = 9999
	end
	if data.str_resource_type ~= "none" then
		bpt[#bpt+1] = {
			entity_number = #bpt+1,
			name = itemname,
			position = {x=x1 + 0.5, y=y1 + 0.5 + yoffset},
			direction = direction,
			bar = data.int_chest_limit,
			filters = {
				{
				index = 1,
				--name = resource_types[data.int_resource_type]
				name=data.str_resource_type
				}
			},
			request_filters = {
				{
					index = 1,
					--name = resource_types[data.int_resource_type],
					name=data.str_resource_type,
					count = 200
				}
			},
			control_behavior={circuit_condition={first_signal={type="item",
			name=data.str_resource_type},
			constant=control_constant, comparator=comparatorr}}}
	else
		--fix change that was introduced to 0.15
		--i guess you cant overload items with non-used properties like "bar" which limits the inventory of a chest
		--if used with a different item, it previously didnt matter, but since 0.15 it seems to matter
		bpt[#bpt+1] = {
			entity_number = #bpt+1,
			name = itemname,
			position = {x=x1 + 0.5, y=y1 + 0.5 + yoffset},
			direction = direction,
			bar = data.int_chest_limit,
			control_behavior={circuit_condition={first_signal={type="virtual",
			name="signal-everything"},
			constant=control_constant, comparator=comparatorr}}}
	end
	data.int_chest_limit = prevValue
	return bpt
end

--for mass placing, inserters chests etc
--args: the blueprint table, data table, which item to place, at which x coordinate and then loops from starty1 to endy1
function place_row_of_items(bpt, data, itemname, x1, starty1, endy1, direction, yoffset)
	for i=starty1, endy1 do
		place_item(bpt, data, itemname, x1, i, direction, yoffset)
	end
end

--this is the actual blueprint creator function - this will use the input data to construct a blueprint with entries
function build_blueprint(data)
	--CONSTANTS
	locomotive_length = 6
	space_between_trains = 1
	cargo_length = 6
	rail_size = 2
	train_stop_size = 2

	--load the station type variable: load/unload
	station_type = station_types[data.int_station_type]

	--choose the item types used to build blueprint: inserter type, filter inserter type, chest type
	chosen_inserter = inserter_types[data.int_inserter_type]
	chosen_filter_inserter = chosen_inserter
	if data.bool_use_filter  then
		if data.int_inserter_type < 3 then
			chosen_filter_inserter = "filter-inserter"
		else
			chosen_filter_inserter = "stack-filter-inserter"
		end
	end
	chosen_chest = chest_types[data.int_chest_type]


	--up, left, right, down, or not used at all and then they will just go off to each side
	front_direction = defines.direction.north
	right_of_direction = (front_direction + 2) % 8
	back_direction = (front_direction + 4) % 8
	left_of_direction = (front_direction + 6) % 8

	--set the belt directions for unloading / loading since they have to be the opposite direction
	--aswell as in front / behind splitters, they also have to have a special direction
	--these belts are the ones directly next to the inserters!!!
	if station_types[data.int_station_type] == "unloading" then
		--these values can be understood as they apply for items on the right side of the track (when the single headed train is facing north)
		belt_direction1 = back_direction --belts for the first two inserters
		belt_direction2 = right_of_direction --belts for inserter #3
		belt_direction3 = right_of_direction --belts for inserter #4
		belt_direction4 = front_direction --belts for inserter #5 and #6
		splitter_direction = right_of_direction --splitter direction 2 tiles away from inserters
		if data.bool_use_chest then
			if data.int_chest_type == 3 then --just a smart preventing mechanic so that not accidently requester chests will be placed when unloading trains
				chosen_chest = chest_types[4]
			else
				chosen_chest = chest_types[data.int_chest_type]
			end
		end
	elseif station_types[data.int_station_type] == "loading" or station_types[data.int_station_type] == "refuel" then
		--these values can be understood as they apply for items on the right side of the track (when the single headed train is facing north)
		belt_direction1 = front_direction
		belt_direction2 = front_direction
		belt_direction3 = back_direction
		belt_direction4 = back_direction
		splitter_direction = left_of_direction
		if data.bool_use_chest then
			if data.int_chest_type < 3 then
				chosen_chest = chest_types[data.int_chest_type]
			else --just a smart preventing mechanic so that not accidently provider / storage chests will be placed when actually wanting to load the train and not unload it
				chosen_chest = chest_types[3]
			end
		end
	end

	sideUsed = "both" --default value
	leftSide = {"left", "both"} -- easier to have list to index from, like: if -1 ~= index(leftSide, sideUsed) then...
	rightSide = {"right", "both"}
	sideUsed = sides[data.int_use_side]

	--creating the new and empty blueprint table
	bpt = {}

	--collect chests so i can add green wire later on
	chests_left_side = {}
	chests_right_side = {}

	--adding rails to the blueprint
	locomotive_count = data.int_locos
	cargo_count = data.int_cargo
	temp_int_double_head = 0
	start = -4
	if data.bool_double_head then
		temp_int_double_head = 1
		start = -2
	end

	for i=start, (temp_int_double_head + 1) * locomotive_count * (locomotive_length + space_between_trains) + cargo_count * (cargo_length + space_between_trains), 2 do
		place_item(bpt, data, "straight-rail", -0.5, i, 0)
	end

	--create the train stop
	place_item(bpt, data, "train-stop", 1.5, -2.5, 0)

	--create signals
	if data.bool_signals then
		if data.bool_double_head then --if double headed train: will place two signals at the back because its expected that the train will leave where it came in
			place_item(bpt, data, "rail-signal", 1, 2 * data.int_locos * (locomotive_length + space_between_trains) + data.int_cargo * (cargo_length + space_between_trains) - 1, 4)
			place_item(bpt, data, "rail-chain-signal", -2, 2 * data.int_locos * (locomotive_length + space_between_trains) + data.int_cargo * (cargo_length + space_between_trains) - 1, 0)
		else --if single headed train you need one signal at the back and one chain signal at the front
			place_item(bpt, data, "rail-chain-signal", 1, -5 +0.5, 4)
			place_item(bpt, data, "rail-signal", 1, data.int_locos * (locomotive_length + space_between_trains) + data.int_cargo * (cargo_length + space_between_trains) - 1, 4)
		end
	end

	ycorrection = -3 --had to add this because all items were moved 3 coordinates too far south (if the train stop is at the north side of blueprint)

	--choose inserters, belts, splitters, if we are using chests
	chosen_belt = belt_types[data.int_belt_type]
	splitter_types = {"splitter", "fast-splitter","express-splitter"}
	chosen_splitter = splitter_types[data.int_belt_type]
	limit_chests = data.int_chest_limit
	usingChest = 0
	if data.bool_use_chest then
		usingChest = 2 --the offset variable, cause if we dont use chest as buffer then we want inserters to be 2 steps closer to the train
	end
	usedCoordinates = {}

	--place inserters, chests, and initial belts + splitters
	start = locomotive_count * (locomotive_length + space_between_trains)
	stop = start + cargo_count * (cargo_length + space_between_trains) - 1
	for i = start, stop do
		if i % (cargo_length + space_between_trains) == 0 then
			if station_types[data.int_station_type] == "loading" or station_types[data.int_station_type] == "unloading" then
				tempDirection = 6
				if station_types[data.int_station_type] == "loading" then
					tempDirection = 2
				end
				-- place the first row of inserters
					if -1 ~= index(rightSide, sideUsed) then --place if "both" or "right" side is selected
						place_row_of_items(bpt, data, chosen_filter_inserter, 1, i+1, i+6, tempDirection, ycorrection) end
					if -1 ~= index(leftSide, sideUsed) then --place if "both" or "left" side is selected
						place_row_of_items(bpt, data, chosen_filter_inserter, -2, i+1, i+6, (tempDirection + 4) % 8, ycorrection) end
				-- place chests if wanted
				if data.bool_use_chest then
					if -1 ~= index(rightSide, sideUsed) then --place if "both" or "right" side is selected
						place_row_of_items(bpt, data, chosen_chest, 2, i+1, i+6, 2, ycorrection)
						if data.int_chest_type < 3 then
							-- if chests arent logistic chests, then use the next row of inserters
							place_row_of_items(bpt, data, chosen_inserter, 3, i+1, i+6, tempDirection, ycorrection)
							if data.bool_evenly_load then
								add_madzuri_wire_setup(bpt, data, "arithmetic-combinator", 4, i, 2, ycorrection)
							end
						end
					end
					if -1 ~= index(leftSide, sideUsed) then --place if "both" or "left" side is selected
						place_row_of_items(bpt, data, chosen_chest, -3, i+1, i+6, 6, ycorrection)
						if data.int_chest_type < 3 then
							place_row_of_items(bpt, data, chosen_inserter, -4, i+1, i+6, (tempDirection + 4) % 8, ycorrection)
							if data.bool_evenly_load then
								add_madzuri_wire_setup(bpt, data, "arithmetic-combinator", -4, i, 2, ycorrection)
							end
						end
					end
				end
			end --place poles on every 7th spot, aswell as lamps (if wanted)
		end

		-- place initial belts and splitters
		if data.int_chest_type < 3 then
			if i % (cargo_length + space_between_trains) > 4 then
				if -1 ~= index(rightSide, sideUsed) then --place if "both" or "right" side is selected
					place_item(bpt, data, chosen_belt, 2 + usingChest, i + ycorrection, belt_direction4) end
				if -1 ~= index(leftSide, sideUsed) then --place if "both" or "left" side is selected
					place_item(bpt, data, chosen_belt, -3 - usingChest, i + ycorrection, belt_direction4) end
			elseif i % (cargo_length + space_between_trains) < 3 and i % (cargo_length + space_between_trains) ~= 0 then
				if -1 ~= index(rightSide, sideUsed) then --place if "both" or "right" side is selected
					place_item(bpt, data, chosen_belt, 2 + usingChest, i + ycorrection, belt_direction1) end
				if -1 ~= index(leftSide, sideUsed) then --place if "both" or "left" side is selected
					place_item(bpt, data, chosen_belt, -3 - usingChest, i + ycorrection, belt_direction1) end
			elseif i % (cargo_length + space_between_trains) == 3 then
				if -1 ~= index(rightSide, sideUsed) then --place if "both" or "right" side is selected
					place_item(bpt, data, chosen_belt, 2 + usingChest, i + ycorrection, belt_direction2) end
				if -1 ~= index(leftSide, sideUsed) then --place if "both" or "left" side is selected
					place_item(bpt, data, chosen_belt, -3 - usingChest, i + ycorrection, (belt_direction2 * 3) % 8) end
			elseif i % (cargo_length + space_between_trains) == 4 then
				if -1 ~= index(rightSide, sideUsed) then --place if "both" or "right" side is selected
					place_item(bpt, data, chosen_belt, 2 + usingChest, i + ycorrection, belt_direction3)
					place_item(bpt, data, chosen_splitter, 3 + usingChest, i + ycorrection - 0.5, splitter_direction) end
				if -1 ~= index(leftSide, sideUsed) then --place if "both" or "left" side is selected
					place_item(bpt, data, chosen_belt, -3 - usingChest, i + ycorrection, (belt_direction3 * 3) % 8)
					place_item(bpt, data, chosen_splitter, -4 - usingChest, i + ycorrection - 0.5, (splitter_direction + 4) % 8) end
			end
		end
	end

	--add green wire to all the chests if checkbox has ticked
	if data.bool_connect_chests and data.bool_use_chest then
		chests_left_side = {}
		chests_right_side = {}
		for i = 1, #bpt do
			if bpt[i].name == chosen_chest then
				if bpt[i].position.x < 0 then
					chests_left_side[#chests_left_side+1] = bpt[i].entity_number
				else
					chests_right_side[#chests_right_side+1] = bpt[i].entity_number
				end
			end
		end
		if -1 ~= index(leftSide, sideUsed) then --place if "both" or "left" side is selected
			for i = 2, #chests_left_side do
				bpt[chests_left_side[i]].connections={{green={{entity_id=chests_left_side[i-1]}}}}
			end
		end
		if -1 ~= index(rightSide, sideUsed) then --place if "both" or "right" side is selected
			for i = 2, #chests_right_side do
				bpt[chests_right_side[i]].connections={{green={{entity_id=chests_right_side[i-1]}}}}
			end
		end
	end

	--IF REFILL CHECKBOX: place inserters and requester chests to refuel the train
	start = 1
	if not data.bool_refuel then
		start = locomotive_count * (locomotive_length + space_between_trains)
	end
	stop = (1 + temp_int_double_head) * locomotive_count * (locomotive_length + space_between_trains) + cargo_count * (cargo_length + space_between_trains)
	temp_check1 = locomotive_count * (locomotive_length + space_between_trains)
	temp_check2 = locomotive_count * (locomotive_length + space_between_trains) + cargo_count * (cargo_length + space_between_trains)
	for i = start, stop do --loop over the whole length of the train
		if i % 7 == 0 then
			if data.bool_double_head and not data.bool_refuel and i > temp_check2 then
				break --stop when we are using double headed trains and no refuel, or else this would loop too far
			end
			if -1 ~= index(rightSide, sideUsed) then --place if "both" or "right" side is selected
				place_item(bpt, data, "medium-electric-pole", 2, i, 4, ycorrection) end
			if -1 ~= index(leftSide, sideUsed) then --place if "both" or "left" side is selected
				place_item(bpt, data, "medium-electric-pole", -3, i, 4, ycorrection) end
			if data.bool_lamps then
				if -1 ~= index(rightSide, sideUsed) then --place if "both" or "right" side is selected
					place_item(bpt, data, "small-lamp", 1, i, 4, ycorrection) end
				if -1 ~= index(leftSide, sideUsed) then --place if "both" or "left" side is selected
					place_item(bpt, data, "small-lamp", -2, i, 4, ycorrection) end
			end
		end
		-- place refuel chest
		if i % 7 == 4 and (i < temp_check1 or (data.bool_refuel and i > temp_check2)) then
			if data.bool_refuel and index(sides, sideUsed) ~= 3 then
				place_item(bpt, data, chosen_inserter, 1, i , 2, ycorrection)
				bpt[#bpt+1] = {
					entity_number = #bpt+1,
					name = "logistic-chest-requester",
					position = {x=2 + 0.5, y=i + 0.5 + ycorrection},
					request_filters = {
						{
							index = 1,
							--added in v0.0.8
							name = fuel_types[data.int_refuel_type],
							--name = "solid-fuel",
							count = data.int_refuel_request_amount
						}
					}}
			else -- place refuel chest on left side
				place_item(bpt, data, chosen_inserter, -2, i , 6, ycorrection)
				bpt[#bpt+1] = {
					entity_number = #bpt+1,
					name = "logistic-chest-requester",
					position = {x=-3 + 0.5, y=i + 0.5 + ycorrection},
					request_filters = {
						{
							index = 1,
							--added in v0.0.8
							name = fuel_types[data.int_refuel_type],
							--name = "solid-fuel",
							count = data.int_refuel_request_amount
						}
					}}
			end
		end
	end

	--create belts for the belt-flow button (so belts meet at a certain direction)
	startVertical = 1 + data.int_locos * 6
	stopVertical = -6 + data.int_locos * 6
	offsetHorizontal = -1
	offsetVertical = 3
	startHorizontal = 0
	stopHorizontal = -1
	belt_direction1 = 2
	belt_direction2 = 0
	if station_types[data.int_station_type] == "loading" then
		startVertical = 1 + data.int_locos * 6
		stopVertical = -7 + data.int_locos * 6
		startHorizontal = 0
		stopHorizontal = 0
		belt_direction1 = 6
		belt_direction2 = 4
		end
	if flow_directions[data.int_direction] == "back" then
		startVertical = 7
		stopVertical = 0
		offsetVertical = 11
		belt_direction2 = 4
		if station_types[data.int_station_type] == "loading" then
			startVertical = 8
			stopVertical = 0
			offsetVertical = 11
			belt_direction2 = (belt_direction2 + 4) % 8
		end
	end
	if data.int_chest_type < 3 then
		if flow_directions[data.int_direction] == "front" then
			for i1 = 0, data.int_cargo do
				for i2 = startHorizontal, i1 + stopHorizontal - 1 do
					if -1 ~= index(rightSide, sideUsed) then --place if "both" or "right" side is selected
						place_item(bpt, data, chosen_belt, 4 + usingChest + i2, offsetVertical + 7*(i1  + data.int_locos - 1), belt_direction1, ycorrection) end
					if -1 ~= index(leftSide, sideUsed) then --place if "both" or "left" side is selected
						place_item(bpt, data, chosen_belt, -5 - usingChest - i2, offsetVertical + 7*(i1  + data.int_locos - 1), (belt_direction1 + 4) % 8, ycorrection) end
				end
				for i2 = startVertical, stopVertical + 7*i1 do
					if -1 ~= index(rightSide, sideUsed) then --place if "both" or "right" side is selected
						place_item(bpt, data, chosen_belt, 4 + usingChest + i1 - 1, offsetVertical + i2 + ycorrection + data.int_locos - 1, belt_direction2) end
					if -1 ~= index(leftSide, sideUsed) then --place if "both" or "left" side is selected
						place_item(bpt, data, chosen_belt, -5 - usingChest - i1 + 1, offsetVertical + i2 + ycorrection + data.int_locos - 1, belt_direction2) end
				end
			end
		elseif flow_directions[data.int_direction] == "back" then
			for i1 = 0, data.int_cargo do
				for i2 = i1 + stopHorizontal - 1, startHorizontal, -1 do
					if -1 ~= index(rightSide, sideUsed) then --place if "both" or "right" side is selected
						place_item(bpt, data, chosen_belt, 4 + usingChest + i2, offsetVertical + 7*(data.int_cargo - i1 + data.int_locos - 1) , belt_direction1, ycorrection) end
					if -1 ~= index(leftSide, sideUsed) then --place if "both" or "left" side is selected
						place_item(bpt, data, chosen_belt, -5 - usingChest - i2, offsetVertical + 7*(data.int_cargo - i1 + data.int_locos - 1) , (belt_direction1 + 4) % 8, ycorrection) end
				end
				for i2 = stopVertical + 7*i1, startVertical, -1 do
					if -1 ~= index(rightSide, sideUsed) then --place if "both" or "right" side is selected
						place_item(bpt, data, chosen_belt, 4 + usingChest + i1 - 1, 7*(data.int_cargo - i1 - 2 + data.int_locos) + offsetVertical + i2 + ycorrection, belt_direction2) end
					if -1 ~= index(leftSide, sideUsed) then --place if "both" or "left" side is selected
						place_item(bpt, data, chosen_belt, -5 - usingChest - i1 + 1, 7*(data.int_cargo - i1 - 2 + data.int_locos) + offsetVertical + i2 + ycorrection, belt_direction2) end
				end
			end
		end
	end

	--for _, player in pairs(game.players) do
		--player.print(bpt[43].bar)
	--end
	return bpt
end

--http://lua-api.factorio.com/latest/Data-Lifecycle.html
--When creating a new game, script.on_init() will be called on each mod that has a control.lua file.
--When loading a save game and the mod existed in that save game script.on_load() is called.
--When loading a save game and the mod did not exist in that save game script.on_init() is called.

-- Create a button on gui.top for the created player.
-- this function is required for multiplayer
local function on_player_created(event)
	local player = game.players[event.player_index]
	--player.print("player created "..tostring(event)..tostring(player))
	--local frame = game.players[event.player_index].gui.top[btn_menu]
	set_global_variables(player, {})
	--player.print("onPlayerCreated: button created for "..tostring(player.name))

	--TODO uncomment the following:
	if (player.force.technologies["construction-robotics"].researched) then
		--if true then
		if not player.gui.top[btn_menu] then
			player.gui.top.add{type = "button", name=btn_menu, caption = "B", tooltip = "Burny's Train Station Blueprint Creator"}
		end
	end
end

--this will be executed when the mod is loaded into the game for the first time (if it wasnt installed on a previous savegame)
--if a new game is created while the mod is running, this script is not executed -> in this case, use the function "on_player_created"
--for when "loading a game" use the script "on_load"

script.on_init(function()
	for _, player in pairs(game.players) do
		set_global_variables(player, {})
		--player.print("onInit: button created for "..tostring(player.name))
		--if (player.force.technologies["automated-construction"].researched) then
		if (player.force.technologies["construction-robotics"].researched)  then
			if not player.gui.top[btn_menu] then
				player.gui.top.add{type = "button", name=btn_menu, caption = "B", tooltip = "Burny's Train Station Blueprint Creator"}
			end
		end
	end
end)

script.on_event(defines.events.on_research_finished, function(event)
	for _, player in pairs(game.players) do
		--set_global_variables(player, {})
		--player.print("onResearchFinished: button created "..tostring(player.name))
		if (player.force.technologies["construction-robotics"].researched) then
			if not player.gui.top[btn_menu] then
				player.gui.top.add{type = "button", name=btn_menu, caption = "B", tooltip = "Burny's Train Station Blueprint Creator"}
			end
		end
		if player.gui.top[btn_menu] then --fix menu gui button for players who had mod previously installed
			player.gui.top[btn_menu].destroy() --^ new since v0.0.8
			player.gui.top.add{type = "button", name=btn_menu, caption = "B", tooltip = "Burny's Train Station Blueprint Creator"}
		end
	end
end)

-- get the itemname of the item in mouse cursor and clears mouse cursor
function get_itemname_of_cursor(player) --new function since v0.0.5
	if player.cursor_stack.valid_for_read and player.cursor_stack or false then
		returnName = player.cursor_stack.name
	else
		return "none"
	end
	--player.cursor_stack.clear()
	return returnName
end

--check for empty blueprint in mouse cursor
function holding_empty_blueprint(player)
	return (player.cursor_stack.valid_for_read and player.cursor_stack.type == "blueprint" and not player.cursor_stack.is_blueprint_setup() )
end

--not used function
--[[function holding_blueprint(player)
	return (player.cursor_stack.valid_for_read and player.cursor_stack.type == "blueprint")
end--]]

--when a button of the GUI has been pressed obviously D: damn unnecessary comments!
local function on_gui_click(event)
	local player = game.players[event.player_index]
	local frame = game.players[event.player_index].gui.left[frame_menu]
	if event.element.name ~= btn_menu and frame then
		data = readGUIdata(player, frame)
		if data == "versionMismatch" then
			player.print("BurnysTSBC: New version detected, resetting mod data")
			frame.destroy()
			return nil
		end
		global["BurnysTSBC"] = global["BurnysTSBC"] or {}
		global["BurnysTSBC"][player] = data

		if event.element.name == btn_station_type then
			frame.flow_station_type.btn_station_type.caption = station_types[data["int_station_type"] % #station_types +1]
			set_global_variables(player, data)
		elseif event.element.name == btn_inserter_type then
			data.int_inserter_type = data.int_inserter_type % #inserter_types + 1
			set_global_variables(player, data)
			frame.destroy()
			create_menu(player)
			--welp since i cannot change the sprite of a gui element, and and because i cannot accoess it through the flow, i have to set it to a variable to be able to delete it later on, then recreate it from scratch :(
			--and because i dont think i cant save the sprite over savegames, i have to just rebuild the whole mod-gui frame
			--spr_inserter_type.destroy()
			--spr_inserter_type = frame.flow_inserter_type.add{type="sprite", --sprite="item/"..frame.flow_inserter_type.btn_inserter_type.caption}
		elseif event.element.name == btn_resource_type then
			--data.int_resource_type = data.int_resource_type % #resource_types + 1 --obsolete since v0.0.2
			data.str_resource_type = get_itemname_of_cursor(player)
			if data.str_resource_type == "none" then
				data.str_error_message = "Hold an item while clicking the filter button!"
			end
			set_global_variables(player, data)
			frame.destroy()
			create_menu(player)
		elseif event.element.name == btn_chest_type then
			data.int_chest_type = data.int_chest_type % #chest_types + 1
			set_global_variables(player, data)
			frame.destroy()
			create_menu(player)
		elseif event.element.name == btn_belt_type then
			data.int_belt_type = data.int_belt_type % #belt_types + 1
			set_global_variables(player, data)
			frame.destroy()
			create_menu(player)
		elseif event.element.name == btn_fuel_type then
			data.int_refuel_type = data.int_refuel_type % #fuel_types + 1
			set_global_variables(player, data)
			frame.destroy()
			create_menu(player)
		elseif event.element.name == btn_sides then
			data.int_use_side = data.int_use_side % #sides + 1
			set_global_variables(player, data)
			frame.destroy()
			create_menu(player)
		elseif event.element.name == btn_direction_belt then
			frame.flow_direction.btn_direction_belt.caption = flow_directions[data["int_direction"] % #flow_directions +1]
			set_global_variables(player, data)
		elseif event.element.name == btn_create_blueprint then
			--correct the textboxes so they catch invalid entries
			data.str_error_message = "Success!"
			if tonumber(data.int_locos) == nil then
				data.str_error_message = "Invalid number of locomotives. Resetting value."
			end
			if tonumber(data.int_cargo) == nil then
				data.str_error_message = "Invalid number of cargo wagons. Resetting value."
			end
			if data.str_error_message == "Success!" then
				if tonumber(data.int_locos) + tonumber(data.int_cargo) < -500 or tonumber(data.int_locos) + tonumber(data.int_cargo) > 1000  then
					data.str_error_message = "Oh god, please use less locomotives or cargo wagons!"
				end
			end
			if tonumber(data.int_chest_limit) == nil then
				data.str_error_message = "Invalid number of \"Chest limit\". Resetting value. Enter a number between -1 and 48!"
			end
			if tonumber(data.int_refuel_request_amount) == nil then
				data.str_error_message = "Invalid number for fuel-request amount. Resetting value."
			end
			if data.bool_connect_chests and data.bool_evenly_load then
				data.str_error_message = "Can't use \"load evenly\" and \"connect all chests\" together."
			end
			if not holding_empty_blueprint(player) then
				data.str_error_message = "No empty blueprint in mouse cursor!"
			end
			if data.str_error_message == "Success!" then
				blueprint = build_blueprint(data)
				player.cursor_stack.set_blueprint_entities(blueprint)
			end
			set_global_variables(player, data)
			frame.destroy()
			create_menu(player)
		end

	elseif event.element.name == btn_menu then
		local player = game.players[event.player_index]
		local frame = player.gui.left[frame_menu]
		if (frame) then
			data = readGUIdata(player, frame)
			if data == "versionMismatch" then
				player.print("BurnysTSBC: New version detected, resetting mod data")
				frame.destroy()
				return nil
			end
			set_global_variables(player, data)
			frame.destroy()
		else
			create_menu(player)
		end
	end
end

script.on_event(defines.events.on_player_created, on_player_created)
script.on_event(defines.events.on_gui_click, on_gui_click)
