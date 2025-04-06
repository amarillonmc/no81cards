--故国龙裔·北坎
function c88480111.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,88480111)
	e1:SetCondition(c88480111.spcon)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,88480111+1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c88480111.thtg)
	e2:SetOperation(c88480111.thop)
	c:RegisterEffect(e2)
end
function c88480111.spcfilter(c)
	return c:IsSetCard(0x410) and c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end
function c88480111.spcon(e,c)
	return not Duel.IsExistingMatchingCard(c88480111.spcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c88480111.thfilter(c)
	return c:IsSetCard(0x410) and c:IsType(0x2) and c:IsAbleToHand()
end
function c88480111.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88480111.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88480111.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88480111.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end