local m=87530065
local cm=_G["c"..m]
cm.name="塞莉迪姆之虫惑魔"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetCondition(cm.imcon)
	e0:SetValue(cm.efilter)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.tdcost)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)
	--xm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.retcon)
	e2:SetTarget(cm.rettg)
	e2:SetOperation(cm.retop)
	c:RegisterEffect(e2)
end
function cm.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function cm.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local rt=Duel.GetTargetCount(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	local ct=c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	e:SetLabel(ct)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,ct,ct,nil)
	if tg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		local cct=tg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tg,cct,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,ct,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then
		Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
end
function cm.evfilter(c,ev)
	if c:IsHasEffect(m) and c:IsFaceup() then
		for _,i in ipairs{c:IsHasEffect(m)} do
			if i:GetLabel() and i:GetLabel()<ev then return true end
		end
	end
	return false
end
function cm.repcon(e,tp,eg,ep,ev,re,r,rp)
	local tp,aev=e:GetLabel()
	return not Duel.IsExistingMatchingCard(cm.evfilter,tp,LOCATION_MZONE,0,1,nil,aev)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local aeg,aep,aev,are,ar,arp=Duel.GetChainEvent(0)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	e4:SetCondition(cm.repcon)
	e4:SetTarget(cm.reptg)
	e4:SetValue(cm.repval)
	e4:SetLabel(tp,aev)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	c:RegisterEffect(e4)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e4:SetLabelObject(g)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(m)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	e2:SetLabel(aev)
	c:RegisterEffect(e2)
	Duel.RegisterFlagEffect(0,m,RESET_CHAIN,0,1)
	--
	if not cm.global_check then
		cm.global_check=true
		_jiuyuanchongDiscardDeck=Duel.DiscardDeck
		function Duel.DiscardDeck(p,ct,r)
			if Duel.GetFlagEffect(0,m)==0 then return _jiuyuanchongDiscardDeck(p,ct,r) end
			local g=Duel.GetDecktopGroup(p,ct)
			local tc=g:GetFirst()
			while tc do
				tc:RegisterFlagEffect(m+1,RESET_CHAIN,EFFECT_FLAG_SET_AVAILABLE,1)
				tc=g:GetNext()
			end
			Duel.DisableShuffleCheck()
			local res=Duel.SendtoGrave(g,r)
			return res
		end
	end
end
function cm.repfilter(c,tp)
	return ((c:GetDestination()==LOCATION_GRAVE or c:GetDestination()==LOCATION_REMOVED) or (c:GetFlagEffect(m+1)>0))
		and c:IsCanOverlay(tp) and c:GetReasonPlayer()==1-tp and not c:IsHasEffect(m)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp,aev=e:GetLabel()
	if chk==0 then return ((not re) or re~=e) and eg:IsExists(cm.repfilter,1,e:GetHandler(),tp) and e:GetHandler():IsFaceup() end
	if eg:IsExists(cm.repfilter,1,e:GetHandler(),tp) then
		local container=e:GetLabelObject()
		container:Clear()
		local g=eg:Filter(cm.repfilter,e:GetHandler(),tp)
		local tc=g:GetFirst()
		local bg=g:Clone()
		while tc do
			tc:CancelToGrave()
			if tc:GetOverlayCount()~=0 then
				local ag=tc:GetOverlayGroup()
				Duel.SendtoGrave(ag,REASON_RULE)
			end
			if tc:IsLocation(LOCATION_DECK) then Duel.DisableShuffleCheck() end
			Duel.Overlay(e:GetHandler(),tc)
			tc=g:GetNext()
		end
		container:Merge(bg)
		return true
	else return false end
end
function cm.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end