local m=53750011
local cm=_G["c"..m]
cm.name="识乐之森的公士"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.econ)
	e1:SetCost(cm.ecost)
	e1:SetOperation(cm.eop)
	c:RegisterEffect(e1)
end
function cm.econ(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=re:GetHandler():IsType(TYPE_MONSTER) and (c:GetFlagEffect(m)==0 or bit.band(c:GetFlagEffectLabel(m),0x1)==0 or not c:IsHasEffect(EFFECT_IMMUNE_EFFECT))
	local b2=re:GetHandler():IsType(TYPE_SPELL) and (c:GetFlagEffect(m)==0 or bit.band(c:GetFlagEffectLabel(m),0x2)==0 or not c:IsHasEffect(EFFECT_EXTRA_ATTACK))
	local b3=re:GetHandler():IsType(TYPE_TRAP) and (c:GetFlagEffect(m)==0 or bit.band(c:GetFlagEffectLabel(m),0x4)==0 or c:GetAttack()~=c:GetBaseAttack()*2)
	return re:GetHandler()~=c and (b1 or b2 or b3)
end
function cm.cfilter(c)
	return c:IsSetCard(0x9532) and c:GetType()==TYPE_SPELL and c:IsAbleToRemoveAsCost()
end
function cm.ecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and c:GetFlagEffect(m+33)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		c:RegisterFlagEffect(m+33,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		if Duel.Remove(tc,POS_FACEUP,REASON_COST)~=0 and tc:IsLocation(LOCATION_REMOVED) and c:IsType(TYPE_EFFECT) and c:IsLocation(LOCATION_MZONE) and tc:GetActivateEffect() then
			if c:GetFlagEffect(m+66)==0 then c:RegisterFlagEffect(m+66,RESET_CHAIN,0,1) end
			local le={tc:GetActivateEffect()}
			local ct=#le
			local ch=Duel.GetCurrentChain()
			for i,te in pairs(le) do
				local e1=Effect.CreateEffect(c)
				if ct==1 then e1:SetDescription(aux.Stringid(m,2)) else e1:SetDescription(te:GetDescription()) end
				e1:SetCategory(te:GetCategory())
				e1:SetType(EFFECT_TYPE_QUICK_O)
				e1:SetCode(EVENT_FREE_CHAIN)
				e1:SetRange(LOCATION_MZONE)
				e1:SetProperty(te:GetProperty())
				e1:SetLabel(1<<ch)
				e1:SetLabelObject(tc)
				e1:SetValue(i)
				e1:SetTarget(cm.spelltg)
				e1:SetOperation(cm.spellop)
				e1:SetReset(RESET_CHAIN)
				c:RegisterEffect(e1)
			end
		end
	end
end
function cm.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t={e:GetLabelObject():GetActivateEffect()}
	local ae=t[e:GetValue()]
	local ftg=ae:GetTarget()
	local flag=e:GetHandler():GetFlagEffectLabel(m+66)
	if chk==0 then
		e:SetCostCheck(false)
		return (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)) and bit.band(flag,e:GetLabel())==0
	end
	e:GetHandler():SetFlagEffectLabel(m+66,flag|e:GetLabel())
	if ftg then
		e:SetCostCheck(false)
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function cm.spellop(e,tp,eg,ep,ev,re,r,rp)
	local t={e:GetLabelObject():GetActivateEffect()}
	local ae=t[e:GetValue()]
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function cm.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if c:GetFlagEffect(m)==0 then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
	if re:GetHandler():IsType(TYPE_MONSTER) then
		c:SetFlagEffectLabel(m,bit.bor(c:GetFlagEffectLabel(m),0x1))
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(cm.efilter)
		c:RegisterEffect(e1)
	end
	if re:GetHandler():IsType(TYPE_SPELL) then
		c:SetFlagEffectLabel(m,bit.bor(c:GetFlagEffectLabel(m),0x2))
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,3))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(1)
		c:RegisterEffect(e2)
	end
	if re:GetHandler():IsType(TYPE_TRAP) then
		c:SetFlagEffectLabel(m,bit.bor(c:GetFlagEffectLabel(m),0x4))
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(m,4))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e3:SetValue(c:GetBaseAttack()*2)
		c:RegisterEffect(e3)
	end
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_EFFECT) and te:GetOwner()~=e:GetOwner()
end
