--fate·达·芬奇-Rider
function c9950178.initial_effect(c)
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(9950178,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9950178)
	e1:SetCost(c9950178.thcost)
	e1:SetTarget(c9950178.thtg)
	e1:SetOperation(c9950178.thop)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950178,2))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9950178.sumcon)
	e2:SetTarget(c9950178.sumtg)
	e2:SetOperation(c9950178.sumop)
	c:RegisterEffect(e2)
	--decrease tribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c9950178.decop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950178.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950178.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950178,0))
end
function c9950178.rmfilter(c,tp)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(c9950178.filter,tp,LOCATION_GRAVE,0,1,c)
end
function c9950178.filter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9950178.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950178.rmfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950178.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9950178.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9950178.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9950178.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9950178.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:RegisterFlagEffect(9950178,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c9950178.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(9950178)~=0
end
function c9950178.sumfilter(c)
	return c:IsSetCard(0xba5) and c:IsSummonable(true,nil)
end
function c9950178.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950178.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9950178.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9950178.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c9950178.decop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,78358522)~=0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DECREASE_TRIBUTE)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e1:SetTarget(c9950178.rfilter)
	e1:SetCondition(c9950178.econ)
	e1:SetCountLimit(1)
	e1:SetValue(0x1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(0x10000000+78358523)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
	Duel.RegisterFlagEffect(tp,78358522,RESET_PHASE+PHASE_END,0,1)
end
function c9950178.econ(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),78358523)~=0
end
function c9950178.rfilter(e,c)
	return c:IsSetCard(0xba5)
end
	

