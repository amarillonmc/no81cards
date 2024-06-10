--完全入梦
function c33703033.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33703033+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33703033.target)
	e1:SetOperation(c33703033.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c33703033.handcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c33703033.condition)
	e3:SetOperation(c33703033.operation)
	c:RegisterEffect(e3)
end
function c33703033.handcon(e,tp)
	return Duel.GetLP(tp) < Duel.GetLP(1-tp)
end
function c33703033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,1-tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function c33703033.tgfilter(c,rc,att)
	return c:IsAbleToGrave()
end
function c33703033.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33703033.tgfilter,1-tp,LOCATION_ONFIELD,0,nil)
	if #g>0 then 
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		if Duel.SendtoGrave(sg,REASON_EFFECT)>0 then
			Duel.Recover(1-tp,2000,REASON_EFFECT)
		end
	end
end
function c33703033.condition(e,c)
	return c:IsLocation(LOCATION_GRAVE)
end
function c33703033.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end