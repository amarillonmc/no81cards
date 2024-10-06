--捕食植物 紫草叶蝗虫
function c21111560.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21111560)
	e1:SetCondition(c21111560.con)
	e1:SetTarget(c21111560.tg)
	e1:SetOperation(c21111560.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21111561)
	e2:SetTarget(c21111560.tg2)
	e2:SetOperation(c21111560.op2)
	c:RegisterEffect(e2)	
end
function c21111560.c(c)
	return c:IsFaceup() and c:GetCounter(0x1041)>0
end
function c21111560.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21111560.c,tp,0,LOCATION_MZONE,1,nil)
end
function c21111560.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c21111560.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c21111560.q(c,sc)
	local atk=sc:GetAttack()
	return c:IsFaceup() and c:GetAttack()<atk
end
function c21111560.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c21111560.q,tp,0,LOCATION_MZONE,1,nil,c) end
	Duel.Hint(3,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c21111560.q,tp,0,LOCATION_MZONE,1,1,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21111560.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.Destroy(tc,REASON_EFFECT)
	end
end