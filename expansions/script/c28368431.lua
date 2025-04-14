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
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
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
	for tc in aux.Next(sg) do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),28368431,RESET_PHASE+PHASE_END,0,1)
	end
end
function c28368431.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)<=3000 or Duel.CheckLPCost(tp,2000) end
	if Duel.GetLP(tp)>3000 then Duel.PayLPCost(tp,2000) end
end
function c28368431.activate(e,tp,eg,ep,ev,re,r,rp)
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
	local g=Duel.GetMatchingGroup(c28368431.thfilter,tp,LOCATION_DECK,0,nil)
	if tct>0 and Duel.IsExistingMatchingCard(c28368431.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28368431,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:SelectSubGroup(tp,aux.dncheck,false,1,tct)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c28368431.confilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetReasonPlayer()==1-tp and not c:IsReason(REASON_RULE)
end
function c28368431.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=3000 and eg:IsExists(c28368431.confilter,1,nil,tp)
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
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	--e1:SetCondition(c28368431.damcon)
	e1:SetValue(c28368431.damval)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
end
function c28368431.damcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,28368431)==0
end
function c28368431.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 then
		e:Reset()
		return 0
	end
	return val
end
