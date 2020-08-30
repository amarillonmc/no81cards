--你是容器，你是空洞骑士
function c79034021.initial_effect(c)
	c:EnableCounterPermit(0xca0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c79034021.ctg)
	e1:SetOperation(c79034021.cop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79034021,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c79034021.cecon)
	e3:SetLabel(5)
	e3:SetTarget(c79034021.thtg)
	e3:SetOperation(c79034021.thop)
	c:RegisterEffect(e3)
	--change effect type
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(79034021)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c79034021.cecon)
	e4:SetLabel(10)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	--cannot disable Summon or SpecialSummon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e5:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xca9))
	e5:SetCondition(c79034021.cecon)
	e5:SetLabel(15)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	Duel.RegisterEffect(e6,tp)
	--SpecialSummon link
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(79034021,1))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_CANNOT_NEGATE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCondition(c79034021.cecon)
	e7:SetLabel(25)
	e7:SetCost(c79034021.spcost1)
	e7:SetTarget(c79034021.sptg1)
	e7:SetOperation(c79034021.spop1)
	c:RegisterEffect(e7)
	--cannot target
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_ONFIELD)
	e9:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e9:SetValue(1)
	e9:SetCondition(c79034021.cecon)
	e9:SetLabel(30)
	c:RegisterEffect(e9)
	--indes
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_ONFIELD)
	e10:SetValue(1)
	e10:SetCondition(c79034021.cecon)
	e10:SetLabel(30)
	c:RegisterEffect(e10)
end
function c79034021.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0xca0,1) and eg:IsExists(Card.IsSetCard,1,nil,0xca9) end
end
function c79034021.cop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xca0,1)
end
function c79034021.cecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0xca0)>=e:GetLabel()
end
function c79034021.thfilter(c,e,tp)
	return c:IsSetCard(0xca9) and c:IsAbleToHand()
end
function c79034021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79034021.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c79034021.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
end
function c79034021.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end
function c79034021.spfilter(c)
	return c:IsSetCard(0xca9) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function c79034021.spfilter2(c,e,tp)
	return c:IsSetCard(0xca9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLinkBelow(3) and c:IsType(TYPE_LINK) 
end
function c79034021.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79034021.spfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and e:GetHandler():IsAbleToGraveAsCost() end
	local g=Duel.SelectMatchingCard(tp,c79034021.spfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c79034021.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c79034021.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79034021.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c79034021.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end








