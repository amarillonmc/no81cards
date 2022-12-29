local m=53799251
local cm=_G["c"..m]
cm.name="被代替者"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetOperation(cm.costop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetProperty(0)
	e3:SetTargetRange(0xff,0)
	e3:SetTarget(cm.costtg)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(0x10000000+m)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e6:SetCondition(function(e)return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)<=1 end)
	c:RegisterEffect(e6)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and c:IsAbleToChangeControler() and c:CheckUniqueOnField(1-tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then Duel.MoveToField(c,1-tp,1-tp,LOCATION_SZONE,c:GetPosition(),true) end
end
function cm.costtg(e,te_or_c,tp)
	return te_or_c:IsType(TYPE_EFFECT)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,m)-1
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>ct and Duel.IsPlayerCanSpecialSummonMonster(tp,53799252,0,TYPES_TOKEN_MONSTER,900,900,1,RACE_AQUA,ATTRIBUTE_WATER) and (e:GetHandler():IsAbleToGraveAsCost() or (e:GetHandler():IsCanTurnSet() and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_SSET) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>ct)) then
		Duel.Hint(HINT_CARD,0,m)
		local c=e:GetHandler()
		local token=Duel.CreateToken(tp,53799252)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		if c:IsAbleToGraveAsCost() and (Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 or not c:IsCanTurnSet() or Duel.SelectOption(1-tp,1191,1153)==0) then Duel.SendtoGrave(c,REASON_COST) else
			Duel.MoveToField(c,1-tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,false)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,1-tp,1-tp,0)
		end
	end
end
