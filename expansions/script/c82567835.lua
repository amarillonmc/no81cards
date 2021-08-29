--方舟騎士·异刃剑羽 柏喙
function c82567835.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE + CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,82567835)
	e1:SetCost(c82567835.atkcost)
	e1:SetTarget(c82567835.atkarget)
	e1:SetOperation(c82567835.atkactivate)
	c:RegisterEffect(e1)
	--tohand1
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(82567835,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,82567935+EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c82567835.thtg)
	e2:SetOperation(c82567835.thop)
	c:RegisterEffect(e2)
	--tohand2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82567835,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCountLimit(1,82567935+EFFECT_COUNT_CODE_SINGLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCondition(c82567835.thcon2)
	e5:SetTarget(c82567835.thtg)
	e5:SetOperation(c82567835.thop)
	c:RegisterEffect(e5)
end
function c82567835.cfilter(c,g)
	return c:GetCounter(0x5825)>0 
end
function c82567835.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567835.cfilter,tp,LOCATION_SZONE,0, 1,nil) end
	local g=Duel.SelectMatchingCard(tp,c82567835.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoHand(g,tp,1)
end
function c82567835.posfilter(c,g)
	return c:IsFaceup()
end
function c82567835.atkarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567835.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c82567835.posfilter,tp,0,LOCATION_MZONE,nil)
	local gn=g:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,gn,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500*gn)
end
function c82567835.atkactivate(e,tp,eg,ep,ev,re,r,rp,g,tg,sg)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c82567835.posfilter,tp,0,LOCATION_MZONE,nil)
	local gn=g:GetCount()
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local value=500*gn
	Duel.Damage(1-tp,value,REASON_EFFECT)
end
function c82567835.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c82567835.thfilter(c)
	return  c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsFaceup()
	end
function c82567835.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567835.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c82567835.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82567835.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end