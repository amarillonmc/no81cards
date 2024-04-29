--相剑鬼胎-湛虑
function c130918820.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(130918820,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,130918820)
	e1:SetCost(c130918820.rmcost)
	e1:SetTarget(c130918820.rmtg)
	e1:SetOperation(c130918820.rmop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(130918820,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,230918820)
	e2:SetCost(c130918820.spcost)
	e2:SetTarget(c130918820.sptg)
	e2:SetOperation(c130918820.spop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(130918820,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,330918820)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(c130918820.thcon)
	e3:SetTarget(c130918820.thtg)
	e3:SetOperation(c130918820.thop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(130918820,3))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,430918820)
	e4:SetTarget(c130918820.sctg)
	e4:SetOperation(c130918820.scop)
	c:RegisterEffect(e4)
end
function c130918820.dfilter(c)
	return (c:IsRace(RACE_WYRM) or c:IsSetCard(0x16b)) and c:IsDiscardable()
end
function c130918820.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.IsExistingMatchingCard(c130918820.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c130918820.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c130918820.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK+LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c130918820.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK+LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,REASON_EFFECT)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c130918820.rfilter(c)
	return (c:IsRace(RACE_WYRM) or c:IsSetCard(0x16b)) and c:IsAbleToRemoveAsCost()
end
function c130918820.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c130918820.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c130918820.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c130918820.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c130918820.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c130918820.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c130918820.thfilter(c)
	return c:IsSetCard(0x16b) and c:IsFaceup() and c:IsAbleToHand() and not c:IsCode(130918820)
end
function c130918820.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c130918820.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c130918820.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c130918820.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c130918820.scfilter(c)
	return c:IsSetCard(0x16b) and c:IsAbleToHand()
end
function c130918820.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c130918820.scfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c130918820.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c130918820.scfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
