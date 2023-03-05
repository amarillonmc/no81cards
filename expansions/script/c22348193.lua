--遥 远 之 民 不 朽 的 遗 骸
local m=22348193
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	--getxyz sucai
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348193,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,22348193)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c22348193.cost)
	e1:SetCondition(c22348193.spcon1)
	e1:SetOperation(c22348193.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c22348193.spcon2)
	c:RegisterEffect(e2)
	
end
function c22348193.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22348193.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return aux.MZoneSequence(e:GetHandler():GetSequence())<4
end
function c22348193.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()==4
end
function c22348193.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(c22348193.dpcon1)
	e1:SetTarget(c22348193.dptg1)
	e1:SetOperation(c22348193.dpop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c22348193.dpcon2)
	e2:SetTarget(c22348193.dptg2)
	e2:SetOperation(c22348193.dpop2)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	c:RegisterFlagEffect(22348193,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
end
function c22348193.xyzfilter(c)
	return c:IsCanOverlay()
end
function c22348193.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetOwner()==tp
end
function c22348193.filter2(c)
	return c:GetFlagEffectLabel(22348193)
end
function c22348193.dpcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348193.filter,1,nil,tp) and Duel.IsExistingMatchingCard(c22348193.filter2,tp,LOCATION_MZONE,0,1,nil)
end
function c22348193.dptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348193.xyzfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c22348193.dpop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c22348193.xyzfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local c=e:GetHandler()
	if g:GetCount()>0 then
			Duel.Overlay(c,g)
	end 
end
function c22348193.dpcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348193.filter,1,nil,1-tp) and Duel.IsExistingMatchingCard(c22348193.filter2,tp,LOCATION_MZONE,0,1,nil)
end
function c22348193.dptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348193.xyzfilter,1-tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c22348193.dpop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c22348193.xyzfilter,1-tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local c=e:GetHandler()
	if g:GetCount()>0 then
			Duel.Overlay(c,g)
	end 
end







