--空竞名宿 各务葵
function c9910241.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c9910241.matfilter,2)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c9910241.efilter)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c9910241.tdcon)
	e3:SetTarget(c9910241.tdtg)
	e3:SetOperation(c9910241.tdop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(9910241,ACTIVITY_CHAIN,c9910241.chainfilter1)
	Duel.AddCustomActivityCounter(9910242,ACTIVITY_CHAIN,c9910241.chainfilter2)
	Duel.AddCustomActivityCounter(9910243,ACTIVITY_CHAIN,c9910241.chainfilter3)
	Duel.AddCustomActivityCounter(9910244,ACTIVITY_CHAIN,c9910241.chainfilter4)
end
function c9910241.chainfilter1(re,tp,cid)
	return not (re:GetHandler():IsRace(RACE_PSYCHO) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND)
end
function c9910241.chainfilter2(re,tp,cid)
	return not (re:GetHandler():IsRace(RACE_PSYCHO) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_SEQUENCE)<5)
end
function c9910241.chainfilter3(re,tp,cid)
	return not (re:GetHandler():IsRace(RACE_PSYCHO) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_SEQUENCE)>4)
end
function c9910241.chainfilter4(re,tp,cid)
	return not (re:GetHandler():IsRace(RACE_PSYCHO) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_GRAVE)
end
function c9910241.matfilter(c)
	return c:IsLinkRace(RACE_PSYCHO) and c:IsLinkType(TYPE_LINK)
end
function c9910241.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) then return true end
	return te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)
end
function c9910241.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9910241.tdfilter(c,tp)
	local b1=c:IsLocation(LOCATION_HAND) and Duel.GetCustomActivityCount(9910241,tp,ACTIVITY_CHAIN)>0
	local b2=c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 and Duel.GetCustomActivityCount(9910242,tp,ACTIVITY_CHAIN)>0
	local b3=c:IsLocation(LOCATION_MZONE) and c:GetSequence()>4 and Duel.GetCustomActivityCount(9910243,tp,ACTIVITY_CHAIN)>0
	local b4=c:IsLocation(LOCATION_GRAVE) and Duel.GetCustomActivityCount(9910244,tp,ACTIVITY_CHAIN)>0
	return c:IsAbleToDeck() and (b1 or b2 or b3 or b4)
end
function c9910241.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9910241.tdfilter,tp,0,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,1,nil,tp) end
	local sel=0
	local ct2=0
	local ct3=0
	if c:IsRace(RACE_PSYCHO) then
		if c:GetSequence()<5 then ct2=1 end
		if c:GetSequence()>4 then ct3=1 end
	end
	if Duel.GetCustomActivityCount(9910241,tp,ACTIVITY_CHAIN)>0 then sel=sel+1 end
	if Duel.GetCustomActivityCount(9910242,tp,ACTIVITY_CHAIN)>ct2 then sel=sel+2 end
	if Duel.GetCustomActivityCount(9910243,tp,ACTIVITY_CHAIN)>ct3 then sel=sel+4 end
	if Duel.GetCustomActivityCount(9910244,tp,ACTIVITY_CHAIN)>0 then sel=sel+8 end
	e:SetLabel(sel)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
end
function c9910241.tdfilter2(c)
	return c:GetSequence()<5 and c:IsAbleToDeck()
end
function c9910241.tdfilter3(c)
	return c:GetSequence()>4 and c:IsAbleToDeck()
end
function c9910241.tdop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then return end
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	local b1=bit.band(sel,1)~=0 and #g1>0
	local g2=Duel.GetMatchingGroup(c9910241.tdfilter2,tp,0,LOCATION_MZONE,nil)
	local b2=bit.band(sel,2)~=0 and #g2>0
	local g3=Duel.GetMatchingGroup(c9910241.tdfilter3,tp,0,LOCATION_MZONE,nil)
	local b3=bit.band(sel,4)~=0 and #g3>0
	local g4=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)
	local b4=bit.band(sel,8)~=0 and #g4>0
	local sg=Group.CreateGroup()
	if b1 and ((not b2 and not b3 and not b4) or Duel.SelectYesNo(tp,aux.Stringid(9910241,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=g1:RandomSelect(tp,1)
		sg:Merge(sg1)
	end
	if b2 and ((#sg==0 and not b3 and not b4) or Duel.SelectYesNo(tp,aux.Stringid(9910241,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if b3 and ((#sg==0 and not b4) or Duel.SelectYesNo(tp,aux.Stringid(9910241,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg3=g3:Select(tp,1,1,nil)
		Duel.HintSelection(sg3)
		sg:Merge(sg3)
	end
	if b4 and (#sg==0 or Duel.SelectYesNo(tp,aux.Stringid(9910241,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg4=g4:Select(tp,1,1,nil)
		Duel.HintSelection(sg4)
		sg:Merge(sg4)
	end
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
