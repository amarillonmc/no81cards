local m=25000079
local cm=_G["c"..m]
cm.name="次元的霸界王"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.disop)
	e2:SetCountLimit(1,m+100000000)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(4000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local g=Duel.GetMatchingGroup(
		function(c)
			return c:IsType(TYPE_FUSION) and c:IsRace(RACE_MACHINE) and c:IsFaceup()
		end
	,tp,LOCATION_MZONE,0,nil)
	if Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON) then return end
	if rp==1-tp and Duel.IsChainDisablable(ev) and #g>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,1)) then
		Duel.Hint(HINT_CARD,0,m)
		e:UseCountLimit(tp)
		if Duel.NegateEffect(ev) then Duel.Destroy(rc,REASON_EFFECT) end
		Duel.BreakEffect()
		for tc in aux.Next(g) do
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(
				function(e,re)
					return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
						and re:IsActiveType(TYPE_MONSTER)
						and re:GetOwner():IsSummonType(SUMMON_TYPE_SPECIAL)
				end
			)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e4:SetOwnerPlayer(tp)
			tc:RegisterEffect(e4)
		end
	end
end
