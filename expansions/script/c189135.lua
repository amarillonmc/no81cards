local m=189135
local cm=_G["c"..m]
cm.name="阿拉斯工作室"
function cm.initial_effect(c)
	aux.AddCodeList(c,189131)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.hfilter(c)
	return not c:IsPublic()
end
function cm.tgfilter(c)
	return aux.IsCodeListed(c,189131) and c:IsAbleToGrave()
end
function cm.spfilter(c,e,tp)
	return ((c:IsLocation(LOCATION_HAND) and (c:IsPublic() or c:GetFlagEffect(189133)~=0)) or (c:IsLocation(LOCATION_GRAVE))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(cm.hfilter,tp,0,LOCATION_HAND,nil)>0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.hfilter,tp,0,LOCATION_HAND,nil)
	local rtype=0
	if g:GetCount()~=0 then
		local ct=1
		if Duel.IsPlayerAffectedByEffect(tp,189137) and Duel.GetFlagEffect(tp,189137)==0 and g:GetCount()>=2 and Duel.SelectYesNo(tp,aux.Stringid(189137,2)) then
			ct=2
			Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+189138,e,REASON_EFFECT,tp,1-tp,ev)
			Duel.RegisterFlagEffect(tp,189137,RESET_PHASE+PHASE_END,0,1)
		end
		local ag=g:RandomSelect(tp,ct)
		local ac=ag:GetFirst()
		while ac do
			if bit.band(rtype,bit.band(ac:GetType(),0x7))==0 then
				rtype=rtype+bit.band(ac:GetType(),0x7)
			end
			ac:RegisterFlagEffect(189133,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,66)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			ac:RegisterEffect(e1)
			ac=ag:GetNext()
		end
		Duel.ConfirmCards(tp,ag)
	local opt=e:GetLabel()
	if (opt==0 and bit.band(rtype,TYPE_MONSTER)~=0) or (opt==1 and bit.band(rtype,TYPE_SPELL)~=0) or (opt==2 and bit.band(rtype,TYPE_TRAP)~=0) then
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,0,LOCATION_HAND+LOCATION_GRAVE,1,nil,e,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,0,LOCATION_HAND+LOCATION_GRAVE,1,1,nil,e,tp)
			local tc=g1:GetFirst()
			if tc and Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_SET_ATTACK)
				e3:SetValue(0)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
				local e4=e3:Clone()
				e4:SetCode(EFFECT_SET_DEFENSE)
				tc:RegisterEffect(e4)
				Duel.SpecialSummonComplete()
			end
		end
	elseif Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) then
		local fg=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=fg:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	end
end