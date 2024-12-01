--秘计螺旋 部署
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	--to draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.setfilter(c)
	return c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		local dc=g:GetFirst()
		if Duel.SSet(tp,dc,tp,false)==0 then return end		
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		dc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		dc:RegisterEffect(e2)
	end
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)  
	--to hand
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(s.cscon)
	e1:SetOperation(s.csop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.cscon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and (re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_SPELL)) and rc:GetType()&TYPE_TRAP+TYPE_SPELL>0 and rp==tp and rc:IsSetCard(0x836)
end 
function s.csop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabel(rp)
	e1:SetLabelObject(re)
	e1:SetCondition(s.recon)
	e1:SetOperation(s.reop) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.recon(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local rc=te:GetHandler()
	return rc:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local rc=te:GetHandler()
	rc:CancelToGrave()
	Duel.SendtoHand(rc,tp,REASON_EFFECT)
end