--灭拳魔女·玛姬纱
function c72411370.initial_effect(c)
	aux.AddCodeList(c,72411270)
		--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),4,2)
	c:EnableReviveLimit()
	--special summon (hand)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72411370,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,72411370)
	e1:SetCondition(c72411370.spcon1)
	e1:SetTarget(c72411370.sptg1)
	e1:SetOperation(c72411370.spop1)
	c:RegisterEffect(e1)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c72411370.reptg)
	c:RegisterEffect(e3)
end
function c72411370.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c72411370.defilter1(c)
	return c:IsCode(72411270) and c:IsFaceup()
end
function c72411370.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72411370.defilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c72411370.defilter1,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c72411370.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and aux.IsCodeListed(c,72411270) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72411370.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c72411370.defilter1,tp,LOCATION_ONFIELD,0,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	local ng1=Duel.GetMatchingGroup(c72411370.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if ct>=1 and ng1:GetCount()>0 then
		Duel.BreakEffect()
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g1=Duel.SelectMatchingCard(tp,c72411370.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
				local tc=g1:GetFirst()
				if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1,true)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2,true)
				end
				Duel.SpecialSummonComplete()
			end
	end

	if ct>=2 then
		Duel.BreakEffect()
			if c:IsRelateToEffect(e) and c:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(ct*600)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				c:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				c:RegisterEffect(e2)
			end
	end
	local ng3=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if ct>=3 and ng3:GetCount()>0 then
		Duel.BreakEffect()
			local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
			Duel.Destroy(sg,REASON_EFFECT)
	end

	if ct>=4 then
		Duel.BreakEffect()
			if c:IsRelateToEffect(e) and c:IsFaceup() then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_EXTRA_ATTACK)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				e3:SetValue(1)
				c:RegisterEffect(e3)
			end
	end
	if ct==5 and Duel.IsPlayerCanDraw(tp,3) then
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end
function c72411370.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end