local ConfigLoader = {}

local ALIGN_MAP = {
	left = TEXT_ALIGN_LEFT,
	right = TEXT_ALIGN_RIGHT,
	center = TEXT_ALIGN_CENTER,
}

local function to_vector(raw)
	if not istable(raw) or raw.x == nil or raw.y == nil or raw.z == nil then return nil end
	return Vector(raw.x, raw.y, raw.z)
end

local function to_angle(raw)
	if not istable(raw) or raw.p == nil or raw.y == nil or raw.r == nil then return nil end
	return Angle(raw.p, raw.y, raw.r)
end

local function to_color(raw)
	if not istable(raw) or raw.r == nil or raw.g == nil or raw.b == nil then return nil end
	return Color(raw.r, raw.g, raw.b, raw.a or 255)
end

local function read_json_collection(glob)
	local result = {}
	local files = file.Find(glob, "GAME")

	for _, filename in ipairs(files) do
		local path = string.GetPathFromFilename(glob) .. filename
		local payload = file.Read(path, "GAME")
		if payload then
			local decoded = util.JSONToTable(payload)
			if istable(decoded) then
				for id, item in pairs(decoded) do
					result[id] = item
				end
			end
		end
	end

	if table.Count(result) == 0 then return nil end
	return result
end

local function has_valid_transform(entry)
	if not istable(entry) then return false end
	if not to_vector(entry.pos) then return false end
	if not to_angle(entry.ang) then return false end
	return true
end

local function convert_route_draw_entries(list)
	if not istable(list) then return nil, "coordinates" end

	local converted = {}
	for idx, entry in ipairs(list) do
		if not has_valid_transform(entry) then return nil, "coordinates" end
		if entry.align == nil then return nil, "coordinates" end

		converted[idx] = {
			pos = to_vector(entry.pos),
			ang = to_angle(entry.ang),
			size = entry.size,
			align = ALIGN_MAP[entry.align] or entry.align,
		}
	end

	return converted
end

local function convert_routes_config(raw)
	if not istable(raw) then return nil end

	local converted = {}
	for id, cfg in pairs(raw) do
		if not isstring(cfg.model) then return nil, id, "model" end
		if not isstring(cfg.routes_font) or not isstring(cfg.nums_font) then return nil, id, "fonts" end

		local nums, nums_err = convert_route_draw_entries(cfg.nums)
		if not nums then return nil, id, nums_err end
		local letters, letters_err = convert_route_draw_entries(cfg.letters)
		if not letters then return nil, id, letters_err end
		if not istable(cfg.routes) then return nil, id, "coordinates" end

		local routes_first, first_err = convert_route_draw_entries(cfg.routes.first)
		if not routes_first then return nil, id, first_err end
		local routes_last, last_err = convert_route_draw_entries(cfg.routes.last)
		if not routes_last then return nil, id, last_err end

		converted[id] = {
			model = cfg.model,
			color = to_color(cfg.color) or Color(255, 150, 0),
			routes_font = cfg.routes_font,
			nums_font = cfg.nums_font,
			nums = nums,
			letters = letters,
			routes = {
				first = routes_first,
				last = routes_last,
			},
		}
	end

	return converted
end

local function convert_steering_config(raw)
	if not istable(raw) then return nil end

	local converted = {}
	for id, cfg in pairs(raw) do
		if not isstring(cfg.model) then return nil, id, "model" end
		if not isstring(cfg.bone) then return nil, id, "bone" end
		if cfg.angle_p == nil or cfg.angle_y == nil or cfg.angle_r == nil then return nil, id, "angle_*" end

		converted[id] = {
			model = cfg.model,
			degree = cfg.degree,
			bone = cfg.bone,
			angle_p = cfg.angle_p,
			angle_y = cfg.angle_y,
			angle_r = cfg.angle_r,
		}
	end

	return converted
end

local function load_embedded_routes()
	include("willi302/vehs_routes.lua")
	return vehs_routes
end

local function load_embedded_steering()
	include("willi302/vehs_steering.lua")
	return vehs_steering
end

function ConfigLoader.Load()
	local routes_raw = read_json_collection("data/willi302/routes/*.json")
	local routes, routes_id, routes_error = convert_routes_config(routes_raw)

	if routes then
		vehs_routes = routes
	else
		if routes_id then
			ErrorNoHalt(string.format("[willi302] routes config error for '%s': missing %s\n", routes_id, routes_error))
		end
		vehs_routes = load_embedded_routes()
	end

	local steering_raw = read_json_collection("data/willi302/steering/*.json")
	local steering, steering_id, steering_error = convert_steering_config(steering_raw)

	if steering then
		vehs_steering = steering
	else
		if steering_id then
			ErrorNoHalt(string.format("[willi302] steering config error for '%s': missing %s\n", steering_id, steering_error))
		end
		vehs_steering = load_embedded_steering()
	end
end

willi302_config_loader = ConfigLoader

return ConfigLoader
