-- 幻想使役者·霏璃
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x624)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(9,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.ctcon)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(s.atkcon)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	local e3b=e3:Clone()
	e3b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3b)
end
s.listed_series={0x5624}
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.fairygfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.fairygfilter(c)
	return c:IsCode(60012101) and c:IsFaceup()
end
function s.spfilter(c,e,tp)
	return c:IsCode(60012101) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	end
	local ct=Duel.GetFlagEffect(tp,id)+1
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	if ct==3 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	if ct==6 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if #g2>0 then
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	if ct==9 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g3=Duel.SelectMatchingCard(tp,s.spfilter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if #g3>0 then
				Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		local g4=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #g4>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g4:Select(tp,0,#g4,nil)
			if #sg>0 then
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
function s.spfilter2(c,e,tp)
	return c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER)
		and c:IsCanHaveCounter(0x624) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spfilter3(c,e,tp)
	return c:IsLevelAbove(6) and c:IsType(TYPE_MONSTER)
		and c:IsCanHaveCounter(0x624) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
		and re and re:GetHandler():IsRace(RACE_SPELLCASTER)
		and re:GetHandler():GetPreviousLocation()==LOCATION_EXTRA
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanAddCounter(0x624,1) then
		if c:AddCounter(0x624,1) then
			Duel.RegisterFlagEffect(tp,60002148,0,0,1)
		end
	end
	if re:GetHandler():IsSetCard(0x5624) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.atkcon(e)
	return e:GetHandler():GetCounter(0x624)>0
end