--芳青之梦 断思染绪
function c21113825.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,21113825+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c21113825.cost)
	e1:SetTarget(c21113825.tg)
	e1:SetOperation(c21113825.op)
	c:RegisterEffect(e1)
end
function c21113825.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c21113825.op0)
	Duel.RegisterEffect(e1,tp)
end
function c21113825.w(c)
	return c:IsCode(21113825) and c:IsAbleToHand()
end
function c21113825.op0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113825)==0 and (Duel.IsExistingMatchingCard(c21113825.w,tp,1,0,1,nil) or Duel.IsPlayerCanDraw(tp,1)) and Duel.SelectYesNo(tp,aux.Stringid(21113825,0)) then
	local x1,x2=false,false
	if Duel.IsExistingMatchingCard(c21113825.w,tp,1,0,1,nil) then x1=true end
	if Duel.IsPlayerCanDraw(tp,1) then x2=true end
	local op=aux.SelectFromOptions(tp,{x1,aux.Stringid(21113825,1),0},{x2,aux.Stringid(21113825,2),1})
		if op==0 then 
			Duel.Hint(3,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c21113825.w,tp,1,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_RULE)
			Duel.ConfirmCards(1-tp,g)
		elseif op==1 then
			Duel.Draw(tp,1,REASON_RULE)
		end
	end
	Duel.ResetFlagEffect(tp,21113825)
	e:Reset()
end
function c21113825.q(c)
	return c:IsSetCard(0xc914) and c:IsAbleToHand() and c:IsType(1)
end
function c21113825.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21113825.q,tp,1,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,1) 
end
function c21113825.op(e,tp,eg,ep,ev,re,r,rp) 
	Duel.RegisterFlagEffect(tp,21113825,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler() 
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21113825.q,tp,1,0,1,1,nil)
	if #g>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g) 
	end
end