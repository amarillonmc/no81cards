--Hollow Knight-空洞骑士雕像
function c79034022.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79034022,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c79034022.spcon)
	e1:SetTarget(c79034022.sptg)
	e1:SetOperation(c79034022.spop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79034022,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c79034022.sptg1)
	e2:SetOperation(c79034022.spop1)
	c:RegisterEffect(e2)
end
function c79034022.thfilter(c,e,tp)
	return c:IsSetCard(0xca9) and c:IsPreviousLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER)
end
function c79034022.thfilter2(c,e,tp)
	return c:IsSetCard(0xca9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79034022.thfilter3(c,e,tp)
	return c:IsSetCard(0xca9) and c:IsLinkAbove(2)
end
function c79034022.cfilter(c)
	return c:GetSequence()<5
end
function c79034022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c79034022.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c79034022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c79034022.thfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) and eg:IsExists(c79034022.thfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79034022.thfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,0)
end
function c79034022.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c79034022.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,79034022,0xca9,0,0,2600,1,RACE_INSECT,ATTRIBUTE_DARK) and Duel.IsExistingMatchingCard(c79034022.thfilter3,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79034022.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,79034022,0xca9,0,0,2600,1,RACE_INSECT,ATTRIBUTE_DARK) then
	c:AddMonsterAttribute(TYPE_NORMAL)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	--indes
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetReset(RESET_EVENT+RESETS_STANDARD)
	e10:SetValue(1)
	c:RegisterEffect(e10)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
end
end







