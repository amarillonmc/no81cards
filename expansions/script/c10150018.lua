--tb
function c10150018.initial_effect(c)
	--setcode
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(0x1019)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150018,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c10150018.chcon)
	e2:SetTarget(c10150018.chtg)
	e2:SetOperation(c10150018.chop)
	c:RegisterEffect(e2)
end
function c10150018.chcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==tp and re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x1019)
end
function c10150018.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(rp,LOCATION_MZONE)>=2 and Duel.IsExistingMatchingCard(c10150018.spfilter,rp,0x13,0,1,nil,e,rp,re:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10150018.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)<=0 or not Duel.SelectYesNo(tp,aux.Stringid(10150018,1)) then return end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(10150018,2))
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c10150018.repop)
end
function c10150018.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10150018.spfilter),tp,0x13,0,1,1,nil,e,tp,c)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_VALUE_GLADIATOR,tp,tp,false,false,POS_FACEUP)
		if stp==130 then
		   tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+0x1ff0000,0,0)
		end
	end
end
function c10150018.spfilter(c,e,tp,rc)
	return not c:IsCode(rc:GetCode()) and c:IsSetCard(0x1019) and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_GLADIATOR,tp,false,false)
end
