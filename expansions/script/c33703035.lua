--满足
local m=33703035
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=Duel.GetLP(1-tp)-6000
end
function cm.filter(c,e,tp)
	return c:IsAbleToRemove(tp) and c:IsType(TYPE_MONSTER)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk ==0 then return  Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,1,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD,0,1,99,nil)
	local temp =g:GetSum(Card.GetAttack)
	local temp1=g:GetSum(Card.GetDefense)
	if (Duel.GetLP(tp)<=Duel.GetLP(1-tp)-6000) ~=false then
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT) > 0 then
			if true then
				if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
	 				Duel.Recover(tp,temp,REASON_EFFECT)
				else
					Duel.Recover(tp,temp1,REASON_EFFECT)
				end
			end
		end
	else 
	return false
	end
end
