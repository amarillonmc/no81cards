--赤井心的嘴臭
function c9980730.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMING_TOHAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9980730.condition)
	e1:SetTarget(c9980730.target)
	e1:SetOperation(c9980730.activate)
	c:RegisterEffect(e1)
end
function c9980730.filter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c9980730.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9980730.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler())
end
function c9980730.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,2)
end
function c9980730.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	local dg=g:RandomSelect(tp,2)
	Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
end