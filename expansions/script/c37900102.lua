--Hibiya
function c37900102.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,37900102)
	e1:SetCondition(c37900102.con)
	e1:SetTarget(c37900102.tg)
	e1:SetOperation(c37900102.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c37900102.tg2)
	e2:SetOperation(c37900102.op2)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(4)
	e4:SetTarget(c37900102.tg4)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c37900102.con4)
	e4:SetValue(1000)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)	
end
function c37900102.q(c)
	return c:IsFaceup() and not c:IsCode(37900102) and c:IsSetCard(0x382)
end
function c37900102.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c37900102.q,tp,4,0,1,nil)
end
function c37900102.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,4)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c37900102.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c37900102.w(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,tp,false) and Duel.GetLocationCount(1-tp,4)>0 and c:IsSetCard(0x382)
end
function c37900102.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37900102.w,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c37900102.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c37900102.w,e,tp),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c37900102.e(c)
	return c:IsFaceup() and c:IsSetCard(0x382)
end
function c37900102.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c37900102.e,tp,0,4,1,nil)
end
function c37900102.tg4(e,c)
	return c:IsFaceup() and c:IsSetCard(0x382)
end