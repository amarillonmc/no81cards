--远远古造物 古老原枝藻
dofile("expansions/script/c9910700.lua")
function c9910749.initial_effect(c)
	--flag
	QutryYgzw.AddTgFlag(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9910749)
	e1:SetTarget(c9910749.thtg)
	e1:SetOperation(c9910749.thop)
	c:RegisterEffect(e1)
end
function c9910749.tdfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xc950) and c:IsAbleToDeck()
end
function c9910749.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc1=Duel.GetDecktopGroup(tp,1):GetFirst()
	local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c9910749.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910749.tdfilter,tp,LOCATION_REMOVED,0,2,nil)
		and ((tc1 and tc1:IsAbleToHand()) or (tc2 and tc2:IsAbleToHand())) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9910749.tdfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9910749.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		local ct=aux.PlaceCardsOnDeckBottom(tp,tg)
		if ct>0 and tg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
			local tc1=Duel.GetDecktopGroup(tp,1):GetFirst()
			local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			local b=tc2 and aux.NecroValleyFilter()(tc2)
			if not tc1 and not b then return end
			if tc1 and (not b or Duel.SelectOption(tp,aux.Stringid(9910749,0),aux.Stringid(9910749,1))==0) then
				Duel.BreakEffect()
				Duel.DisableShuffleCheck()
				tc1:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
				Duel.SendtoHand(tc1,tp,REASON_EFFECT)
			else
				Duel.BreakEffect()
				if Duel.SendtoHand(tc2,tp,REASON_EFFECT)>0 then Duel.ConfirmCards(1-tp,tc2) end
			end
			Duel.ShuffleHand(tp)
		end
	end
end
