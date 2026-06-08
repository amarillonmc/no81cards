local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id+4)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.ritual_filter(c,e,tp)
	return c:IsCode(id+4)
end

function s.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and c:IsSSetable(true)
end

function s.exfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

function s.lv_func(c)
	return 8
end

function s.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=1
end

function s.rgcheck(g,ec)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=1
end

function s.chk(e,tp,ct)
	if ct>0 and (Duel.GetLocationCount(1-tp,LOCATION_SZONE)<ct or not Duel.IsPlayerCanSSet(1-tp)) then return false end
	local loc=LOCATION_HAND+LOCATION_GRAVE
	if ct==2 then loc=loc+LOCATION_DECK end
	
	local mg=Duel.GetRitualMaterial(tp)
	local exg=nil
	if ct>=1 then
		exg=Duel.GetMatchingGroup(s.exfilter,tp,LOCATION_EXTRA,0,nil)
	end
	
	aux.RCheckAdditional=s.rcheck
	aux.RGCheckAdditional=s.rgcheck
	local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,loc,0,1,nil,s.ritual_filter,e,tp,mg,exg,s.lv_func,"Greater")
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
	return res
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return s.chk(e,tp,0) or s.chk(e,tp,1) or s.chk(e,tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local avail={}
	if s.chk(e,tp,0) then table.insert(avail,0) end
	if s.chk(e,tp,1) then table.insert(avail,1) end
	if s.chk(e,tp,2) then table.insert(avail,2) end
	
	if #avail==0 then return end
	
	local ct=0
	if #avail==1 then
		ct=avail[1]
	else
		ct=Duel.AnnounceNumber(tp,table.unpack(avail))
	end
	
	local op_ct=0
	if ct>0 then
		local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
		local g=Duel.GetMatchingGroup(s.setfilter,1-tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and ft>0 and Duel.IsPlayerCanSSet(1-tp) then
			local set_ct=math.min(ct, g:GetCount(), ft)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
			local sg=g:Select(1-tp,set_ct,set_ct,nil)
			if sg:GetCount()>0 then
				op_ct=Duel.SSet(1-tp,sg)
			end
		end
	end
	
	if op_ct>0 then
		Duel.BreakEffect()
	end
	
	local loc=LOCATION_HAND+LOCATION_GRAVE
	if op_ct==2 then loc=loc+LOCATION_DECK end
	
	local mg=Duel.GetRitualMaterial(tp)
	local exg=nil
	if op_ct>=1 then
		exg=Duel.GetMatchingGroup(s.exfilter,tp,LOCATION_EXTRA,0,nil)
	end
	
	aux.RCheckAdditional=s.rcheck
	aux.RGCheckAdditional=s.rgcheck
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,loc,0,1,1,nil,s.ritual_filter,e,tp,mg,exg,s.lv_func,"Greater")
	local tc=tg:GetFirst()
	if tc then
		local mat_g=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if exg then mat_g:Merge(exg) end
		if tc.mat_filter then
			mat_g=mat_g:Filter(tc.mat_filter,tc,tp)
		else
			mat_g:RemoveCard(tc)
		end
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,8,"Greater")
		local mat=mat_g:SelectSubGroup(tp,aux.RitualCheck,true,1,8,tp,tc,8,"Greater")
		aux.GCheckAdditional=nil
		
		if mat then
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
	
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end
