--觉觉之女仆
function c9950420.initial_effect(c)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950420,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCondition(c9950420.spcon)
	e1:SetValue(c9950420.spval)
	c:RegisterEffect(e1)
	 --deckdes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950420,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c9950420.ddtg)
	e1:SetOperation(c9950420.ddop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
 --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9950420)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9950420.thtg)
	e2:SetOperation(c9950420.thop)
	c:RegisterEffect(e2)
end
function c9950420.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=Duel.GetLinkedZone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c9950420.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end
function c9950420.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,4) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,4)
end
function c9950420.ddop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,4,REASON_EFFECT)
end
function c9950420.thfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToHand()
end
function c9950420.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950420.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950420.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950420.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end