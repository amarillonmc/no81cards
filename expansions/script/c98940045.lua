--阳炎兽 刻律涅牝
function c98940045.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98940045,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c98940045.ntcon)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98940045,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c98940045.spcost)
	e2:SetTarget(c98940045.sptg)
	e2:SetOperation(c98940045.spop)
	c:RegisterEffect(e2)
	 --cannot be targeted
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function c98940045.ntcon(e,c,tp)
	if c==nil then return true end
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c98940045.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98940045.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsCode(98940045) and c:IsLevel(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98940045.fselect(g,tp)
	return g:GetClassCount(Card.GetCode)==g:GetCount() and Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,g,g:GetCount(),g:GetCount())
end
function c98940045.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c98940045.filter,tp,0x13,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:GetCount()>0 and g:CheckSubGroup(c98940045.fselect,2,ft,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98940045.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98940045.filter),tp,0x13,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c98940045.fselect,false,2,ft,tp)
	if sg then
		local tc1=sg:GetFirst()
		while tc1 do
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e3)
		tc1=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		Duel.AdjustAll()
		if sg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
		local xyzg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,sg,sg:GetCount(),sg:GetCount())
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,sg)
		end
	end
end