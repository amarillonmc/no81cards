--星海航线 深渊狱神
function c11560719.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c11560719.mfilter,c11560719.xyzcheck,3,99) 
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN) end)
	c:RegisterEffect(e1) 
	--atk 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e) 
	return e:GetHandler():GetBaseAttack()*2 end)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN) end)
	c:RegisterEffect(e1)
	--atk 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(function(e) 
	local tp=e:GetHandlerPlayer()
	return math.abs(8000-Duel.GetLP(1-tp)) end)
	e2:SetCondition(function(e) 
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_XYZ) end)
	c:RegisterEffect(e2) 
	--immuse
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(function(e,te)  
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer() and not te:IsActivated() end)
	e2:SetCondition(function(e) 
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_XYZ) end)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(1)
	e3:SetCondition(function(e)
	local tp=e:GetHandlerPlayer() 
	return (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()) and Duel.GetLP(tp)<Duel.GetLP(1-tp) end)
	c:RegisterEffect(e3)
end 
c11560719.SetCard_SR_Saier=true 
function c11560719.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,2) or c:IsRank(2) or c:IsLink(2)
end
function c11560719.xyzcheck(g)
	return true 
end


