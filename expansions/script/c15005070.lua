local m=15005070
local cm=_G["c"..m]
cm.name="辞世绝句·三终渊之花"
function cm.initial_effect(c)
	--search (hand/grave)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,15005070)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,15005071)
	e2:SetHintTiming(0,TIMING_CHAIN_END)
	e2:SetCondition(cm.drcon)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
end
function cm.rmfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and c:IsAbleToRemoveAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c)
	if chk==0 then return rg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	rc=rg:FilterSelect(tp,cm.rmfilter,1,1,nil):GetFirst()
	if rc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,rc) end
	Duel.Remove(rc,POS_FACEDOWN,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local rc=re:GetHandler()
	if c:IsFacedown() and c:IsReason(REASON_COST) and re and re:IsActivated() and (rc:IsSetCard(0xcf3e) or (rc:IsAttribute(ATTRIBUTE_DARK) and re:IsActiveType(TYPE_MONSTER))) then
		local id=c:GetFieldID()
		Duel.RegisterFlagEffect(p,15005070,RESET_CHAIN,0,1,id)
	end
	if c:IsFacedown() then
		local id=c:GetFieldID()
		Duel.RegisterFlagEffect(p,15005071,RESET_PHASE+PHASE_END,0,1,id)
	end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local id=c:GetFieldID()
	local b1=false
	local b2=false
	if Duel.GetFlagEffect(p,15005070)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(p,15005070)} do
			if i==id then b1=true end
		end
	end
	if Duel.GetFlagEffect(p,15005071)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(p,15005071)} do
			if i==id then b2=true end
		end
	end
	return c:IsFacedown() and (b1 or (Duel.IsPlayerAffectedByEffect(p,15005084) and b2))
end
function cm.tdfilter(c)
	return c:IsAbleToDeck() and c:IsFacedown() and not c:IsCode(15005070)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	if #tg~=3 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end