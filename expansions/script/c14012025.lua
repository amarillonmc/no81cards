--幻叙非存在-墨泷云
local s,id,o=GetID()
if Mo_Long_Yun==nil then
Mo_Long_Yun=true
s.raw_IsExistingMatchingCard = Duel.IsExistingMatchingCard
s.raw_IsExistingTarget	   = Duel.IsExistingTarget
s.raw_GroupIsExists		  = Group.IsExists
s.raw_GetMatchingGroupCount  = Duel.GetMatchingGroupCount
s.raw_GetFieldGroupCount	 = Duel.GetFieldGroupCount
s.raw_GetLocationCount	   = Duel.GetLocationCount
s.raw_GetLocationCountEx	 = Duel.GetLocationCountEx
s.raw_GetMZoneCount		  = Duel.GetMZoneCount
s.raw_GetActivityCount	   = Duel.GetActivityCount
s.raw_GetCustomActivityCount = Duel.GetCustomActivityCount
s.raw_CardGetOverlayCount	= Card.GetOverlayCount
s.raw_CardGetEquipCount	  = Card.GetEquipCount
s.raw_GroupGetCount		  = Group.GetCount
s.raw_CardRegisterEffect	 = Card.RegisterEffect
s.raw_DuelRegisterEffect	 = Duel.RegisterEffect
s.raw_GetMatchingGroup	   = Duel.GetMatchingGroup
s.raw_GetFieldGroup		  = Duel.GetFieldGroup
s.raw_GetReleaseGroup		= Duel.GetReleaseGroup
s.raw_GetTributeGroup		= Duel.GetTributeGroup
s.raw_GetDecktopGroup		= Duel.GetDecktopGroup
s.raw_GetExtraTopGroup	   = Duel.GetExtraTopGroup
s.raw_SelectMatchingCard	 = Duel.SelectMatchingCard
s.raw_SelectTarget		   = Duel.SelectTarget
s.raw_SelectTribute		  = Duel.SelectTribute
s.raw_SelectReleaseGroup	 = Duel.SelectReleaseGroup
s.raw_SelectReleaseGroupEx   = Duel.SelectReleaseGroupEx
s.raw_SelectFusionMaterial   = Duel.SelectFusionMaterial
s.raw_SelectSynchroMaterial  = Duel.SelectSynchroMaterial
s.raw_SelectXyzMaterial	  = Duel.SelectXyzMaterial
s.raw_SelectLinkMaterial	 = Duel.SelectLinkMaterial
s.raw_GroupFilter			= Group.Filter
s.raw_GroupFilterSelect	  = Group.FilterSelect
s.raw_GroupSelect			= Group.Select
s.raw_CardGetEquipGroup	  = Card.GetEquipGroup
s.raw_CardGetOverlayGroup	= Card.GetOverlayGroup
s.raw_CardGetMaterial		= Card.GetMaterial
Duel.IsExistingMatchingCard = function(...)
	return not s.raw_IsExistingMatchingCard(...)
end
Duel.IsExistingTarget = function(...)
	return not s.raw_IsExistingTarget(...)
end
Group.IsExists = function(g, ...)
	return not s.raw_GroupIsExists(g, ...)
end
Duel.GetMatchingGroupCount = function(...)
	return -s.raw_GetMatchingGroupCount(...)
end
Duel.GetFieldGroupCount = function(...)
	return -s.raw_GetFieldGroupCount(...)
end
Duel.GetLocationCount = function(...)
	return -s.raw_GetLocationCount(...)
end
Duel.GetLocationCountEx = function(...)
	return -s.raw_GetLocationCountEx(...)
end
Duel.GetMZoneCount = function(...)
	return -s.raw_GetMZoneCount(...)
end
Duel.GetActivityCount = function(...)
	return -s.raw_GetActivityCount(...)
end
Duel.GetCustomActivityCount = function(...)
	return -s.raw_GetCustomActivityCount(...)
end
Card.GetOverlayCount = function(...)
	return -s.raw_CardGetOverlayCount(...)
end
Card.GetEquipCount = function(...)
	return -s.raw_CardGetEquipCount(...)
end
Group.GetCount = function(g, ...)
	return -s.raw_GroupGetCount(g, ...)
end
pcall(function()
	local mt = getmetatable(Group.CreateGroup())
	if mt then
		mt.__len = function(g)
			return -s.raw_GroupGetCount(g)
		end
	end
end)
Duel.GetMatchingGroup = function(...) return nil end
Duel.GetFieldGroup	= function(...) return nil end
Duel.GetReleaseGroup  = function(...) return nil end
Duel.GetTributeGroup  = function(...) return nil end
Duel.GetDecktopGroup  = function(...) return nil end
Duel.GetExtraTopGroup = function(...) return nil end
Duel.GetFirstMatchingCard = function(...) return nil end
Duel.SelectMatchingCard   = function(...) return nil end
Duel.SelectTarget		 = function(...) return nil end
Duel.SelectTribute		= function(...) return nil end
Duel.SelectReleaseGroup   = function(...) return nil end
Duel.SelectReleaseGroupEx = function(...) return nil end
Duel.SelectFusionMaterial = function(...) return nil end
Duel.SelectSynchroMaterial= function(...) return nil end
Duel.SelectXyzMaterial	= function(...) return nil end
Duel.SelectLinkMaterial   = function(...) return nil end
Group.Filter	   = function(...) return nil end
Group.FilterSelect = function(...) return nil end
Group.Select	   = function(...) return nil end
Card.GetEquipGroup   = function(...) return nil end
Card.GetOverlayGroup = function(...) return nil end
Card.GetMaterial	 = function(...) return nil end
Card.RegisterEffect = function(tc, te, bool)
	local clone = te:Clone()
	
	local prop = te:GetProperty() or 0
	clone:SetProperty(bit.bor(prop, EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_UNCOPYABLE))
	
	clone:SetType(EFFECT_TYPE_SINGLE)
	clone:SetCode(EFFECT_SPSUMMON_CONDITION)
	
	local val = te:GetValue()
	if type(val) == "number" and val > 0 then
		clone:SetValue(-val)
	elseif type(val) == "function" then
		clone:SetValue(function(...)
			local r = val(...)
			if type(r) == "number" and r > 0 then
				return -r
			else
				return r
			end
		end)
	end
	
	return s.raw_CardRegisterEffect(tc, clone, bool)
end
Duel.RegisterEffect = function(te, tp)
	local clone = te:Clone()
	local prop = te:GetProperty() or 0
	clone:SetProperty(bit.bor(prop, EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_UNCOPYABLE))
	clone:SetType(EFFECT_TYPE_SINGLE)
	clone:SetCode(EFFECT_SPSUMMON_CONDITION)
	local val = te:GetValue()
	if type(val) == "number" and val > 0 then
		clone:SetValue(-val)
	elseif type(val) == "function" then
		clone:SetValue(function(...)
			local r = val(...)
			if type(r) == "number" and r > 0 then
				return -r
			else
				return r
			end
		end)
	end
	return s.raw_DuelRegisterEffect(clone, tp)
end
function s.initial_effect(c)
	--"已经打烊惹"
end
end