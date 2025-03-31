--星宫守护者·狮子
function c72412190.initial_effect(c)
	aux.AddCodeList(c,724121200)
		--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72412190,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,72412190)
	e1:SetCondition(c72412190.negcon)
	e1:SetTarget(c72412190.negtg)
	e1:SetOperation(c72412190.negop)
	c:RegisterEffect(e1)
			--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,72412191)
	e2:SetOperation(c72412190.regop)
	c:RegisterEffect(e2)
end
function c72412190.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c72412190.desfilter(c)
	return c:IsSetCard(0x9728) and c:IsAbleToGrave()
end
function c72412190.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72412190.desfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c72412190.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c72412190.desfilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c72412190.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c72412190.thcon)
	e1:SetOperation(c72412190.thop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function c72412190.thfilter(c,tp)
	local res=Duel.IsPlayerAffectedByEffect(tp,9911020) and c:IsSetCard(0x9728) and c:IsType(TYPE_MONSTER)
	local res2=Duel.GetFlagEffect(tp,72421261)<=0 and c:IsCode(72421260)
	return (c:IsCode(72412200) or res or res2) and c:IsAbleToHand()
end
function c72412190.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(c72412190.thfilter,tp,LOCATION_DECK,0,1,nil,tp)
end
function c72412190.thop(e,tp,eg,ep,ev,re,r,rp)
	Effect.Reset(e)
	Duel.Hint(HINT_CARD,0,72412190)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72412190.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():GetCode()==72412160 and not Duel.IsPlayerAffectedByEffect(tp,9911020) then
		   Duel.RegisterFlagEffect(tp,72421261,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
