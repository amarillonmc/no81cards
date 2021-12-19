--饮食艺术·奶油点心
function c1184081.initial_effect(c)
--
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1184081,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,1184081)
	e2:SetCost(c1184081.cost2)
	e2:SetOperation(c1184081.op2)
	c:RegisterEffect(e2)
--
end
--
function c1184081.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c1184081.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2_1:SetCode(EVENT_TO_GRAVE)
	e2_1:SetCondition(c1184081.con2_1)
	e2_1:SetOperation(c1184081.op2_1)
	e2_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2_1,tp)
	local e2_2=Effect.CreateEffect(c)
	e2_2:SetDescription(aux.Stringid(1184081,1))
	e2_2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2_2:SetCode(EVENT_CHAIN_SOLVED)
	e2_2:SetCondition(c1184081.con2_2)
	e2_2:SetOperation(c1184081.op2_2)
	e2_2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2_2,tp)
end
function c1184081.cfilter2_1(c)
	return c:IsSetCard(0x3e12) and c:IsReason(REASON_EFFECT+REASON_COST)
end
function c1184081.con2_1(e,tp,eg,ep,ev,re,r,rp)
	return rp==Duel.GetTurnPlayer()
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
		and eg:IsExists(c1184081.cfilter2_1,1,nil)
end
function c1184081.op2_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,1184081,RESET_CHAIN,0,1)
end
function c1184081.con2_2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,1184081)>0
end
function c1184081.op2_2(e,tp,eg,ep,ev,re,r,rp)
	local al=Duel.GetFlagEffect(tp,1184081)
	local num=Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.ResetFlagEffect(tp,1184081)
	local ct=math.min(al,num)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,ct,ct,nil)
		if sg:GetCount()>0 then
			Duel.Hint(HINT_CARD,tp,1184081)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end
--