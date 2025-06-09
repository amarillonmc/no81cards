--身既为佛
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	aux.AddCodeList(c,5012625)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
end
function s.tgfilter(c)
	local b1=c:IsLocation(LOCATION_REMOVED)
	local b2=c.MoJin==true  and c:IsLocation(LOCATION_DECK) and c:IsType(TYPE_MONSTER)
	local b3=c:IsFaceupEx() and c:IsCode(5012625) and c:IsLocation(LOCATION_MZONE)
	return (b1 or b2 or b3) and c:IsAbleToGrave()
end
function s.filter(c,e,tp)
	return c:IsCode(5012625) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function s.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g,tp)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg1=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local b1=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_REMOVED,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_MZONE,0,1,nil)
	local b4=rg1:CheckSubGroup(s.fselect,11,11,tp)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 or b3 or b4 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=3
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(id,4)
		opval[off-1]=4
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOGRAVE)
		local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_REMOVED,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	elseif sel==2 then
		e:SetCategory(CATEGORY_TOGRAVE)
		local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	elseif sel==3 then
		e:SetCategory(CATEGORY_TOGRAVE)
		local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_MZONE,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	else
		e:SetCategory(CATEGORY_RELEASE)
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,rg1,11,0,LOCATION_ONFIELD)
	end
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
	local sel=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_REMOVED+LOCATION_DECK+LOCATION_MZONE,0,nil)
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_REMOVED)
		if #sg>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
		end
	elseif sel==2 then
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_DECK)
		if #sg>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	elseif sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local sg=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
		local pg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if ft>0 and #sg>0 and Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)~=0 then
			if pg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local cg=pg:Select(tp,1,1,nil)--cg=pg:Select(tp,1,ft,nil)
				Duel.SpecialSummon(cg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		local rg1=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rs=rg1:SelectSubGroup(tp,s.fselect,false,11,11,tp)
		if Duel.Release(rs,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
			local tc=rg:GetFirst()
			if tc then
				tc:SetMaterial(rs)
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
end