--七日之书
local cm,m=GetID()
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.adcon)
	e1:SetTarget(cm.adtg)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ini={[LOCATION_DECK]=false,[LOCATION_HAND]=false,[LOCATION_ONFIELD]=false,[LOCATION_GRAVE]=false,[LOCATION_REMOVED]=false,[LOCATION_EXTRA]=false}
		--2=1 see 0,3=0 see 1
		cm[0],cm[1],cm[2],cm[3]={},{},{},{}
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_MOVE)
		ge0:SetOperation(cm.regop)
		Duel.RegisterEffect(ge0,0)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local tab={LOCATION_DECK,LOCATION_HAND,LOCATION_ONFIELD,LOCATION_GRAVE,LOCATION_REMOVED,LOCATION_EXTRA}
	for i=1,6 do
		local loc=tab[i]
		local g=eg:Filter(cm.spfilter0,nil,loc)
		for tc in aux.Next(g) do
			local p=tc:GetPreviousControler()
			if cm[p] then cm[p][loc]=true end
			if cm[p+2] then cm[p+2][loc]=true end
		end
	end
end
function cm.spfilter0(c,loc)
	return c:IsPreviousLocation(loc) and not (c:IsLocation(loc) and c:IsControler(c:GetPreviousControler()))
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
function cm.spfilter(c,e,tp,mc)
	return bit.band(c:GetType(),0x81)==0x81 and (not c.mat_filter or c.mat_filter(mc,tp))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and mc:IsCanBeRitualMaterial(c)
end
function cm.rfilter(c,mc)
	local mlv=mc:GetRitualLevel(c)
	if mlv==mc:GetLevel() then return false end
	local lv=c:GetLevel()
	return lv==bit.band(mlv,0xffff) or lv==bit.rshift(mlv,16)
end
function cm.filter(c,e,tp,nc)
	local lv=c:GetLevel()|c:GetRank()|c:GetLink()
	local fil=cm.spfilter
	if nc then fil=aux.NecroValleyFilter(fil) end
	local sg=Duel.GetMatchingGroup(fil,tp,LOCATION_GRAVE,0,c,e,tp,c)
	return sg:IsExists(cm.rfilter,1,nil,c) or sg:IsExists(Card.IsLevelBelow,1,nil,lv-1)
end
function cm.mfilter(c,tp)
	local lv=c:GetLevel()|c:GetRank()|c:GetLink()
	local loc=c:GetLocation()
	if loc&LOCATION_ONFIELD>0 then loc=LOCATION_ONFIELD end
	return cm[tp] and cm[tp][loc] and lv>0 and c:IsReleasableByEffect()
end
function cm.mzfilter(c,tp)
	local lv=c:GetLevel()|c:GetRank()|c:GetLink()
	local loc=c:GetLocation()
	if loc&LOCATION_ONFIELD>0 then loc=LOCATION_ONFIELD end
	return cm[tp] and cm[tp][loc] and lv>0 and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:GetSequence()<5
