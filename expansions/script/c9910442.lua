--双影杀手-布梦者
function c9910442.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9910442.discon)
	e1:SetOperation(c9910442.disop)
	c:RegisterEffect(e1)
end
function c9910442.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK 
end
function c9910442.cfilter(c,e,typ)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and c:IsType(typ)
end
function c9910442.negfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.NegateAnyFilter(c)
end
function c9910442.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c9910442.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,e,TYPE_MONSTER)
	local g2=Duel.GetMatchingGroup(c9910442.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil,e,TYPE_SPELL+TYPE_TRAP)
	local dg1=Duel.GetMatchingGroup(c9910442.negfilter,tp,0,LOCATION_ONFIELD,nil)
	local dg2=Duel.GetMatchingGroup(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,nil)
	local b1=#g1>0 and #dg1>0
	local b2=#g2>0 and #dg2>0
	if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(9910442,0)) then
		Duel.Hint(HINT_CARD,0,9910442)
		if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(9910442,1),aux.Stringid(9910442,2))==0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sc=g1:Select(tp,1,1,nil):GetFirst()
			if sc and Duel.SendtoGrave(sc,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_GRAVE) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
				local sg=dg1:Select(tp,1,1,nil)
				local tc=sg:GetFirst()
				if tc then
					Duel.HintSelection(sg)
					Duel.NegateRelatedChain(tc,RESET_TURN_SET)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					tc:RegisterEffect(e2)
					if tc:IsType(TYPE_TRAPMONSTER) then
						local e3=e1:Clone()
						e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
						tc:RegisterEffect(e3)
					end
				end
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sc=g2:Select(tp,1,1,nil):GetFirst()
			if sc and Duel.SendtoGrave(sc,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_GRAVE) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
				local sg=dg2:Select(tp,1,1,nil)
				local tc=sg:GetFirst()
				if tc then
					Duel.HintSelection(sg)
					Duel.NegateRelatedChain(tc,RESET_TURN_SET)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					tc:RegisterEffect(e2)
				end
			end
		end
	end
end
