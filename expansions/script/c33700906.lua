--回家吧。 ～旅途的终结～
function c33700906.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c33700906.condition)
	e1:SetTarget(c33700906.target)
	e1:SetOperation(c33700906.operation)
	c:RegisterEffect(e1)	
end
function c33700906.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c33700906.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_GRAVE)
end
function c33700906.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if #g<=0 then return end
	Duel.ConfirmCards(1-tp,g)
	local codetbl={}
	for tc in aux.Next(g) do
		codetbl[#codetbl+1]=tc:GetCode()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(#g)
	e1:SetCondition(c33700906.thcon(codetbl))
	e1:SetOperation(c33700906.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33700906.thcon(codetbl)
	return function(e,tp)
		local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
		for _,code in ipairs(codetbl) do
			if not g:IsExists(Card.IsCode,1,nil,code) then return false end
		end
		return true
	end
end
function c33700906.thop(e,tp)
	local b1=true
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,e:GetLabel(),nil)
	Duel.Hint(HINT_CARD,0,33700906)
	if b1 and (not b2 or not Duel.SelectYesNo(1-tp,aux.Stringid(33700906,0))) then
		Duel.Damage(1-tp,e:GetLabel()*800,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)	
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,e:GetLabel(),e:GetLabel(),nil)
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
