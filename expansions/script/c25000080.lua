local m=25000080
local cm=_G["c"..m]
cm.name="ZGMF-X20A 强袭自由"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
cm.material_type=TYPE_SYNCHRO
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	return te and te:GetHandler()==e:GetHandler() and rp==1-tp and re:GetHandler():IsRelateToEffect(re)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 and re:GetHandler():IsDestructable() end
	e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(re:GetHandler())
		c:RegisterEffect(e1)
		if not re:GetHandler():IsRelateToEffect(re) then return end
		Duel.BreakEffect()
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.efilter(e,te)
	return te:GetHandler()==e:GetLabelObject()
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=false
	local ct=Duel.GetCurrentChain()
	if ct>0 then
		local te,tep=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		b1=tep~=tp and Duel.IsChainNegatable(ct)
	end
	local b2=Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local nct=Duel.GetCurrentChain()-1
	local nte,ntep=Duel.GetChainInfo(nct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	b1=ntep~=tp and Duel.IsChainNegatable(nct)
	local sel=0
	local ac=0
	if b1 and b2 then
		ac=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 then
		ac=Duel.SelectOption(tp,aux.Stringid(m,0))
	else
		ac=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	if ac==0 or ac==2 then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		if nte:GetHandler():IsDestructable() and nte:GetHandler():IsRelateToEffect(nte) then Duel.SetOperationInfo(0,CATEGORY_DESTROY,nte:GetHandler(),1,0,0) end
	end
	if ac==1 or ac==2 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
		if ac==2 then e:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DISABLE) end
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	end
	e:SetLabel(ac)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op~=1 then
		local ct=Duel.GetCurrentChain()-1
		if ct>0 then
			local te,tep=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			if Duel.NegateActivation(ct) and te:GetHandler():IsRelateToEffect(te) then Duel.Destroy(te:GetHandler(),REASON_EFFECT) end
		end
	end
	if op~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			Duel.AdjustInstantly()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
