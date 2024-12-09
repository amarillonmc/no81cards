--远古造物 塔利怪物
dofile("expansions/script/c9910700.lua")
function c9910712.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xc950),2,2)
	--flag
	QutryYgzw.AddTgFlag(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9910712)
	e1:SetCondition(c9910712.setcon)
	e1:SetTarget(c9910712.settg)
	e1:SetOperation(c9910712.setop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910713)
	e2:SetCost(c9910712.thcost)
	e2:SetTarget(c9910712.thtg)
	e2:SetOperation(c9910712.thop)
	c:RegisterEffect(e2)
end
function c9910712.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9910712.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(QutryYgzw.SetFilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c9910712.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,QutryYgzw.SetFilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then QutryYgzw.Set(tc,e,tp) end
end
function c9910712.cfilter(c,tp)
	return c:IsFacedown() and c:IsAbleToGraveAsCost()
end
function c9910712.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910712.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910712.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910712.thfilter(c)
	return c:IsSetCard(0xc950) and c:IsAbleToHand()
end
function c9910712.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,4) end
end
function c9910712.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,4) then
		Duel.ConfirmDecktop(tp,4)
		local g=Duel.GetDecktopGroup(tp,4)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			if g:IsExists(c9910712.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9910712,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,c9910712.thfilter,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
			end
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		end
	end
end
