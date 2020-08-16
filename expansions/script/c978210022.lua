--多元闪刀姬-鸦羽∞
--闪刀姬·鸦羽
function c978210022.initial_effect(c)
	 c:SetSPSummonOnce(978210022)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c978210022.matfilter,1,1)
--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2115))
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCondition(c978210022.condition)
	c:RegisterEffect(e1)
 --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(978210022,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c978210022.thcon)
	e2:SetTarget(c978210022.thtg)
	e2:SetOperation(c978210022.thop)
	c:RegisterEffect(e2)
 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c978210022.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
-----
local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(978210022,1))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetHintTiming(0,TIMING_END_PHASE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCost(c978210022.spcost1)
	e10:SetTarget(c978210022.sptg1)
	e10:SetOperation(c978210022.spop1)
	c:RegisterEffect(e10)
end
function c978210022.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(978210022,0))
end
function c978210022.matfilter(c)
	return c:IsLinkSetCard(0x2115) and not c:IsLinkAttribute(ATTRIBUTE_DARK)
end
function c978210022.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()>4
end
function c978210022.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) 
end
function c978210022.thfilter(c)
	return c:IsSetCard(0x2115) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c978210022.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c978210022.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c978210022.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c978210022.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(978210022,1))
end
-----
function c978210022.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c978210022.spfilter1(c,e,tp,ec)
	return c:IsSetCard(0x2115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c978210022.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c978210022.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c978210022.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c978210022.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
	end
end