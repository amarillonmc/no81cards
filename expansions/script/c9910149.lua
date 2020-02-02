--战车道计策·烟雾滚滚
function c9910149.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c9910149.target)
	e1:SetOperation(c9910149.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c9910149.setcon)
	e2:SetCost(c9910149.setcost)
	e2:SetTarget(c9910149.settg)
	e2:SetOperation(c9910149.setop)
	c:RegisterEffect(e2)
end
function c9910149.thfilter(c)
	return c:IsSetCard(0x952) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910149.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c9910149.thfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c9910149.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910149.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	if tg1:GetCount()==2 and Duel.SendtoHand(tg1,nil,REASON_EFFECT)==2 then
		Duel.ConfirmCards(1-tp,tg1)
		Duel.ShuffleDeck(tp)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if sg:GetCount()==0 then return end
		Duel.BreakEffect()
		if Duel.SelectOption(tp,aux.Stringid(9910149,0),aux.Stringid(9910149,1))==0 then
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		else
			Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
		end
	end
end
function c9910149.setcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_DESTROY)~=0
		and bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)~=0
		and bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEDOWN)~=0
end
function c9910149.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c9910149.setfilter(c)
	return c:IsSetCard(0x952) and c:IsType(TYPE_TRAP) and not c:IsCode(9910149) and c:IsSSetable()
end
function c9910149.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910149.setfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c9910149.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910149.setfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	if g:GetCount()==0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=1
		or not Duel.SelectYesNo(tp,aux.Stringid(9910149,2)) then
		Duel.SSet(tp,tg1)
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	Duel.SSet(tp,tg1)
end
