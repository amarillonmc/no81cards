local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id+1,id+4)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(100)
		return true
	end
end
function s.ritfilter(c,e,tp)
	return c:IsCode(id+4) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN_MONSTER,0,0,3,RACE_ZOMBIE,ATTRIBUTE_EARTH) then return false end
		local ct=math.min(math.floor(Duel.GetLP(tp)/1000), ft)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=math.min(ct,1) end
		if ct<=0 then return false end
		local mg=Duel.GetRitualMaterial(tp)
		local ritg=Duel.GetMatchingGroup(s.ritfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		if #ritg==0 then return false end
		local can_pay = false
		for p=1,ct do
			local ok = false
			for tc in aux.Next(ritg) do
				local need = 8 - p*3
				if need <= 0 or mg:CheckWithSumGreater(Card.GetRitualLevel, need, tc) then
					ok = true
					break
				end
			end
			if ok and Duel.CheckLPCost(tp, p*1000, true) then
				can_pay = true
				break
			end
		end
		return can_pay
	end
	e:SetLabel(0)
	local ct=math.min(math.floor(Duel.GetLP(tp)/1000), ft)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=math.min(ct,1) end
	local mg=Duel.GetRitualMaterial(tp)
	local ritg=Duel.GetMatchingGroup(s.ritfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local pay_list = {}
	for p=1,ct do
		local ok = false
		for tc in aux.Next(ritg) do
			local need = 8 - p*3
			if need <= 0 or mg:CheckWithSumGreater(Card.GetRitualLevel, need, tc) then
				ok = true
				break
			end
		end
		if ok and Duel.CheckLPCost(tp, p*1000, true) then
			table.insert(pay_list, p)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local pay=Duel.AnnounceNumber(tp,table.unpack(pay_list))
	Duel.PayLPCost(tp,pay*1000,true)
	e:SetLabel(pay)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,pay,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,pay,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.ritfilter2(c,e,tp,mg)
	if not c:IsCode(id+4) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local m=mg:Filter(Card.IsCanBeRitualMaterial,c,c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,8,"Greater")
	local res=m:CheckSubGroup(aux.RitualCheck,1,8,tp,c,8,"Greater")
	aux.GCheckAdditional=nil
	return res
end
function s.opspfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct>ft or not Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN_MONSTER,0,0,3,RACE_ZOMBIE,ATTRIBUTE_EARTH) then return end
	if ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local tg=Group.CreateGroup()
	for i=1,ct do
		local token=Duel.CreateToken(tp,id+1)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
			tg:AddCard(token)
		end
	end
	Duel.SpecialSummonComplete()
	if #tg>0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ritg=Duel.GetMatchingGroup(s.ritfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,mg)
		if #ritg>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=ritg:Select(tp,1,1,nil):GetFirst()
			if tc then
				local m=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				aux.GCheckAdditional=aux.RitualCheckAdditional(tc,8,"Greater")
				local mat=m:SelectSubGroup(tp,aux.RitualCheck,true,1,8,tp,tc,8,"Greater")
				aux.GCheckAdditional=nil
				if mat then
					tc:SetMaterial(mat)
					Duel.ReleaseRitualMaterial(mat)
					Duel.BreakEffect()
					local loc=tc:GetLocation()
					if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then
						tc:CompleteProcedure()
						if loc==LOCATION_DECK then
							local op_ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
							local sp_ct=#tg
							if op_ft>0 and sp_ct>0 then
								local g2=Duel.GetMatchingGroup(s.opspfilter,tp,0,LOCATION_HAND,nil,e,1-tp)
								local ct2=math.min(op_ft,sp_ct)
								if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ct2=1 end
								if #g2>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
									Duel.BreakEffect()
									Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
									local sg=g2:Select(1-tp,1,ct2,nil)
									Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
								end
							end
						end
					end
				end
			end
		end
	end
end