--挽留的古之药 罪蝶镇魂歌
function c28368431.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c28368431.cost)
	e1:SetOperation(c28368431.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28368431.thcon)
	e2:SetTarget(c28368431.thtg)
	e2:SetOperation(c28368431.thop)
	c:RegisterEffect(e2)
	if not c28368431.global_check then
		c28368431.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(c28368431.checkcon)
		ge1:SetOperation(c28368431.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c28368431.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x285)
end
function c28368431.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28368431.ctfilter,1,nil)
end
function c28368431.checkop(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c28368431.ctfilter,nil)
	local tc=sg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),28368431,RESET_PHASE+PHASE_END,0,1)
		tc=sg:GetNext()
	end
end
function c28368431.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckLPCost(tp,2000)
	local b2=Duel.GetLP(tp)<=3000 and Duel.CheckLPCost(tp,500)
	local b3=Duel.IsPlayerAffectedByEffect(tp,28368431)
	if chk==0 then return b1 or b2 end
	if b3 or not b1 or (b2 and Duel.SelectYesNo(tp,aux.Stringid(28368431,0))) then
		Duel.PayLPCost(tp,500)
	else
		Duel.PayLPCost(tp,2000)
	end
end
function c28368431.activate(e,tp,eg,ep,ev,re,r,rp)
	--costchange
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_LPCOST_CHANGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c28368431.costchange)
	Duel.RegisterEffect(e1,tp)
	--code
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(28368431)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(c28368431.condition)
	Duel.RegisterEffect(e2,tp)
	--recover
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetCondition(c28368431.rccon)
	e3:SetOperation(c28368431.rcop)
	Duel.RegisterEffect(e3,tp)
end
function c28368431.costchange(e,re,rp,val)
	if re and re:GetHandler():IsSetCard(0x285) and Duel.GetLP(rp)<=3000 then
		return 0
	else
		return val
	end
end
function c28368431.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(e:GetHandlerPlayer())<=3000
end
function c28368431.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,28368431)>0
end
function c28368431.thfilter(c)
	return c:IsSetCard(0x285) and c:IsAbleToHand()
end
function c28368431.rcop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,28368431)
	local val=Duel.Recover(tp,ct*500,REASON_EFFECT)
	local tct=math.floor(val/1500)
	if tct>0 and Duel.IsExistingMatchingCard(c28368431.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28368431,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c28368431.thfilter,tp,LOCATION_DECK,0,1,tct,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c28368431.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=3000 and ep==tp
end
function c28368431.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c28368431.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
