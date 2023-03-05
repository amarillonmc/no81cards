--暮光道剑士 罗兰德
function c98920412.initial_effect(c)
	 --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920412,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98439950)
	e2:SetCost(c98920412.thcost)
	e2:SetTarget(c98920412.thtg)
	e2:SetOperation(c98920412.thop)
	c:RegisterEffect(e2)
--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetDescription(aux.Stringid(98920412,1))
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c98920412.discon)
	e2:SetTarget(c98920412.distg)
	e2:SetOperation(c98920412.disop)
	c:RegisterEffect(e2)
end
function c98920412.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c98920412.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x38)
end
function c98920412.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c98920412.cfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c98920412.disop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c98920412.cfilter,tp,LOCATION_MZONE,0,nil)
	if ct>0 then
		Duel.DiscardDeck(tp,ct,REASON_EFFECT)
	end
end
function c98920412.thcfilter(c)
	return c:IsSetCard(0x38) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c98920412.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920412.thcfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98920412.thcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetAttribute())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c98920412.thfilter(c)
	return c:IsAbleToHand() and not c:IsCode(98920412) and c:IsSetCard(0x38) and c:IsType(TYPE_MONSTER)
end
function c98920412.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920412.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920412.thop(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and bit.band(e:GetLabel(),ATTRIBUTE_DARK)~=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c98920412.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,check):GetFirst()
	if tc then
		if check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end