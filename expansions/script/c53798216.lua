local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2,s.ovfilter,aux.Stringid(id,0),2,s.xyzop)
	c:EnableReviveLimit()
	--effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:GetOverlayCount()>=2 and c:IsType(TYPE_XYZ)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()>0
end
function s.check_match(c,rc,att,lv1,lv2)
	local r_match = (c:GetRace() & rc ~= 0)
	local a_match = (c:GetAttribute() & att ~= 0)
	local l_match = (c:GetLevel() == lv1 or c:GetLevel() == lv2)
	local match_count = 0
	local match_type = 0
	if r_match then match_count = match_count + 1; match_type = 1 end
	if a_match then match_count = match_count + 1; match_type = 2 end
	if l_match then match_count = match_count + 1; match_type = 3 end
	if match_count == 1 then return match_type else return 0 end
end
function s.tgfilter(c,e,tp,rc,att,lv1,lv2)
	if not c:IsType(TYPE_MONSTER) then return false end
	local mt=s.check_match(c,rc,att,lv1,lv2)
	return mt>0 and (c:IsAbleToRemove() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.gcheck(rc,att,lv1,lv2,e,tp)
	return function(g)
		local f1,f2,f3=false,false,false
		local sp=false
		for tc in aux.Next(g) do
			local mt = s.check_match(tc,rc,att,lv1,lv2)
			if mt==1 then f1=true end
			if mt==2 then f2=true end
			if mt==3 then f3=true end
			if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then sp=true end
		end
		return f1 and f2 and f3 and sp
	end
end
function s.chk_combo(g,e,tp)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	local rc=tc1:GetRace()|tc2:GetRace()
	local att=tc1:GetAttribute()|tc2:GetAttribute()
	local lv1=tc1:GetLevel()
	local lv2=tc2:GetLevel()
	local mg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,rc,att,lv1,lv2)
	return mg:CheckSubGroup(s.gcheck(rc,att,lv1,lv2,e,tp),3,3)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup():Filter(s.rmfilter,nil)
	if chk==0 then return og:CheckSubGroup(s.chk_combo,2,2,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local tg=og:SelectSubGroup(tp,s.chk_combo,false,2,2,e,tp)
	tg:KeepAlive()
	e:SetLabelObject(tg)
	Duel.SendtoGrave(tg,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	if not tg then return end
	local tc1=tg:GetFirst()
	local tc2=tg:GetNext()
	local rc=tc1:GetRace()|tc2:GetRace()
	local att=tc1:GetAttribute()|tc2:GetAttribute()
	local lv1=tc1:GetLevel()
	local lv2=tc2:GetLevel()
	tg:DeleteGroup()
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.tgfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,rc,att,lv1,lv2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=mg:SelectSubGroup(tp,s.gcheck(rc,att,lv1,lv2,e,tp),false,3,3)
	if sg and sg:GetCount()==3 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local spg=sg:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false)
		if spg:GetCount()>0 then
			if Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)>0 then
				sg:Sub(spg)
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end