--机娘·「赤红」
local m=37901003
local cm=_G["c"..m]
function cm.initial_effect(c)
--e1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(function(e,c)
		if c==nil then return true end
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(cm.cf11,c:GetControler(),LOCATION_MZONE,0,1,nil)
	end)
	c:RegisterEffect(e1)
--e2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(function(e)
		local ph=Duel.GetCurrentPhase()
		return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
	end)
	e2:SetValue(function(e,re,dam,r,rp,rc)
		return dam+Duel.GetMatchingGroupCount(cm.cf11,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)*500/Duel.GetMatchingGroupCount(cm.cf12,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)
	end)
	c:RegisterEffect(e2)
--e3
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(cm.cf3,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
	end)
	e3:SetValue(500)
	c:RegisterEffect(e3)
end
--e1
function cm.cf11(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x388)
end
function cm.cf12(c)
	return c:IsFaceup() and c:IsCode(m) and not c:IsDisabled()
end
--e3
function cm.cf3(c)
	return c:IsCode(m-1) and c:IsFaceup()
end