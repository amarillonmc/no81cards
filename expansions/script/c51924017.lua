--暗月小丑
function c51924017.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,51924017)
	e1:SetTarget(c51924017.thtg)
	e1:SetOperation(c51924017.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--pendulum summon reg
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c51924017.regcon)
	e3:SetOperation(c51924017.regop)
	c:RegisterEffect(e3)
	--kksk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_MAIN_END)
	e4:SetCountLimit(1,51924018)
	e4:SetCondition(c51924017.chkcon)
	e4:SetTarget(c51924017.chktg)
	e4:SetOperation(c51924017.chkop)
	c:RegisterEffect(e4)
end
function c51924017.thfilter(c)
	return c:IsSetCard(0x3256) and not c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c51924017.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51924017.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c51924017.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c51924017.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c51924017.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c51924017.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_MAIN1 then
		e:GetHandler():RegisterFlagEffect(51924017,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1,0,1)
	elseif Duel.GetCurrentPhase()==PHASE_MAIN2 then
		e:GetHandler():RegisterFlagEffect(51924017,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN2,0,1)
	end
end
function c51924017.chkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(51924017)~=0
end
function c51924017.chkfilter(c)
	return c:IsLocation(LOCATION_HAND) or c:IsFacedown()
end
function c51924017.chktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 or Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c51924017.chkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	if g:GetCount()>0 then
		local cg=g:Filter(c51924017.chkfilter,nil)
		Duel.ConfirmCards(tp,cg)
		Duel.ShuffleHand(1-tp)
	end
end
