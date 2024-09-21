--监察者异虫
local cm,m=GetID()
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--overseer
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(cm.descost)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--cannot trigger
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_SZONE)
	e3:SetTarget(cm.distg)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_SZONE)
	e4:SetTarget(cm.distg2)
	c:RegisterEffect(e4)
	--disable effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(cm.disop)
	c:RegisterEffect(e5)
	--disable trap monster
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetTarget(cm.distg2)
	c:RegisterEffect(e6)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function cm.desfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if #g==0 then return end
	local sc=g:RandomSelect(1-tp,1):GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	sc:RegisterEffect(e1,true)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.ConfirmCards(tp,sc)
	--hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabelObject(sc)
	e2:SetCondition(cm.condition2)
	e2:SetOperation(cm.operation2)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	return eg:IsContains(sc) and sc:IsPreviousLocation(LOCATION_HAND) and not sc:IsLocation(LOCATION_HAND) and sc:GetPreviousPosition()&POS_FACEUP>0
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:Reset()
	Duel.Hint(HINT_CARD,0,m)
	local dr=Duel.IsPlayerCanDraw(tp,1)
	local sp=c:GetFlagEffect(m)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if not dr and not sp then return end
	local op=aux.SelectFromOptions(tp,{dr,aux.Stringid(m,5)},{sp,aux.Stringid(m,6)})
	if op==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif op==2 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=c:GetLocation()
	if loc&LOCATION_ONFIELD>0 then loc=LOCATION_ONFIELD end
	return eg:IsExists(cm.spfilter,1,nil,loc) and not eg:IsContains(c)
end
function cm.spfilter(c,loc)
	return c:IsLocation(loc) and not c:IsPreviousLocation(loc)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=c:GetLocation()
	if loc&LOCATION_ONFIELD>0 then loc=LOCATION_ONFIELD end
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		--overseer+
		local e1=Effect.CreateEffect(c)
		local sid=0
		if loc==LOCATION_HAND then sid=1 elseif loc==LOCATION_ONFIELD then sid=2 elseif loc==LOCATION_GRAVE then sid=3 end
		e1:SetDescription(aux.Stringid(m,sid))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_MOVE)
		e1:SetRange(LOCATION_PZONE)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
		e1:SetLabel(loc)
		e1:SetCondition(cm.descon)
		e1:SetCost(cm.descost)
		e1:SetTarget(cm.destg)
		e1:SetOperation(cm.desop)
		c:RegisterEffect(e1)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local loc=e:GetLabel()
	return eg:IsExists(cm.spfilter2,1,nil,loc)
end
function cm.spfilter2(c,loc)
	return not c:IsLocation(loc) and c:IsPreviousLocation(loc)
end
function cm.distg(e,c)
	return c:IsFacedown()
end
function cm.distg2(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsStatus(STATUS_EFFECT_ENABLED)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.NegateEffect(ev)
	end
end