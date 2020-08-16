--多元闪刀起动-交闪
--閃刀起動－エンゲージ
function c978210006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c978210006.condition)
	e1:SetTarget(c978210006.target)
	e1:SetOperation(c978210006.activate)
	c:RegisterEffect(e1)
-----
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e3)
end
function c978210006.cfilter(c)
	return c:GetSequence()<5
end
function c978210006.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c978210006.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c978210006.filter(c)
	return c:IsSetCard(0x2115) and c:IsAbleToHand() and not c:IsCode(978210006)
end
function c978210006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c978210006.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	end
end
function c978210006.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c978210006.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsPlayerCanDraw(tp,1)
			and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3
			and Duel.SelectYesNo(tp,aux.Stringid(978210006,0)) then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end