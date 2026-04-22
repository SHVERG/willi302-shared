local capability_registry = Willi302_CapabilityRegistry or {}
local entity_capability_overrides = Willi302_EntityCapabilityOverrides or setmetatable({}, { __mode = "k" })

Willi302_CapabilityRegistry = capability_registry
Willi302_EntityCapabilityOverrides = entity_capability_overrides

local function normalize_model(model)
	if not isstring(model) then return nil end
	return string.lower(model)
end

function RegisterCapability(model, feature, config)
	local normalized_model = normalize_model(model)
	if not normalized_model or not isstring(feature) then return end

	capability_registry[normalized_model] = capability_registry[normalized_model] or {}
	capability_registry[normalized_model][feature] = config
end

local function get_model_capabilities(model)
	local normalized_model = normalize_model(model)
	if not normalized_model then return nil end
	return capability_registry[normalized_model]
end

function SetEntityCapability(ent, feature, config)
	if not IsValid(ent) or not isstring(feature) then return end
	entity_capability_overrides[ent] = entity_capability_overrides[ent] or {}
	entity_capability_overrides[ent][feature] = config
end

local function get_capability_from_entity(ent, feature)
	if not IsValid(ent) then return nil end

	local override = entity_capability_overrides[ent]
	if override and override[feature] ~= nil then
		return override[feature]
	end

	local model_caps = get_model_capabilities(ent:GetModel())
	if not model_caps then return nil end

	return model_caps[feature]
end

function GetCapability(model_or_entity, feature)
	if not isstring(feature) then return nil end

	if IsEntity(model_or_entity) then
		return get_capability_from_entity(model_or_entity, feature)
	end

	local model_caps = get_model_capabilities(model_or_entity)
	if not model_caps then return nil end
	return model_caps[feature]
end

function HasCapability(model_or_entity, feature)
	return GetCapability(model_or_entity, feature) ~= nil
end

function MigrateLegacyCapabilities()
	if istable(vehs_routes) then
		for _, route_data in pairs(vehs_routes) do
			if route_data and route_data.model then
				RegisterCapability(route_data.model, "routes", route_data)
			end
		end
	end

	if istable(vehs_steering) then
		for _, steering_data in pairs(vehs_steering) do
			if steering_data and steering_data.model then
				RegisterCapability(steering_data.model, "ass", {
					Degree = steering_data.degree,
					Bone = steering_data.bone,
					Angle_P = steering_data.angle_p,
					Angle_Y = steering_data.angle_y,
					Angle_R = steering_data.angle_r,
				})
			end
		end
	end
end
