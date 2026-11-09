--奇袭馈礼！
function c33740030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33740030.target)
	e1:SetOperation(c33740030.activate)
	c:RegisterEffect(e1)
end
function c33740030.rlfilter(c)
	return c:IsLevelAbove(1) and c:IsReleasableByEffect()
end
function c33740030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33740030.rlfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c33740030.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sc=Duel.SelectMatchingCard(tp,c33740030.rlfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if not sc then return end
	local lv=sc:GetLevel()
	if Duel.Release(sc,REASON_EFFECT)==0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	sc:CreateEffectRelation(e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,lv,nil)
	--
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33740030,0))
	local tg=g:Select(tp,1,#g,nil)
	Duel.SendtoDeck(tg,1-tp,SEQ_DECKTOP,REASON_EFFECT)
	for p in aux.TurnPlayers() do Duel.ShuffleDeck(p) end
	if #tg>=1 then
		for p in aux.TurnPlayers() do Duel.Recover(p,1000,REASON_EFFECT,true) end
		Duel.RDComplete()
	end
	if #tg>=2 then
		for p in aux.TurnPlayers() do
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local tc=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,0,LOCATION_GRAVE,1,1,nil):GetFirst()
			if tc then
				Duel.HintSelection(Group.FromCards(tc))
				Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
			end
		end
	end
	if #tg>=3 and sc:IsRelateToEffect(e) then
		local b1=Duel.GetMZoneCount(tp)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local b2=Duel.GetMZoneCount(1-tp)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
		local p=b1 and tp or 1-tp
		if b1 and b2 then
			p=Duel.SelectOption(tp,aux.Stringid(33740030,2),aux.Stringid(33740030,3))==0 and tp or 1-tp
		end
		Duel.SpecialSummon(sc,0,tp,p,false,false,POS_FACEUP)
	end
	if #tg>=4 then
		for p in aux.TurnPlayers() do
			if Duel.Draw(p,4,REASON_EFFECT)~=0 then
				Duel.DiscardHand(p,Card.IsDiscardable,2,2,REASON_EFFECT+REASON_DISCARD)
			end
		end
	end
	if #tg>=5 then
		local g0=Duel.GetFieldGroup(0,LOCATION_HAND,0)
		local g1=Duel.GetFieldGroup(1,LOCATION_HAND,0)
		Duel.SendtoHand(g1,0,REASON_EFFECT)
		Duel.SendtoHand(g0,1,REASON_EFFECT)
	end
end
