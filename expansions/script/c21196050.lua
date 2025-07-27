--皇庭学院的院长
local m=21196050
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
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.mat1,nil,nil,cm.mat2,1,99)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
function cm.mat1(c,syncard)
	return c:IsTuner(syncard) and c:IsRace(RACE_SPELLCASTER)
end
function cm.mat2(c)
	return c:IsSetCard(0x5919)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function cm.q(c,tp)
	return c:IsCode(21196000) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and c:IsFaceupEx()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return in_count[tp] < 8 and Duel.IsExistingMatchingCard(cm.q,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.q,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		if Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) then
		in_count.add(tp,1)
		end
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and re:IsActiveType(TYPE_SPELL) and (re:GetHandler():IsType(TYPE_QUICKPLAY) or re:GetHandler():GetType()==TYPE_SPELL)
end
function cm.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_SPELL)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetChainLimit(cm.chainlm)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.w(c)
	return (c:IsType(TYPE_QUICKPLAY) or c:GetType()==TYPE_SPELL) and c:IsSSetable()
end
function cm.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetCardData(CARDDATA_TYPE,TYPE_SPELL)
	e:Reset()
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)>0 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(c)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.retop)
	Duel.RegisterEffect(e1,tp)
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.SendtoGrave(re:GetHandler(),REASON_EFFECT)>0 and re:GetHandler():IsLocation(0x10) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.w),tp,0,0x10,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(3,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.w),tp,0,0x10,1,1,nil):GetFirst()
			if tc and Duel.SSet(tp,tc)>0 then
				if tc:GetType()==TYPE_SPELL then
				tc:SetCardData(CARDDATA_TYPE,TYPE_SPELL+TYPE_QUICKPLAY)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EVENT_LEAVE_FIELD_P)
				e2:SetOperation(cm.leaveop)
				tc:RegisterEffect(e2,true)
				end
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_CANNOT_DISABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			end
		end
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return in_count[tp] < 8 end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	in_count.add(tp,2)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(21196000)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end