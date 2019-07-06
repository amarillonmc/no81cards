--方差的妖精 克罗娜
function c33700041.initial_effect(c)
		--pendulum summon
	aux.EnablePendulumAttribute(c)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c33700041.spcon)
	e1:SetTarget(c33700041.sptg)
	e1:SetOperation(c33700041.spop)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLevelBelow,2))
	e2:SetValue(1000)
	c:RegisterEffect(e2)
end
function c33700041.cfilter(c,e,tp)
	return  c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_PENDULUM
		and (not e or c:IsRelateToEffect(e))
end
function c33700041.spcon(e,tp,eg,ep,ev,re,r,rp)
	local other=Duel.GetFieldCard(tp,LOCATION_SZONE,4-e:GetHandler():GetSequence())
	if other==nil then return end
	if other:GetSequence()==0 then scale=other:GetLeftScale() elseif other:GetSequence()==4 then scale=other:GetRightScale() end
	return eg:IsExists(c33700041.cfilter,1,nil,nil,tp) and scale<2
end
function c33700041.spfilter(c,e,tp)
	return c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700041.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33700041.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33700041.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(c33700041.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
  if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,ft,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
 end
end