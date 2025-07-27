--皇庭学院的秘术-转移魔法
local m=21196045
local cm=_G["c"..m]
function cm.initial_effect(c)
	if not imperial_court then
		imperial_court=true
		Duel.LoadScript("c21196001.lua")
		in_count.card = c
		local ce1=Effect.CreateEffect(c)
		ce1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce1:SetCode(EVENT_PHASE+PHASE_END)
		ce1:SetCountLimit(1)
		ce1:SetOperation(function(e)
			for tp = 0,1 do
				if not Duel.IsPlayerAffectedByEffect(tp,21196000) then
					in_count.reset(tp)
				end
			end
		end)
		Duel.RegisterEffect(ce1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
cm.settype_amp=true
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return in_count[tp] >= 3
end
function cm.q(c)
	return c:IsFaceup() and c:IsSetCard(0x5919) and c:IsAbleToRemove()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.q,tp,4,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if in_count[tp] == 0 then return end
	in_count.add(tp,-1)
	local c=e:GetHandler()
	Duel.Hint(3,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.q,tp,4,0,1,1,nil)
	if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local rc=g:GetFirst()
		if rc:IsType(TYPE_TOKEN) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(rc)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then 
	Duel.BreakEffect()
	c:CancelToGrave()
	Duel.ChangePosition(c,POS_FACEDOWN)
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_CANNOT_DISABLE)
	e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	end
end
function cm.w(c)
	local tp=c:GetControler()
	return c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.w,tp,4,0,1,nil) and Duel.IsExistingMatchingCard(cm.w,tp,0,4,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,2,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if in_count[tp] < 2 then return end
	in_count.add(tp,-2)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(cm.w,tp,4,0,1,nil) or not Duel.IsExistingMatchingCard(cm.w,tp,0,4,1,nil)
	then return end
	Duel.Hint(3,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectMatchingCard(tp,cm.w,tp,4,0,1,1,nil)
	Duel.HintSelection(g1)
	Duel.Hint(3,1-tp,HINTMSG_CONTROL)
	local g2=Duel.SelectMatchingCard(tp,cm.w,tp,0,4,1,1,nil)
	Duel.HintSelection(g2)
	local c1=g1:GetFirst()
	local c2=g2:GetFirst()
	if Duel.SwapControl(c1,c2,0,0) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_PHASE+PHASE_END)
		c1:RegisterEffect(e1)
		local e2=e1:Clone()
		c2:RegisterEffect(e2)
	end
end