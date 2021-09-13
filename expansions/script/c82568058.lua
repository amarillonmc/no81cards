--AK-方舟骑士的短兵相接
function c82568058.initial_effect(c)
	--SpecialSummon
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_ACTIVATE)
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	e7:SetCondition(c82568058.spcon)
	e7:SetTarget(c82568058.sptg)
	e7:SetOperation(c82568058.spop)
	c:RegisterEffect(e7)
end
function c82568058.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(e:GetHandler():GetControler()) and tc:IsFaceup() and tc:IsSetCard(0x825)
end
function c82568058.spfilter(c,e,tp,at)
	if c:IsLocation(LOCATION_EXTRA) 
	then return c:IsSetCard(0x825) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,at,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	else return c:IsSetCard(0x825) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	end
end
function c82568058.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local at=Duel.GetAttackTarget() 
	if chk==0 then return Duel.GetAttackTarget():IsReleasable()
		and Duel.IsExistingMatchingCard(c82568058.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,e,tp,at) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA+LOCATION_HAND)
	 Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,0,0)
end
function c82568058.spop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget() 
	local atk=at:GetAttack()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82568058.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil,e,tp,at)
	if Duel.Release(at,REASON_EFFECT)~=0 then
	if g:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0  then return false end
	local sp=g:GetFirst() 
	if Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)~=0 then
	Duel.BreakEffect()
	local c=e:GetHandler()
	if  sp:IsFaceup() 
		then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(atk)
		sp:RegisterEffect(e1)
	end
	end
	end
end