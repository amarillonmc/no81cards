--百千抉择的魔术师 夏洛特
function c67201111.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201111,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	--e1:SetCountLimit(1,67201111)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c67201111.descon)
	e1:SetCost(c67201111.descost)
	e1:SetTarget(c67201111.destg)
	e1:SetOperation(c67201111.desop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201111,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_LEAVE_GRAVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	--e2:SetCountLimit(1,67201112)
	e2:SetCondition(c67201111.opcon)
	e2:SetTarget(c67201111.optg)
	e2:SetOperation(c67201111.opop)
	c:RegisterEffect(e2)  
end
function c67201111.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DRAW)
end
function c67201111.desfilter(c,tp)
	return c:IsAbleToGraveAsCost()
end
function c67201111.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c67201111.desfilter,tp,LOCATION_HAND,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67201111.desfilter,tp,LOCATION_HAND,0,1,1,c,tp)+c
	Duel.SendtoGrave(g,REASON_COST)
end
function c67201111.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c67201111.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--
function c67201111.opcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c67201111.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,67201111)==0
	local b2=Duel.GetFlagEffect(tp,67201112)==0
	if chk==0 then return b1 or b2 end
end
function c67201111.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,67201111)==0
	local b2=Duel.GetFlagEffect(tp,67201112)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67201111,1),aux.Stringid(67201111,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67201111,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(67201111,2))+1
	else return end
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,67201111,RESET_PHASE+PHASE_END,0,1)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetCondition(c67201111.thcon2)
		e1:SetOperation(c67201111.thop2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,67201112,RESET_PHASE+PHASE_END,0,1)
	end
end
function c67201111.thfilter(c)
	return c:IsSetCard(0x3670) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c67201111.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c67201111.thfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c67201111.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67201111.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
