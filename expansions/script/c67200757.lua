--噩梦回廊复归
function c67200757.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c67200757.condition)
	e1:SetTarget(c67200757.target)
	e1:SetOperation(c67200757.activate)
	c:RegisterEffect(e1)
	--def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetTarget(c67200757.atktg)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
end
function c67200757.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x67d) and c:IsType(TYPE_PENDULUM)
end
function c67200757.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c67200757.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c67200757.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,1-tp,0,LOCATION_ONFIELD,c)
	if chk==0 then return g:GetCount()>0 and #g1>0 end
	g:Merge(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c67200757.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,1-tp,0,LOCATION_ONFIELD,1,1,c)
	g:Merge(g1)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
--
function c67200757.atktg(e,c)
	return c:IsSetCard(0x67d) and c:IsType(TYPE_PENDULUM)
end