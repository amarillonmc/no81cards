--超级烈焰加农炮
function c98920006.initial_effect(c)
		--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98920006+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c98920006.activate)
	c:RegisterEffect(e1)   
 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920006,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)	
	e2:SetCondition(c98920006.descon)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,98922006)
	e2:SetTarget(c98920006.sptg)
	e2:SetOperation(c98920006.spop)
	c:RegisterEffect(e2)  
  --tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,98930006)
	e2:SetCondition(c98920006.condition)
	e2:SetTarget(c98920006.target)
	e2:SetOperation(c98920006.operation)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e2)
end
function c98920006.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x32) and c:IsAbleToHand()
end
function c98920006.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98920006.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98920006,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c98920006.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c98920006.spfilter(c,e,tp)
	return c:IsSetCard(0x32) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920006.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)  
end
function c98920006.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920006.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tg=Duel.GetMatchingGroup(c98920006.tgfilter,tp,0,LOCATION_ONFIELD,nil,tc:GetColumnGroup())
		if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98920006,1)) then
			Duel.BreakEffect()
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
end
function c98920006.tgfilter(c,g)
	return g:IsContains(c)
end
function c98920006.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c98920006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND,0,1,nil,0x32) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98920006.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,1,1,nil,0x32)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end