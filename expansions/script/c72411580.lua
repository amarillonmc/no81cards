--马纳历亚劣等生·露
function c72411580.initial_effect(c)
		--link summon
	c:SetSPSummonOnce(72411580)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_NORMAL),1,1)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c72411580.thtg)
	e1:SetOperation(c72411580.thop)
	c:RegisterEffect(e1)
end
function c72411580.thfilter(c)
	return c:IsSetCard(0x5729) 
end
function c72411580.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72411580.thfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_REMOVED)
end
function c72411580.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c72411580.thfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	if g:GetCount()==3 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=g:RandomSelect(1-tp,1)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		g:Sub(tg)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
