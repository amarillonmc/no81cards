--天空漫步者-缠斗
function c9910215.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910215)
	e1:SetOperation(c9910215.activate)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910215)
	e2:SetCondition(c9910215.damcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910215.damtg)
	e2:SetOperation(c9910215.damop)
	c:RegisterEffect(e2)
end
function c9910215.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c9910215.operation)
	Duel.RegisterEffect(e1,tp)
end
function c9910215.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()~=2 then return end
	if rp==tp then
		local dg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT)
			and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910215,0)) then
			Duel.Hint(HINT_CARD,0,9910215)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			if Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
	if rp~=tp and Duel.GetFlagEffect(tp,9910215)<3 then
		Duel.Hint(HINT_CARD,0,9910215)
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,9910215,RESET_PHASE+PHASE_END,0,1)
	end
end
function c9910215.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0
end
function c9910215.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400)
end
function c9910215.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(1-tp,400,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910215.thcon)
		e1:SetOperation(c9910215.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910215.thfilter(c)
	return c:IsSetCard(0x955) and c:IsAbleToHand()
end
function c9910215.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c9910215.thfilter),tp,LOCATION_GRAVE,0,1,nil)
end
function c9910215.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910215)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910215.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
