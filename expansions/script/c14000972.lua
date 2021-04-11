--灵狐 安綱
local m=14000972
local cm=_G["c"..m]
function cm.initial_effect(c)
	--summon cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_COST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(0xff-LOCATION_HAND)
	e1:SetCost(cm.thcost)
	e1:SetOperation(cm.thcop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e2)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(cm.limval)
	c:RegisterEffect(e2)
end
function cm.thcost(e,c,tp)
	return c:IsAbleToHand() and not c:IsLocation(LOCATION_HAND)
end
function cm.thcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.SendtoHand(c,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function cm.limval(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER)
		and rc:IsPreviousLocation(LOCATION_HAND) and rc:IsSummonType(SUMMON_TYPE_NORMAL+SUMMON_TYPE_SPECIAL)
end