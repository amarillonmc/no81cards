--CAN:D 再鲜榨！
function c88888218.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88888218,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88888218)
	e1:SetTarget(c88888218.target)
	e1:SetOperation(c88888218.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88888218,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,88888218)
	e2:SetCost(c88888218.cost)
	e2:SetTarget(c88888218.target2)
	e2:SetOperation(c88888218.activate2)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,18888218)
	e3:SetTarget(c88888218.reptg)
	e3:SetValue(c88888218.repval)
	e3:SetOperation(c88888218.repop)
	c:RegisterEffect(e3)
end
function c88888218.thfilter(c,e,tp,check)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x8908) and c:IsAbleToHand()
		and (check or Duel.IsExistingMatchingCard(c88888218.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp))
end
function c88888218.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x8908) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88888218.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888218.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,true) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88888218.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88888218.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,true)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c88888218.costfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost()
end
function c88888218.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888218.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c88888218.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c88888218.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) 
		and Duel.IsExistingMatchingCard(c88888218.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c88888218.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88888218.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()==0 then
		g=Duel.SelectMatchingCard(tp,c88888218.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,true)
	end
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and tc:IsLocation(LOCATION_HAND)
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c88888218.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88888218.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c88888218.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x8908)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c88888218.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c88888218.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c88888218.repval(e,c)
	return c88888218.repfilter(c,e:GetHandlerPlayer())
end
function c88888218.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end