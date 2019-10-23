--重加速场
function c40008595.initial_effect(c)
	--activate
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_ACTIVATE)
	e7:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e7)
	--search
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(40008595,1))
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_FZONE)
	e8:SetCountLimit(1,40008595)
	e8:SetTarget(c40008595.thtg)
	e8:SetOperation(c40008595.thop)
	c:RegisterEffect(e8)
	--act limit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_CHAINING)
	e9:SetRange(LOCATION_FZONE)
	e9:SetOperation(c40008595.chainop)
	c:RegisterEffect(e9)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc016))
	e1:SetRange(LOCATION_FZONE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_DISABLE_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c40008595.sumcon)
	e4:SetOperation(c40008595.sumsuc)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
end   
function c40008595.thfilter(c)
	return c:IsCode(40008593) and c:IsAbleToHand()
end
function c40008595.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008595.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40008595.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c40008595.thfilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c40008595.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0xc016) and (re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL+TYPE_TRAP)) and ep==tp then
		Duel.SetChainLimit(c40008595.chainlm)
	end
end
function c40008595.chainlm(e,rp,tp)
	return tp==rp
end
function c40008595.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc016)
end
function c40008595.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40008595.filter,1,nil,tp)
end
function c40008595.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c40008595.chainlm)
end
