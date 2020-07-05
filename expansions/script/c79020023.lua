--整合运动·空降兵
function c79020023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1,79020023+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c79020023.condition)
	e1:SetTarget(c79020023.target)
	e1:SetOperation(c79020023.activate)
	c:RegisterEffect(e1)
end
function c79020023.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>=4000
end
function c79020023.fil(c)
	return c:IsSetCard(0x3908)
end
function c79020023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79020023.fil,tp,LOCATION_EXTRA,0,1,nil) and e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c79020023.fil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c79020023.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
end