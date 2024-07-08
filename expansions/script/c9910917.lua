--神械主将 睥睨者
function c9910917.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910917)
	e1:SetTarget(c9910917.sptg)
	e1:SetOperation(c9910917.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c9910917.spcon)
	e2:SetCost(c9910917.spcost)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9910917.discon)
	e3:SetTarget(c9910917.distg)
	e3:SetOperation(c9910917.disop)
	c:RegisterEffect(e3)
end
function c9910917.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c9910917.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c9910917.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910917.rmfilter,tp,0,LOCATION_GRAVE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9910917.rmfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9910917.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9910917.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c9910917.cfilter(c)
	return c:IsSetCard(0xc954) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9910917.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c9910917.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c)
	local b2=Duel.IsPlayerAffectedByEffect(tp,9910682) and Duel.CheckLPCost(tp,2000)
	if chk==0 then return b1 or b2 end
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(9910682,0))) then
		Duel.PayLPCost(tp,2000)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c9910917.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,c)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c9910917.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return ep==1-tp and rc:IsControler(1-tp) and rc:IsLocation(LOCATION_MZONE)
		and rc:IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
end
function c9910917.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc954) and c:IsAbleToDeck()
end
function c9910917.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED) and chkc:IsControler(tp) and c9910917.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910917.tdfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,2,nil)
		and aux.NegateMonsterFilter(re:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9910917.tdfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,re:GetHandler(),1,0,0)
end
function c9910917.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		if not Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then return end
		local rc=re:GetHandler()
		if rc:IsControler(1-tp) and rc:IsRelateToEffect(re) and rc:IsCanBeDisabledByEffect(e) then
			Duel.NegateRelatedChain(rc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e2)
		end
	end
end
