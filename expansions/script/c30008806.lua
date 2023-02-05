--终极空隙机 时空裁定者
local m=30008806
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,nil,2,75)
	--Effect 1
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCountLimit(1)
	e5:SetTarget(cm.efftg)
	e5:SetOperation(cm.effop)
	c:RegisterEffect(e5)  
	--Effect 2
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,1))
	e51:SetCategory(CATEGORY_TOHAND)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_MZONE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCost(cm.ugmcost)
	e51:SetTarget(cm.ugmtg)
	e51:SetOperation(cm.ugmop)
	c:RegisterEffect(e51) 
	--Effect 3 
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_TOHAND+CATEGORY_TOEXTRA)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e12:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e12:SetCountLimit(1)
	e12:SetTarget(cm.thetg)
	e12:SetOperation(cm.theop)
	c:RegisterEffect(e12) 
end
--xyz summon
function cm.mfilter(c,xyzc)
	local x1=c:IsXyzLevel(xyzc,9)
	local x2=c:IsXyzLevel(xyzc,10)
	local x3=c:IsXyzLevel(xyzc,11)
	local x4=c:IsXyzLevel(xyzc,12)
	local x5=c:IsLevelAbove(13)
	return c:IsRace(RACE_MACHINE) and (x1 or x2 or x3 or x4 or x5)
end
--Effect 1
function cm.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsFacedown() and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_REMOVED)) then return false end
	if c:GetType()&TYPE_MONSTER==0 or c:GetBaseDefense()~=3333 then return false end
	local te=c.gap_machine_remove_effect
	if not te then return false end
	local tg=te:GetTarget()
	return tg==nil or (tg and tg(e,tp,eg,ep,ev,re,r,rp,0))
end
function cm.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ec=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.efffilter(chkc,e,tp,eg,ep,ev,re,r,rp) and chkc~=ec end
	if chk==0 then return Duel.IsExistingTarget(cm.efffilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,ec,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.efffilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,ec,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local te=tc.gap_machine_remove_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		local te=tc.gap_machine_remove_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
--Effect 2
function cm.ugmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end  
function cm.f(c,tp)
	return c:IsAbleToHand(tp) or c:IsAbleToGrave()
end
function cm.ugmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and cm.f(chkc,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingTarget(cm.f,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,cm.f,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,tp):GetFirst()
	local ch=Duel.GetCurrentChain()
	if ch>1 then
		local te=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_EFFECT)
		if te:GetHandler()==tc then
			e:SetCategory(CATEGORY_NEGATE)  
		end
	end
end
function cm.ugmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local ch=Duel.GetCurrentChain()
	if ch>1 then
		local te=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_EFFECT)
		if te:GetHandler()==tc and Duel.IsChainNegatable(ch-1)
			and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.NegateActivation(ch-1)
		end
	end
	if tc:IsAbleToGrave() and (not tc:IsAbleToHand(tp) or Duel.SelectOption(tp,1191,1190)==0) then   
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	else
		Duel.SendtoHand(tc,e:GetHandlerPlayer(),REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--Effect 3 
function cm.tdfilter(c)
	local b1=c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)
	return c:GetBaseDefense()==3333 and b1 and c:IsAbleToHand()
end
function cm.thetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c) and c:IsAbleToExtra() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
end
function cm.theop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetActivateLocation()==LOCATION_GRAVE and c:IsHasEffect(EFFECT_NECRO_VALLEY) then return end
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsLocation(LOCATION_EXTRA) and tc:IsRelateToEffect(e) then	  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end 
