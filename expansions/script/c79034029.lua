--Hollow Knight-寻神者
function c79034029.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()   
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79034029,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c79034029.cpcost)
	e1:SetTarget(c79034029.cptg)
	e1:SetOperation(c79034029.cpop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c79034029.twocon)
	c:RegisterEffect(e4)
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c79034029.desop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c79034029.twocon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,79034021)
end
function c79034029.fil(c)
	return c:IsLinkBelow(Duel.GetFieldGroupCount(tp,LOCATION_HAND,0))
end
function c79034029.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c79034029.fil,tp,LOCATION_EXTRA,0,1,1,e:GetHandler()) end
	local tc=Duel.SelectMatchingCard(tp,c79034029.fil,tp,LOCATION_EXTRA,0,1,1,e:GetHandler()):GetFirst()
	e:SetLabelObject(tc)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,tc:GetLink(),tc:GetLink(),e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c79034029.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetTargetCard(g)
end
function c79034029.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local x=e:GetLabelObject()
	local code=x:GetOriginalCodeRule()
		tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
		e:SetLabelObject(tc)
		tc:RegisterFlagEffect(79034029,RESET_EVENT+RESETS_STANDARD,0,0)
		c:RegisterFlagEffect(79034029,RESET_EVENT+0x1020000,0,0)
end
function c79034029.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
	if tc and tc:GetFlagEffect(79034029)~=0 and e:GetHandler():GetFlagEffect(79034029)~=0 then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end



