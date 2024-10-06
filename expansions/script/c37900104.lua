--Kido
function c37900104.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,37900104)
	e1:SetCondition(c37900104.con)
	e1:SetTarget(c37900104.tg)
	e1:SetOperation(c37900104.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c37900104.cost2)
	e2:SetTarget(c37900104.tg2)
	e2:SetOperation(c37900104.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(4,0)
	e3:SetTarget(c37900104.tg3)
	e3:SetCondition(c37900104.con3)
	e3:SetValue(c37900104.val)
	c:RegisterEffect(e3)
end
function c37900104.q(c)
	return c:IsFaceup() and not c:IsCode(37900104) and c:IsSetCard(0x382)
end
function c37900104.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c37900104.q,tp,4,0,1,nil)
end
function c37900104.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,4)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c37900104.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c37900104.w(c)
	return c:IsAbleToGraveAsCost() and c:IsCode(37900100)
end
function c37900104.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37900104.w,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c37900104.w,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c37900104.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,0,1)
end
function c37900104.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c37900104.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c37900104.tg3(e,c)
	return c:IsFaceup() and c:IsSetCard(0x382)
end
function c37900104.val(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end