--标枪
function c25800011.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25800011,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,25800011)
	e1:SetTarget(c25800011.thtg1)
	e1:SetOperation(c25800011.thop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,25800001)
	e3:SetCondition(c25800011.thcon)
	e3:SetTarget(c25800011.thtg)
	e3:SetOperation(c25800011.thop)
	c:RegisterEffect(e3)
	if not c25800011.global_check then
		c25800011.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c25800011.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c25800011.filter(c)
	return c:IsCode(25800101) and c:IsAbleToHand()
end
function c25800011.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25800011.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c25800011.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c25800011.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
----
function c25800011.checkfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function c25800011.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c25800011.checkfilter,1,nil,0) then Duel.RegisterFlagEffect(0,25800011,RESET_PHASE+PHASE_END,0,1) end
	if eg:IsExists(c25800011.checkfilter,1,nil,1) then Duel.RegisterFlagEffect(1,25800011,RESET_PHASE+PHASE_END,0,1) end
end
function c25800011.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,25800011)>0
end
function c25800011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c25800011.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end