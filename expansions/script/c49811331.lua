--愚痴之封术僧正
function c49811331.initial_effect(c)
	c:SetSPSummonOnce(49811331)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c49811331.matfilter,1,1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,49811331)
	e1:SetCondition(c49811331.spcon)
	e1:SetTarget(c49811331.sptg)
	e1:SetOperation(c49811331.spop)
	c:RegisterEffect(e1)
end
function c49811331.matfilter(c)
	return c:IsType(TYPE_NORMAL) and not c:IsLinkType(TYPE_TOKEN)
end
function c49811331.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c49811331.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsLocation(LOCATION_HAND+LOCATION_DECK)
end
function c49811331.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetMaterial():Filter(c49811331.spfilter,nil,e,tp)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg:GetFirst(),1,tp,mg:GetFirst():GetLocation())
	Duel.SetChainLimit(aux.FALSE)
end
function c49811331.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial():Filter(c49811331.spfilter,nil,e,tp)
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,1,REASON_EFFECT)>0 and #mg>0 then
		local tc=mg:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			--local e1=Effect.CreateEffect(c)
			--e1:SetType(EFFECT_TYPE_SINGLE)
			--e1:SetCode(EFFECT_DISABLE)
			--e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			--tc:RegisterEffect(e1)
			--local e2=Effect.CreateEffect(c)
			--e2:SetType(EFFECT_TYPE_SINGLE)
			--e2:SetCode(EFFECT_DISABLE_EFFECT)
			--e2:SetValue(RESET_TURN_SET)
			--e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			--tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_SPELL+TYPE_TRAP)
			if #sg>0 then
				Duel.BreakEffect()
				if Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)>0 then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetCode(EFFECT_CANNOT_ACTIVATE)
					e1:SetTargetRange(1,1)
					e1:SetValue(c49811331.aclimit)
					e1:SetLabel(sg:GetFirst():GetCode())
					Duel.RegisterEffect(e1,tp)	
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end
	end
end
function c49811331.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end