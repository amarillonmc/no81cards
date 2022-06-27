--电子音姬合奏
function c33200650.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33200650.target)
	e1:SetOperation(c33200650.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,33200650)
	e2:SetTarget(c33200650.drtarget)
	e2:SetOperation(c33200650.dractivate)
	c:RegisterEffect(e2)  
end

--e1
function c33200650.spfilter1(c,e,tp)
	return c:IsSetCard(0xa32a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function c33200650.spfilter2(c,e,tp)
	return c:IsSetCard(0xa32a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33200650.xyzfilter(c,tc,mc)
	return c:IsSetCard(0xa32a) and c:IsXyzSummonable(Group.FromCards(tc,mc),2,2)
end

function c33200650.spfilter3(c,e,tp,sgc)
	return c:IsSetCard(0xa32a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c33200650.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,c,sgc) and not c:IsPublic()
end
function c33200650.xyzfilter2(c,g)
	return c:IsSetCard(0xa32a) and c:IsXyzSummonable(g,g:GetCount(),g:GetCount())
end
function c33200650.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c33200650.spfilter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c33200650.spfilter2,tp,LOCATION_HAND,0,nil,e,tp)
	local g=Group.CreateGroup()
	local tc=g1:GetFirst()
	while tc do
		local mc=g2:GetFirst()
		while mc do
			if Duel.IsExistingMatchingCard(c33200650.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,tc,mc) then
				if not g:IsContains(tc) then g:AddCard(tc) end
			end
			mc=g2:GetNext()
		end
	tc=g1:GetNext()
	end
	--Debug.Message(g:GetCount())
	if chk==0 then return ft>1 and Duel.IsPlayerCanSpecialSummonCount(tp,2) and g:GetCount()>0
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	Duel.SetTargetCard(sg)
	local sgc=sg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg2=Duel.SelectMatchingCard(tp,c33200650.spfilter3,tp,LOCATION_HAND,0,1,1,nil,e,tp,sgc)
	Duel.ConfirmCards(1-tp,sg2)
	Duel.ShuffleHand(tp)
	local sgc2=sg2:GetFirst()
	e:SetLabelObject(sgc2)
	sg:Merge(sg2)
	--Debug.Message(sg:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,2,0,0)
end
function c33200650.spfilter4(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33200650.spfilter5(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33200650.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c33200650.spfilter4,nil,e,tp)
	local sgc2=e:GetLabelObject()
	if g:GetCount()==0 or not sgc2:IsLocation(LOCATION_HAND) then return end
	g:AddCard(sgc2)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local og=Duel.GetOperatedGroup()
	Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
	if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<g:GetCount() then return end
	local tg=Duel.GetMatchingGroup(c33200650.xyzfilter2,tp,LOCATION_EXTRA,0,nil,og)
	if og:GetCount()==g:GetCount() and tg:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=tg:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,rg:GetFirst(),og,og:GetCount(),og:GetCount())
	end
end

--e2
function c33200650.drfilter(c)
	return c:IsSetCard(0xa32a) and c:IsAbleToDeck()
end
function c33200650.drtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33200650.drfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(c33200650.drfilter,tp,LOCATION_GRAVE,0,3,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c33200650.drfilter,tp,LOCATION_GRAVE,0,3,3,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33200650.dractivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) or c:IsLocation(LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 and c:IsLocation(LOCATION_DECK) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end