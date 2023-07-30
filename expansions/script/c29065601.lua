--战械人形 M16A1
function c29065601.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,29065601)
	e1:SetTarget(c29065601.sptg)
	e1:SetOperation(c29065601.spop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c29065601.indcon)
	e2:SetTarget(c29065601.indtg)
	e2:SetValue(c29065601.indct)
	c:RegisterEffect(e2)
end
function c29065601.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_MACHINE)
end
function c29065601.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c29065601.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c29065601.spfil(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x7ad) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29065601.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29065601.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c29065601.spfil),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(29065601,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c29065601.indcon(e)
	return e:GetHandler():GetEquipTarget()
end
function c29065601.indtg(e,c)
	return c:IsRace(RACE_MACHINE)
end
function c29065601.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end
