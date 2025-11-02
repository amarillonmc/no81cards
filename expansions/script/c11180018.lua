--净玉之鸣
local s, id = GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
end
function s.pubfilter(c,tp)
	return c:IsSetCard(0x3450,0x6450) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(s.nbfilter,tp,0xc,0xc,1,nil,c:GetType())
end
function s.nbfilter(c,type)
	return c:IsFaceup() and aux.NegateAnyFilter(c) and c:IsAbleToRemove() and c:IsType(type)
		and c~=cc
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x3450) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.pubfilter,tp,LOCATION_HAND,0,1,c,tp)
	local b2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,1)},{b2,aux.Stringid(id,2)})
	e:SetLabel(op)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.pubfilter,tp,LOCATION_HAND,0,1,1,nil)
		if #g<1 then return end
		local pc=g:GetFirst()
		local type=pc:GetType()
		local tc=Duel.SelectMatchingCard(tp,s.nbfilter,tp,0xc,0xc,1,1,aux.ExceptThisCard(e),type):GetFirst()
		if tc and tc:IsCanBeDisabledByEffect(e) then
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
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
			Duel.AdjustInstantly()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	elseif op==2 then
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc then
				Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
end
