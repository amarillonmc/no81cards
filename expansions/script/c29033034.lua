--深海猎人共战
function c29033034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,29033034+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c29033034.target)
	e1:SetOperation(c29033034.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c29033034.handcon)
	c:RegisterEffect(e2)
	--"Arknights-Specter the Unchained":ACTIVATE FROM GRAVE
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,29063234)
	e3:SetCost(c29033034.cost)
	e3:SetCondition(c29033034.condition)
	e3:SetTarget(c29033034.target)
	e3:SetOperation(c29033034.activate2(c29033034.activate))
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
end
function c29033034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
end
function c29033034.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,29063234) and e:GetLabelObject():CheckCountLimit(tp)
end
function c29033034.activate2(op)
	return function(e,tp,eg,ep,ev,re,r,rp)
				op(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				c:CancelToGrave()
				Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
			end
end
function c29033034.nefilter(c)
	return c:IsFaceup() and not (c:IsType(TYPE_NORMAL) or c:IsType(TYPE_TOKEN))
end
function c29033034.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FISH) and c:IsSetCard(0x87af) and c:IsType(TYPE_MONSTER)
end
function c29033034.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c29033034.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c29033034.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c29033034.filter,tp,LOCATION_MZONE,0,nil)
	local g1=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 and g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local sg=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,g:GetCount(),nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		while tc do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
				if g:GetClassCount(Card.GetCode)>=3 then
				local c=e:GetHandler()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetTargetRange(0,LOCATION_MZONE)
				e1:SetTarget(c29033034.distg)
				e1:SetLabelObject(tc)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_CHAIN_SOLVING)
				e2:SetCondition(c29033034.discon)
				e2:SetOperation(c29033034.disop)
				e2:SetLabelObject(tc)
				e2:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e2,tp)
				end
			Duel.AdjustInstantly(tc)
			tc=sg:GetNext()
		end
	end
end
function c29033034.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c29033034.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c29033034.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c29033034.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c29033034.handcon(e)
	return Duel.IsExistingMatchingCard(c29033034.cfilter,0,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c29033034.cfilter,1,LOCATION_MZONE,0,1,nil)
end