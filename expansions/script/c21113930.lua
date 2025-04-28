--芳青之梦 白纱渐落
function c21113930.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,21113930+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c21113930.cost)
	e1:SetOperation(c21113930.op)
	c:RegisterEffect(e1)
end
function c21113930.t(c)
	return c:IsSetCard(0xc914) and c:IsDiscardable()
end
function c21113930.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c21113930.t,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,c21113930.t,1,1,REASON_COST+REASON_DISCARD,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c21113930.op0)
	Duel.RegisterEffect(e1,tp)
end
function c21113930.w(c)
	return c:IsCode(21113930) and c:IsAbleToHand()
end
function c21113930.op0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113930)==0 and (Duel.IsExistingMatchingCard(c21113930.w,tp,1,0,1,nil) or Duel.IsPlayerCanDraw(tp,1)) and Duel.SelectYesNo(tp,aux.Stringid(21113930,0)) then
	local x1,x2=false,false
	if Duel.IsExistingMatchingCard(c21113930.w,tp,1,0,1,nil) then x1=true end
	if Duel.IsPlayerCanDraw(tp,1) then x2=true end
	local op=aux.SelectFromOptions(tp,{x1,aux.Stringid(21113930,1),0},{x2,aux.Stringid(21113930,2),1})
		if op==0 then 
			Duel.Hint(3,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c21113930.w,tp,1,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_RULE)
			Duel.ConfirmCards(1-tp,g)
		elseif op==1 then
			Duel.Draw(tp,1,REASON_RULE)
		end
	end
	Duel.ResetFlagEffect(tp,21113930)
	e:Reset()
end
function c21113930.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113930,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(4,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc914))
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c21113930.disable)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c21113930.disable(e,c)
	return c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0
end