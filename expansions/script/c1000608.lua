--圆香的守望者  晓美焰
function c1000608.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1000608+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c1000608.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(c1000608.cost)
	e2:SetOperation(c1000608.op)
	c:RegisterEffect(e2)
end
function c1000608.tdfilter(c)
	return c:IsSetCard(0xc204) and not c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c1000608.tgfilter(c)
	return c:IsSetCard(0xc204) and not c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave()
end
function c1000608.spfilter(c,e,tp)
	return c:IsSetCard(0xc204) and not c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1000608.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(c1000608.tdfilter,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c1000608.tgfilter,tp,LOCATION_DECK,0,nil)
	local g3=Duel.GetMatchingGroup(c1000608.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1000608,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
		elseif g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1000608,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg2,REASON_EFFECT)
		elseif g3:GetCount()>0 and  Duel.SelectYesNo(tp,aux.Stringid(1000608,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg3=g3:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg3,0,tp,tp,false,false,POS_FACEUP)
		end
end
function c1000608.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c1000608.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c1000608.rdval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c1000608.rdval(e,re,dam,r,rp,rc)
		if bit.band(r,REASON_BATTLE)~=0 then
		return dam/2
	else return dam end
end