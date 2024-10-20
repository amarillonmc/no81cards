--万阵破
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60010261)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e8)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.bsfil1(c)
	return c:IsCode(60010263) and c:IsFaceup()
end
function cm.bsfil2(c)
	return c:IsCode(60010264) and c:IsFaceup()
end
function cm.afil(c)
	return c:IsCode(60010261) and c:IsFaceup()
end
function cm.handcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() and Duel.IsExistingMatchingCard(cm.afil,tp,LOCATION_MZONE,0,1,nil)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return  (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(cm.aclimit)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local t=0
		if Duel.IsExistingMatchingCard(cm.bsfil1,tp,LOCATION_SZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,cm.bsfil1,tp,LOCATION_SZONE,0,1,1,nil)
			if dg and Duel.Destroy(dg,REASON_EFFECT)~=0 then
				t=t+1
				Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
			end
		end
		if Duel.IsExistingMatchingCard(cm.bsfil2,tp,LOCATION_SZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,cm.bsfil2,tp,LOCATION_SZONE,0,1,1,nil)
			if dg and Duel.Destroy(dg,REASON_EFFECT)~=0 then
				t=t+1
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCategory(CATEGORY_NEGATE)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_CHAINING)
				e1:SetLabel(Duel.GetCurrentChain())
				e1:SetOperation(cm.op)
				Duel.RegisterEffect(e1,tp)
			end
		end
		if t~=0 then Duel.Draw(tp,1,REASON_EFFECT) end
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==e:GetLabel()-1 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.NegateEffect(ev)
	end
end
function cm.aclimit(e,re,tp)
	local c=re:GetHandler()
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end