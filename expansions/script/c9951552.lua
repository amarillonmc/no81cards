--光之国·乔尼亚斯
function c9951552.initial_effect(c)
  --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951552,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9951552)
	e1:SetCondition(c9951552.spcon1)
	e1:SetTarget(c9951552.sptg1)
	e1:SetOperation(c9951552.spop1)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9951552.atkcon)
	e2:SetValue(c9951552.atkval)
	c:RegisterEffect(e2)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951552.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951552.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951552,0))
end
function c9951552.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9bd1)
end
function c9951552.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9951552.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9951552.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9951552.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c9951552.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	if ph~=PHASE_DAMAGE and ph~=PHASE_DAMAGE_CAL then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return e:GetHandler()==a and d and d:GetSummonLocation()==LOCATION_EXTRA
end
function c9951552.atkval(e,c)
	return e:GetHandler():GetBaseAttack()
end