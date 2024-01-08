local m=15005074
local cm=_G["c"..m]
cm.name="未颂龙诗·三终渊之花"
function cm.initial_effect(c)
	--tograve (hand/grave)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,15005074)
	e1:SetCost(cm.tgcost)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	--return to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,15005075)
	e2:SetHintTiming(0,TIMING_CHAIN_END)
	e2:SetCondition(cm.rgcon)
	e2:SetTarget(cm.rgtg)
	e2:SetOperation(cm.rgop)
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
function cm.tgfilter(c)
	return c:IsSetCard(0xcf3e) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and not c:IsCode(15005074)
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c)
	if chk==0 then return rg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	rc=rg:FilterSelect(tp,cm.rmfilter,1,1,nil):GetFirst()
	if rc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,rc) end
	Duel.Remove(rc,POS_FACEDOWN,REASON_COST)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local rc=re:GetHandler()
	if c:IsFacedown() and c:IsReason(REASON_COST) and re and re:IsActivated() and (rc:IsSetCard(0xcf3e) or (rc:IsAttribute(ATTRIBUTE_DARK) and re:IsActiveType(TYPE_MONSTER))) then
		local id=c:GetFieldID()
		Duel.RegisterFlagEffect(p,15005074,RESET_CHAIN,0,1,id)
	end
	if c:IsFacedown() then
		local id=c:GetFieldID()
		Duel.RegisterFlagEffect(p,15005075,RESET_PHASE+PHASE_END,0,1,id)
	end
end
function cm.rgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local id=c:GetFieldID()
	local b1=false
	local b2=false
	if Duel.GetFlagEffect(p,15005074)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(p,15005074)} do
			if i==id then b1=true end
		end
	end
	if Duel.GetFlagEffect(p,15005075)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(p,15005075)} do
			if i==id then b2=true end
		end
	end
	return c:IsFacedown() and (b1 or (Duel.IsPlayerAffectedByEffect(p,15005084) and b2))
end
function cm.rgfilter(c)
	return c:IsSetCard(0xcf3e) and c:IsFacedown()
end
function cm.rgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function cm.rgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.rgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
end