--逐彩的永夏 七海
function c9910966.initial_effect(c)
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetOperation(c9910966.flag)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910966)
	e1:SetCost(c9910966.spcost)
	e1:SetTarget(c9910966.sptg)
	e1:SetOperation(c9910966.spop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9910966)
	e2:SetCondition(c9910966.discon)
	e2:SetCost(c9910966.discost)
	e2:SetTarget(c9910966.distg)
	e2:SetOperation(c9910966.disop)
	c:RegisterEffect(e2)
	if not c9910966.global_check then
		c9910966.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(c9910966.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9910966.flag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) then
		c:RegisterFlagEffect(9910963,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910963,3))
	end
end
function c9910966.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsReason(REASON_EFFECT) and tc:IsFacedown() and not tc:IsSetCard(0x5954) then
			tc:RegisterFlagEffect(9910963,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910963,3))
		end
		tc=eg:GetNext()
	end
end
function c9910966.tdfilter(c)
	return c:IsFacedown() and c:IsAbleToDeckOrExtraAsCost()
end
function c9910966.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910966.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9910966.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,4,4,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c9910966.spfilter(c,e,tp)
	return c:IsSetCard(0x5954) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910966.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910966.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9910966.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c9910966.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910966,0))
			local lv=Duel.AnnounceNumber(tp,1,2,3)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(lv)
			tc:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	end
end
function c9910966.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev)
end
function c9910966.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c9910966.rmfilter(c,tp)
	return c:IsSetCard(0x5954) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c9910966.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove(tp,POS_FACEDOWN)
		and Duel.IsExistingMatchingCard(c9910966.rmfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c9910966.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910966.rmfilter,tp,LOCATION_HAND,0,1,1,c)
	if #g==0 or not c:IsRelateToEffect(e) or not c:IsAbleToRemove(tp,POS_FACEDOWN) then return end
	g:AddCard(c)
	Duel.ConfirmCards(1-tp,g)
	if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)==2 then
		Duel.NegateEffect(ev)
	end
end
