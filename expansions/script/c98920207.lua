--自奏圣乐·卡利亚
function c98920207.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c98920207.lcheck) 
  --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c98920207.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e0)
--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920207,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98920207)
	e2:SetCondition(c98920207.tdcon1)
	e2:SetTarget(c98920207.tdtg)
	e2:SetOperation(c98920207.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCondition(c98920207.tdcon2)
	c:RegisterEffect(e3)
end
function c98920207.lcheck(g,lc)
	return g:IsExists(c98920207.mzfilter,1,nil)
end
function c98920207.mzfilter(c)
	return c:IsLinkRace(RACE_MACHINE) and c:IsLinkType(TYPE_LINK)
end
function c98920207.indcon(e)
	return e:GetHandler():IsLinkState()
end
function c98920207.tdfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAbleToDeck()
end
function c98920207.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c98920207.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920207.tdfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98920207.tdfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c98920207.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
		local g1=Duel.GetMatchingGroup(c98920207.thfilter1,tp,LOCATION_DECK,0,nil)
		local g2=Duel.GetMatchingGroup(c98920207.thfilter2,tp,LOCATION_DECK,0,nil)
		if g1:GetCount()>0 and g2:GetCount()>0 then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		   local sg1=g1:Select(tp,1,1,nil)
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		   local sg2=g2:Select(tp,1,1,nil)
		   sg1:Merge(sg2)
			Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,sg1)
		end
	end
end
function c98920207.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,90351981)
end
function c98920207.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,90351981)
end
function c98920207.thfilter1(c)
	return c:IsSetCard(0x11b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98920207.thfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x11b) and c:IsAbleToHand()
end