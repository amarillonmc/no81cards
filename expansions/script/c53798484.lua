local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id+4)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function s.rfilter(c,e,tp)
	return c:IsCode(id+4) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function s.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeRitualMaterial(nil)
end
function s.RitualCheck(g,tp,c,lv,mat_req)
	local ct = g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct > mat_req then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		if Duel.GetLocationCountFromEx(tp,tp,g,c)<=0 then return false end
	else
		if Duel.GetMZoneCount(tp,g,tp)<=0 then return false end
	end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetRitualLevel,lv,c)
end
function s.ritual_chk(e,tp,n,cg)
	local rg=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,cg,e,tp)
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanBeRitualMaterial,nil,nil)
	local mg2=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,cg)
	mg:Merge(mg2)
	mg:Sub(cg)
	for tc in aux.Next(rg) do
		local req = tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and 1 or 0
		if req <= n then
			local mat_req = n - req
			local old_check = aux.GCheckAdditional
			aux.GCheckAdditional = function(sg,c,g)
				local ct = sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
				if ct > mat_req then return false end
				return not old_check or old_check(sg,c,g)
			end
			local res = mg:CheckSubGroup(s.RitualCheck,1,8,tp,tc,8,mat_req)
			aux.GCheckAdditional = old_check
			if res then return true end
		end
	end
	return false
end
function s.cost_check(sg,e,tp)
	return s.ritual_chk(e,tp,sg:GetCount(),sg)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local cg=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	local max_n = cg:GetCount()
	local min_n = -1
	for i=0,max_n do
		if s.ritual_chk(e,tp,i,Group.CreateGroup()) then
			min_n = i
			break
		end
	end
	if min_n == -1 then return end
	local b1 = (min_n == 0)
	local b2 = (max_n >= math.max(1, min_n))
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local cost_g = cg:SelectSubGroup(tp,s.cost_check,false,math.max(1,min_n),max_n,e,tp)
		if cost_g and cost_g:GetCount()>0 then
			Duel.SendtoGrave(cost_g,REASON_COST)
			e:SetLabel(cost_g:GetCount())
		end
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsCostChecked() then
			local cg=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
			local max_n = cg:GetCount()
			for i=0,max_n do
				if s.ritual_chk(e,tp,i,Group.CreateGroup()) then
					return true
				end
			end
			return false
		else
			return s.ritual_chk(e,tp,e:GetLabel(),Group.CreateGroup())
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetLabel()>0 then
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	else
		e:SetProperty(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local n=e:GetLabel()
	local rg=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanBeRitualMaterial,nil,nil)
	local mg2=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
	mg:Merge(mg2)
	local tg=rg:Filter(function(tc)
		local req = tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and 1 or 0
		if req > n then return false end
		local mat_req = n - req
		if tc:IsLocation(LOCATION_EXTRA) then
			if Duel.GetLocationCountFromEx(tp,tp,mg,tc)<=0 then return false end
		else
			if Duel.GetMZoneCount(tp,mg,tp)<=0 then return false end
		end
		local old_check = aux.GCheckAdditional
		aux.GCheckAdditional = function(sg,c,g)
			local ct = sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
			if ct > mat_req then return false end
			return not old_check or old_check(sg,c,g)
		end
		local res = mg:CheckSubGroup(s.RitualCheck,1,8,tp,tc,8,mat_req)
		aux.GCheckAdditional = old_check
		return res
	end, nil)
	if tg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		if tc then
			local req = tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and 1 or 0
			local mat_req = n - req
			local old_check = aux.GCheckAdditional
			aux.GCheckAdditional = function(sg,c,g)
				local ct = sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
				if ct > mat_req then return false end
				return not old_check or old_check(sg,c,g)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg:SelectSubGroup(tp,s.RitualCheck,false,1,8,tp,tc,8,mat_req)
			aux.GCheckAdditional = old_check
			if mat then
				tc:SetMaterial(mat)
				Duel.ReleaseRitualMaterial(mat)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
	if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end

