local m=15005072
local cm=_G["c"..m]
cm.name="失落水理·三终渊之花"
function cm.initial_effect(c)
	--search (hand/grave)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,15005072)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,15005073)
	e2:SetHintTiming(0,TIMING_CHAIN_END)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
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
function cm.thfilter(c)
	return c:IsSetCard(0xcf3e) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c)
	if chk==0 then return rg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	rc=rg:FilterSelect(tp,cm.rmfilter,1,1,nil):GetFirst()
	if rc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,rc) end
	Duel.Remove(rc,POS_FACEDOWN,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local rc=re:GetHandler()
	if c:IsFacedown() and c:IsReason(REASON_COST) and re and re:IsActivated() and (rc:IsSetCard(0xcf3e) or (rc:IsAttribute(ATTRIBUTE_DARK) and re:IsActiveType(TYPE_MONSTER))) then
		local id=c:GetFieldID()
		Duel.RegisterFlagEffect(p,15005072,RESET_CHAIN,0,1,id)
	end
	if c:IsFacedown() then
		local id=c:GetFieldID()
		Duel.RegisterFlagEffect(p,15005073,RESET_PHASE+PHASE_END,0,1,id)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local id=c:GetFieldID()
	local b1=false
	local b2=false
	if Duel.GetFlagEffect(p,15005072)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(p,15005072)} do
			if i==id then b1=true end
		end
	end
	if Duel.GetFlagEffect(p,15005073)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(p,15005073)} do
			if i==id then b2=true end
		end
	end
	return c:IsFacedown() and (b1 or (Duel.IsPlayerAffectedByEffect(p,15005084) and b2))
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xcf3e) and c:IsType(TYPE_MONSTER) and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,tp,c) and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFacedown())) and not c:IsCode(15005072) and not c:IsType(TYPE_FUSION)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end