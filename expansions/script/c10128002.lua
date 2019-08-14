--奇妙物语 海葵宝宝
function c10128002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10128002,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c10128002.target)
	e1:SetOperation(c10128002.activate)
	c:RegisterEffect(e1)	
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10128002,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c10128002.spcon)
	e2:SetTarget(c10128002.sptg)
	e2:SetOperation(c10128002.spop)
	c:RegisterEffect(e2)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3) 
end
function c10128002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP+TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c10128002.spfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6336) and c:GetSequence()<5 and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x6336,0x21,0,0,1,RACE_AQUA,ATTRIBUTE_WATER)
end
function c10128002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and c10128002.spfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10128002.spfilter,tp,LOCATION_SZONE,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10128002.spfilter,tp,LOCATION_SZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_SZONE)
end
function c10128002.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),0x6336,0x21,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) then return end
	tc:AddMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_WATER,RACE_AQUA,1,0,0)
	Duel.SpecialSummonStep(tc,1,tp,tp,true,false,POS_FACEUP)
	tc:AddMonsterAttributeComplete()
	Duel.SpecialSummonComplete()
end
function c10128002.thfilter(c)
	return c:IsSetCard(0x6336) and c:IsAbleToHand() and not c:IsCode(10128002)
end
function c10128002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_GRAVE)
end
function c10128002.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c10128002.thfilter,tp,LOCATION_GRAVE,0,nil)
	if not Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) or tg:GetCount()<=0 or not Duel.SelectYesNo(tp,aux.Stringid(10128002,1)) then return end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
	tg=Duel.GetMatchingGroup(c10128002.thfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=tg:Select(tp,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end