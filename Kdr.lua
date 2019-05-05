local w, h = client.screen_size()
local visibility = ui.set_visible

local enable = ui.new_checkbox("MISC", "Settings", "Ego booster")
local skinColor = ui.new_combobox("MISC", "Settings", "Skin color", "White", "Black")
local local_x = ui.new_slider("MISC", "Settings", "Position (X)", 0, w)
local local_y = ui.new_slider("MISC", "Settings", "Position (Y)", 0, h)

local x_local = 1
local y_local = 450

local function round(b,c)local d=10^(c or 0)return math.floor(b*d+0.5)/d end

local kills = 0
local deaths = 0
local kd = 0
local kd_2 = 0

do --if you save your config with this it should safe c:
 ui.set(local_x, x_local)
 ui.set(local_y, y_local)
end

local function on_player_death(e)
	
	local victim_userid, attacker_userid = e.userid, e.attacker
	if victim_userid == nil or attacker_userid == nil then
		return
	end

	local victim_entindex   = client.userid_to_entindex(victim_userid)
	local attacker_entindex = client.userid_to_entindex(attacker_userid)

	if attacker_entindex == entity.get_local_player() and entity.is_enemy(victim_entindex) then
			kills = kills + 1
		elseif victim_entindex == entity.get_local_player() then
			deaths = deaths + 1
	end
end

local function on_paint(ctx)
    x_local = ui.get(local_x)
    y_local = ui.get(local_y)
	
	if not (deaths==0) then
		kd = kills / deaths
		kd_2 = round(kd, 2)
	elseif not(kills==0) then
		kd_2 = kills
	end
	
	if ui.get(skinColor) == "White" then
		r, g, b, a = 255, 205, 148, 255
	elseif ui.get(skinColor) == "Black" then
		r, g, b, a = 62,43,19, 255
	end

	if ui.get(enable) then
		visibility(skinColor, true)
		visibility(local_x, true)
		visibility(local_y, true)

		renderer.circle(x_local - 53, y_local, r, g, b, a, 69, 0, 1)
		renderer.circle(x_local + 53, y_local, r, g, b, a, 69, 0, 1)
		renderer.rectangle(x_local - 50, y_local - kd * 100, 100, kd * 100, r, g, b, a)
		renderer.circle(x_local, y_local - kd * 100, r, g, b, a, 81, 180, 0.53)
		renderer.rectangle(x_local - 3, y_local - kd * 100 - 81, 6, 35, 0, 0, 0, a)
	else
		visibility(skinColor, false)
		visibility(local_x, false)
		visibility(local_y, false)
	end

	if globals.mapname == nil then
		kills = 0
		deaths = 0
		kd = 0
		kd_2 = 0
	end
end

client.set_event_callback('paint', on_paint)
client.set_event_callback('player_death', on_player_death)
