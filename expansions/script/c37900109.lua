--Shintaro
function c37900109.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,37900109)
	e1:SetCondition(c37900109.con)
	e1:SetTarget(c37900109.tg)
	e1:SetOperation(c37900109.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c37900109.tg2)
	e2:SetOperation(c37900109.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c37900109.tg3)
	e3:SetTargetRange(4,0)
	e3:SetValue(c37900109.val)
	c:RegisterEffect(e3)
end
function c37900109.q(c)
	return c:IsFaceup() and not c:IsCode(37900109) and c:IsSetCard(0x382)
end
function c37900109.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c37900109.q,tp,4,0,1,nil)
end
function c37900109.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,4)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c37900109.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c37900109.w(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,tp,false) and Duel.GetLocationCount(tp,4)>0 and c:IsSetCard(0x382)
end
function c37900109.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37900109.w,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c37900109.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c37900109.w,e,tp),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c37900109.tg3(e,c)
	return c:IsFaceup() and c:IsSetCard(0x382)
end
function c37900109.val(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end