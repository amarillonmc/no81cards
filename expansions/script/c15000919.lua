local m=15000919
local cm=_G["c"..m]
cm.name="传说未来圣罚 冥夜君狼·极超共鸣"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,4,cm.ovfilter,aux.Stringid(m,0),4,cm.xyzop)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(cm.psplimit)
	c:RegisterEffect(e0)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.discon)
	e1:SetCost(cm.discost)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	--Remove...for a moment
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,15000919)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,15000920)
	e3:SetTarget(cm.rm2tg)
	e3:SetOperation(cm.rm2op)
	c:RegisterEffect(e3)
end
function cm.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_FIEND)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsCode(15000909)
end
function cm.cfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_PENDULUM)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_PZONE,0,1,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.rmfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToRemove(tp) and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_MONSTER)))
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(cm.rmfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,tp)>0 end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),tp,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,tp)
	if g:GetCount()==0 then return end
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=g:GetFirst()
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	e1:SetCondition(cm.retcon)
	e1:SetOperation(cm.retop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	while tc do
		local loc=0
		if tc:IsLocation(LOCATION_EXTRA) then loc=LOCATION_EXTRA end
		if tc:IsLocation(LOCATION_GRAVE) then loc=LOCATION_GRAVE end
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
		tc:RegisterFlagEffect(15000919,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		tc:RegisterFlagEffect(15000920,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,loc)
		tc=g:GetNext()
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tc=g:GetFirst()
	local ag=Group.CreateGroup()
	while tc do
		if tc:GetFlagEffectLabel(15000919)==e:GetLabel() then
			ag:AddCard(tc)
		end
		tc=g:GetNext()
	end
	return ag:GetCount()~=0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tc=g:GetFirst()
	local ag=Group.CreateGroup()
	while tc do
		if tc:GetFlagEffectLabel(15000919)==e:GetLabel() then
			ag:AddCard(tc)
		end
		tc=g:GetNext()
	end
	local ac=ag:GetFirst()
	while ac do
		if ac:GetFlagEffectLabel(15000920)==LOCATION_EXTRA then
			Duel.SendtoExtraP(ac,tp,REASON_EFFECT+REASON_RETURN)
		end
		if ac:GetFlagEffectLabel(15000920)==LOCATION_GRAVE then
			Duel.SendtoGrave(ac,REASON_EFFECT+REASON_RETURN)
		end
		ac=ag:GetNext()
	end
end
function cm.tffilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x6f3e) and not c:IsForbidden() and c:IsType(TYPE_CONTINUOUS)
end
function cm.rm2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.rm2op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end