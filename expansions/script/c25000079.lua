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
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local g=Duel.GetMatchingGroup(function(c)return c:IsType(TYPE_FUSION) and c:IsRace(RACE_MACHINE) and c:IsFaceup()end,tp,LOCATION_MZONE,0,nil)
	if Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON) then return end
	if rp==1-tp and Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,m)==0 and #g>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,1)) then
		Duel.Hint(HINT_CARD,0,m)
		if Duel.NegateEffect(ev) then Duel.Destroy(rc,REASON_EFFECT) end
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.BreakEffect()
		for tc in aux.Next(g) do
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(function(e,re)return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and te:IsActiveType(TYPE_MONSTER) and (te:GetOwner()~=e:GetHandler() or te:IsActivated() and not e:GetHandler():IsRelateToEffect(te)) and te:GetActivateLocation()==LOCATION_MZONE and te:GetOwner():IsSummonLocation(LOCATION_EXTRA)end)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e4:SetOwnerPlayer(tp)
			tc:RegisterEffect(e4)
		end
	end
end
