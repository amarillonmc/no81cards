--悠悠的圣诞礼物
local s,id=GetID()
function s.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1)) then return end
	Duel.Draw(tp,1,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	Duel.Draw(1-tp,1,REASON_EFFECT)
	local g2=Duel.GetOperatedGroup()
	g:Merge(g2)
	if #g==0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.ConfirmCards(1-tp,g)
	local tc=g:GetFirst()
	while tc do
		local p=tc:GetControler()
		if tc:IsLocation(LOCATION_HAND)
			and tc:IsType(TYPE_MONSTER) and tc:IsType(TYPE_NORMAL)
			and Duel.GetLocationCount(p,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,p,false,false)
			and Duel.SelectYesNo(p,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
			Duel.SpecialSummon(tc,0,p,p,false,false,POS_FACEUP)
		else
			if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,p,LOCATION_HAND,0,1,nil) then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
				local hg=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,1,1,nil)
				if #hg>0 then
					Duel.SendtoDeck(hg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
				end
			end
		end
		tc=g:GetNext()
	end
	Duel.ShuffleHand(tp)
	Duel.ShuffleHand(1-tp)
end
