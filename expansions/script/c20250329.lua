--禁钉圣迹超限机
function c20250329.initial_effect(c) 
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),aux.Tuner(nil),nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1,99)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)	
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,te)
	return te:GetOwner()~=e:GetOwner() end)
	e1:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x154a)==0 end)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20250329,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c20250329.addcc)
	e1:SetTarget(c20250329.addct)
	e1:SetOperation(c20250329.addc)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c20250329.discon) 
	e2:SetOperation(c20250329.disop)
	c:RegisterEffect(e2) 
	--
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(0)
	e2:SetCondition(c20250329.dckcon) 
	e2:SetOperation(c20250329.dckop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+20250029) 
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c20250329.descon)
	e3:SetTarget(c20250329.destg)
	e3:SetOperation(c20250329.desop)
	c:RegisterEffect(e3)
end
c20250329.material_type=TYPE_SYNCHRO 
function c20250329.addcc(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c20250329.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x154a)
end
function c20250329.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x154a,3)
	end
end
function c20250329.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsCanRemoveCounter(1-tp,0,1,0x154a,1,REASON_EFFECT)
end 
function c20250329.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.IsCanRemoveCounter(1-tp,0,1,0x154a,1,REASON_EFFECT) and Duel.SelectEffectYesNo(1-tp,c,aux.Stringid(20250329,0)) then 
		Duel.RemoveCounter(1-tp,0,1,0x154a,1,REASON_EFFECT) 
	else 
		Duel.NegateEffect(ev)
	end 
end
function c20250329.dckcon(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetHandler():GetFlagEffect(20250329)
	return x~=e:GetHandler():GetCounter(0x154a)
end 
function c20250329.dckop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	c:ResetFlagEffect(20250329)
		local ct=c:GetCounter(0x154a)
		for i=1,ct do
		c:RegisterFlagEffect(20250329,RESET_EVENT+0x1fe0000,0,1)
	end
		if e:GetHandler():GetCounter(0x154a)==0 then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+20250329,e,0,0,tp,0) 
	end
end
function c20250329.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x154a)==0 
end
function c20250329.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end 
function c20250329.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then 
		Duel.Destroy(g,REASON_EFFECT) 
	end 
end 