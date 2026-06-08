local s,id,o=GetID()
function s.initial_effect(c)
	--Ritual Summon
	local e1=s.AddRitualProcUltimate(c,s.ritual_filter,s.level_function,"Greater",LOCATION_HAND+LOCATION_DECK,nil,nil,false,s.extraop,s.extratg)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end
function s.ritual_filter(c)
	return c:IsCode(id+4)
end
function s.level_function(c)
	return 9
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local ac=Duel.AnnounceCard(tp)
	s[0]={ac}
	getmetatable(c).announce_filter={ac,OPCODE_ISCODE,OPCODE_NOT}
    while #s[0]<ct do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(c).announce_filter))
		table.insert(s[0],ac)
		table.insert(getmetatable(c).announce_filter,ac)
		table.insert(getmetatable(c).announce_filter,OPCODE_ISCODE)
		table.insert(getmetatable(c).announce_filter,OPCODE_NOT)
		table.insert(getmetatable(c).announce_filter,OPCODE_AND)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(s.chainlm)
	end
	
end
function s.chainlm(re,rp,tp)
	local rc=re:GetHandler()
	for _,code in ipairs(s[0]) do
		if rc:IsCode(code) then return false end
	end
	return true
end
function s.extraop(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
end
function s.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if te:IsActiveType(TYPE_MONSTER) and te:GetActivateLocation()==LOCATION_MZONE then return false end
	return true
end
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_RITUAL)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end

-- Customized Ritual Framework
function s.AddRitualProcUltimate(c,filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	summon_location=summon_location or LOCATION_HAND
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.RitualUltimateTarget(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter,extra_target))
	e1:SetOperation(s.RitualUltimateOperation(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter,extra_operation))
	if not pause then
		c:RegisterEffect(e1)
	end
	return e1
end
function s.GetRitualLevel(c,rc)
	if c:GetLevel()>0 then return c:GetLevel()
	elseif c:GetRank()>0 then return c:GetRank()
	elseif c:GetLink()>0 then return c:GetLink()
	else return 0 end
end
function s.RitualCheckGreater(g,c,lv)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(s.GetRitualLevel,lv,c)
end
function s.RitualCheckEqual(g,c,lv)
	return g:CheckWithSumEqual(s.GetRitualLevel,lv,#g,#g,c)
end
function s.RitualCheck(g,tp,c,lv,greater_or_equal)
	if c:IsLocation(LOCATION_EXTRA) then
		if Duel.GetLocationCountFromEx(tp,tp,g,c)<=0 then return false end
	else
		if Duel.GetMZoneCount(tp,g,tp)<=0 then return false end
	end
	return s["RitualCheck"..greater_or_equal](g,c,lv) and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not Auxiliary.RCheckAdditional or Auxiliary.RCheckAdditional(tp,g,c))
end
function s.RitualCheckAdditionalLevel(c,rc)
	local raw_level=s.GetRitualLevel(c,rc)
	local lv1=raw_level&0xffff
	local lv2=raw_level>>16
	if lv2>0 then
		return math.min(lv1,lv2)
	else
		return lv1
	end
end
function s.RitualCheckAdditional(c,lv,greater_or_equal)
	if greater_or_equal=="Equal" then
		return	function(g)
					return (not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g)) and g:GetSum(s.RitualCheckAdditionalLevel,c)<=lv
				end
	else
		return	function(g,ec)
					if ec then
						return (not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g,ec)) and g:GetSum(s.RitualCheckAdditionalLevel,c)-s.RitualCheckAdditionalLevel(ec,c)<=lv
					else
						return not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g)
					end
				end
	end
end
function s.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	Auxiliary.GCheckAdditional=s.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(s.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	Auxiliary.GCheckAdditional=nil
	return res
end
function s.RitualExtraFilter(c,f)
	return s.GetRitualLevel(c)>0 and f(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.RitualUltimateTarget(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter,extra_target)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return false end
					local mg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
					if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp,true) end
					local exg=nil
					if grave_filter then
						exg=Duel.GetMatchingGroup(s.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,grave_filter)
					end
					return Duel.IsExistingMatchingCard(s.RitualUltimateFilter,tp,summon_location,0,1,nil,filter,e,tp,mg,exg,level_function,greater_or_equal,true)
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,summon_location)
				if grave_filter then
					Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
				end
				if extra_target then
					extra_target(e,tp,eg,ep,ev,re,r,rp)
				end
			end
end
function s.RitualUltimateOperation(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter,extra_operation)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				::RitualUltimateSelectStart::
				local mg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
				if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp) end
				local exg=nil
				if grave_filter then
					exg=Duel.GetMatchingGroup(s.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,grave_filter)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,Auxiliary.NecroValleyFilter(s.RitualUltimateFilter),tp,summon_location,0,1,1,nil,filter,e,tp,mg,exg,level_function,greater_or_equal)
				local tc=tg:GetFirst()
				local mat
				if tc then
					mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
					if exg then
						mg:Merge(exg)
					end
					if tc.mat_filter then
						mg=mg:Filter(tc.mat_filter,tc,tp)
					else
						mg:RemoveCard(tc)
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local lv=level_function(tc)
					Auxiliary.GCheckAdditional=s.RitualCheckAdditional(tc,lv,greater_or_equal)
					mat=mg:SelectSubGroup(tp,s.RitualCheck,true,1,lv,tp,tc,lv,greater_or_equal)
					Auxiliary.GCheckAdditional=nil
					if not mat then goto RitualUltimateSelectStart end
					tc:SetMaterial(mat)
					Duel.ReleaseRitualMaterial(mat)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
				if extra_operation then
					extra_operation(e,tp,eg,ep,ev,re,r,rp,tc,mat)
				end
			end
end
