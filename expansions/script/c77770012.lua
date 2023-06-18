--心结(注：狸子DIY)
function c77770012.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,77770012+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c77770012.condition)
	e1:SetCost(c77770012.cost)
	e1:SetOperation(c77770012.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function c77770012.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetAttacker():GetControler()~=tp
end
function c77770012.cfilter(c)
	return c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c77770012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	hg:RemoveCard(e:GetHandler())
	if chk==0 then return hg:GetCount()>0 and hg:FilterCount(c77770012.cfilter,nil)==hg:GetCount() end
	Duel.SendtoGrave(hg,REASON_COST+REASON_DISCARD)
end
function c77770012.activate(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end