--机空援护 导流屏障
function c40009041.initial_effect(c)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)   
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009041,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c40009041.thcon)
	e2:SetTarget(c40009041.thtg)
	e2:SetOperation(c40009041.thop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf22))
	e3:SetValue(c40009041.atkval)
	c:RegisterEffect(e3)
end
function c40009041.cfilter(c,tp)
	return c:IsSetCard(0xf22) and c:IsControler(tp) and c:IsType(TYPE_QUICKPLAY)
end
function c40009041.atkval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_GRAVE,LOCATION_GRAVE)*100
end
function c40009041.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and eg:IsExists(c40009041.cfilter,1,nil,tp)
end
function c40009041.thfilter(c,tp)
	return c:IsSetCard(0xf22) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_SZONE,0,1,nil,c:GetCode())
end
function c40009041.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009041.thfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetFlagEffect(tp,40009041)==0 end
	Duel.RegisterFlagEffect(tp,40009041,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40009041.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40009041.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
		local att=g:GetCode()
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD)
			e0:SetCode(EFFECT_CANNOT_TO_HAND)
			e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e0:SetTargetRange(1,0)
			e0:SetTarget(c40009041.thlimit)
			e0:SetLabel(att)
			e0:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e0,tp)
	end
end
function c40009041.thlimit(e,c,tp,re)
	return c:IsCode(e:GetLabel()) and re and re:GetHandler():IsCode(40009041)
end
