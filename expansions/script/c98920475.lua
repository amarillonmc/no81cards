--青色眼睛的召使
function c98920475.initial_effect(c)
--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920475)
	e1:SetCost(c98920475.drcost)
	e1:SetTarget(c98920475.drtg)
	e1:SetOperation(c98920475.drop)
	c:RegisterEffect(e1)
 --tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920475,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98920475)
	e2:SetCondition(c98920475.thcon)
	e2:SetTarget(c98920475.thtg)
	e2:SetOperation(c98920475.thop)
	c:RegisterEffect(e2)
end
function c98920475.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(1) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_TUNER)
end
function c98920475.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and
		Duel.IsExistingMatchingCard(c98920475.cfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920475.cfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98920475.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c98920475.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	if Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) and Duel.GetFlagEffect(tp,98920475)==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(98920475,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,98920475,RESET_PHASE+PHASE_END,0,1)
	end
end
function c98920475.cfilter1(c,tp)
	return c:IsSetCard(0xdd) and c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end 
function c98920475.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c98920475.cfilter1,1,nil,tp)
end
function c98920475.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c98920475.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end