end
function cm.spfilter2(c,e,tp,bool)
	local tc=c
	local loc=c:GetLocation()
	if loc&LOCATION_ONFIELD>0 then loc=LOCATION_ONFIELD end
	if not (cm[3-tp] and cm[3-tp][loc]) then return false end
	for _,sumtype in pairs({0,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_SPECIAL,SUMMON_VALUE_SELF}) do
		if tc:IsSpecialSummonable(sumtype) then return true end
	end
	if bool or not c:IsAbleToHand() then return false end
	local ini=tc.initial_effect
	if tc:IsLocation(LOCATION_HAND+LOCATION_MZONE) or not ini then return false end
	local eset={}
	local _CRegisterEffect=Card.RegisterEffect
	local _DRegisterEffect=Duel.RegisterEffect
	local _SetRange=Effect.SetRange
	function Effect.SetRange(e,r,...)
		table_range=table_range or {}
		table_range[e]=r
		return _SetRange(e,r,...)
	end
	if not Effect.GetRange then
		function Effect.GetRange(e)
			if table_range and table_range[e] then
				return table_range[e]
			end
			return 0
		end
	end
	Duel.RegisterEffect=function() return end
	Card.RegisterEffect=function(c,e,bool)
							if e:GetCode()==EFFECT_SPSUMMON_PROC and e:GetRange()&LOCATION_HAND>0 and e:GetRange()&c:GetLocation()==0 then
								e:SetRange(e:GetRange()|c:GetLocation())
								e:SetReset(RESET_CHAIN)
								local int=_CRegisterEffect(c,e,true)
								eset[#eset+1]=e
								return int
							end
							return 0
						end
	--local nm=tc:IsType(TYPE_NORMAL)
	tc.initial_effect(tc)
	--if nm then Debug.Message(tc:IsType(TYPE_EFFECT)) end
	local res=false
	for _,sumtype in pairs({0,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_SPECIAL,SUMMON_VALUE_SELF}) do
		if tc:IsSpecialSummonable(sumtype) then res=true end
	end
	for _,te in ipairs(eset) do if aux.GetValueType(te)=="Effect" then te:Reset() end end
	Card.RegisterEffect=_CRegisterEffect
	Duel.RegisterEffect=_DRegisterEffect
	return res
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local mg=Duel.GetRitualMaterial(tp)
		if ft>0 then
			--Debug.Message(cm[tp][LOCATION_EXTRA])
			mg=Duel.GetMatchingGroup(cm.mfilter,tp,0x47,0,nil,tp)
		else
			mg=mg:Filter(cm.mzfilter,nil,tp)
		end
		local b1=cm[tp] and ft>=0 and mg:IsExists(cm.filter,1,nil,e,tp)
		local b2=cm[3-tp] and Duel.IsExistingMatchingCard(cm.spfilter2,tp,0x7b,0,1,nil,e,tp)
		return b1 or b2
	end
	if cm[3-tp] then e:SetCategory(CATEGORY_SPECIAL_SUMMON) end
	if cm[tp] then e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON) end
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mg=Duel.GetRitualMaterial(tp)
	if ft>0 then
		mg=Duel.GetMatchingGroup(cm.mfilter,tp,0x47,0,nil,tp)
	else
		mg=mg:Filter(cm.mzfilter,nil,tp)
	end
	local b1=cm[tp] and ft>=0 and mg:IsExists(cm.filter,1,nil,e,tp,true)
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		::cancel::
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:FilterSelect(tp,cm.filter,1,1,nil,e,tp,true)
		local mc=mat:GetFirst()
		if mc then
			local lv=mc:GetLevel()|mc:GetRank()|mc:GetLink()
			local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,mc,e,tp,mc)
			local b1=sg:IsExists(cm.rfilter,1,nil,mc)
			local b2=sg:IsExists(Card.IsLevelBelow,1,nil,lv-1)
			if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(m,4))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tc=sg:Filter(cm.rfilter,nil,mc):SelectUnselect(nil,tp,false,true,1,1)
				if not tc then goto cancel end
				tc:SetMaterial(mat)
				if mc:IsLocation(LOCATION_MZONE) then
					Duel.ReleaseRitualMaterial(mat)
				else
					Duel.Release(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
				end
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
			else
				local lv=mc:GetLevel()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tc=sg:Filter(Card.IsLevelBelow,nil,lv-1):SelectUnselect(nil,tp,false,true,1,1)
				if not tc then goto cancel end
				tc:SetMaterial(mat)
				if mc:IsLocation(LOCATION_MZONE) then
					Duel.ReleaseRitualMaterial(mat)
				else
					Duel.Release(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
				end
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				Duel.SpecialSummonComplete()
			end
		end
		cm[tp]=nil
		if (not cm[tp] and not cm[3-tp]) then
			Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,5))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,5))
			cm[tp],cm[3-tp]={},{}
		end
	end
	local b2=cm[3-tp] and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter2),tp,0x7b,0,1,nil,e,tp)
	if b2 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter2),tp,0x7b,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		if tc and (not cm.spfilter2(tc,e,tp,true) or (not tc:IsLocation(LOCATION_HAND) and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(m,6)))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
		for _,sumtype in pairs({0,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_SPECIAL,SUMMON_VALUE_SELF}) do
			if tc:IsSpecialSummonable(sumtype) then
				Duel.SpecialSummonRule(tp,tc,sumtype)
				break
			end
		end
		cm[3-tp]=nil
		if (not cm[tp] and not cm[3-tp]) then
			Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,5))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,5))
			cm[tp],cm[3-tp]={},{}
		end
	end
end