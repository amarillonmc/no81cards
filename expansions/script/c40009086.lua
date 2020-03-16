--布鲁加尔
function c40009086.initial_effect(c)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(40009087)
	c:RegisterEffect(e1) 
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009086,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c40009086.descon)
	e3:SetCost(c40009086.spcost)
	e3:SetTarget(c40009086.sptg)
	e3:SetOperation(c40009086.spop)
	c:RegisterEffect(e3)   
	--atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c40009086.descon2)
	e5:SetOperation(c40009086.atkop)
	c:RegisterEffect(e5)  
end
function c40009086.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL)
end
function c40009086.descon2(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rc:IsCode(40009088) or rc:IsCode(40009089)
end
function c40009086.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009086,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c40009086.spcost)
	e3:SetTarget(c40009086.sptg)
	e3:SetOperation(c40009086.spop)
	c:RegisterEffect(e3)
end
function c40009086.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c40009086.spfilter(c,e,tp)
	return c:IsCode(40009087) and c:IsCanBeSpecialSummoned(e,123,tp,false,false)
end
function c40009086.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if e:GetHandler():GetSequence()<5 then ft=ft+1 end
		return ft>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.IsExistingMatchingCard(c40009086.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_HAND)
end
function c40009086.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c40009086.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		local tc=sg:GetFirst()
		Duel.SpecialSummonStep(tc,123,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0)
		tc=sg:GetNext()
		Duel.SpecialSummonStep(tc,123,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0)
		Duel.SpecialSummonComplete()
	end
end