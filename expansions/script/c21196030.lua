--皇庭学院的禁术-极大魔法
local m=21196030
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
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_REMOVE)
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
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return in_count[tp] >= 2 and Duel.GetFieldGroupCount(tp,0,12)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if in_count[tp] < 2 then return end
	in_count.add(tp,-2)
	local c=e:GetHandler()
	Duel.Hint(3,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,12,1,1,nil)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and c:IsCanTurnSet() then 
	Duel.BreakEffect()
	c:CancelToGrave()
	Duel.ChangePosition(c,POS_FACEDOWN)
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86605515,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_CANNOT_DISABLE)
	e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	end
end
function cm.q(c)
	return c:IsAbleToRemove()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.q,tp,0,0x10+12,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if in_count[tp] == 0 then return end
	local x=in_count[tp]
	in_count.reset(tp)
	local g=Duel.GetMatchingGroup(cm.q,tp,0,0x10+12,nil)
	Duel.Hint(3,tp,HINTMSG_REMOVE)
	local rg=g:Select(tp,1,x,nil)
	if #rg>0 then
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end	
end