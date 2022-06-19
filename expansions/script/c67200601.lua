--征冥天的前置契约
function c67200601.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c67200601.target)
	e1:SetOperation(c67200601.activate)
	c:RegisterEffect(e1)	
end
--

function c67200601.matfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)~=0
end
function c67200601.mfilter(c,e)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)~=0 and c:IsReleasableByEffect(e) 
end
function c67200601.mfilterm(c,e)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)~=0 and c:IsAbleToDeck() and c:IsFaceup()
end
function c67200601.filter(c,e,tp)
	return c:IsSetCard(0x677) and c:IsType(TYPE_PENDULUM)
end
function c67200601.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c67200601.rgcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
--
function c67200601.GetCappedLeftScale(c)
	local lscale=c:GetLeftScale()
	if lscale>MAX_PARAMETER then
		return MAX_PARAMETER
	else
		return lscale
	end
end
--
function c67200601.RitualCheckGreater(g,c,lscale)
	if lscale==0 then return false end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(c67200601.GetCappedLeftScale,lscale)
end
function c67200601.RitualCheckEqual(g,c,lscale)
	if lscale==0 then return false end
	return g:CheckWithSumEqual(c67200601.GetCappedLeftScale,lscale,#g,#g)
end
function c67200601.RitualCheck(g,tp,c,lscale,greater_or_equal)
	return ((c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
		(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)) and c67200601["RitualCheck"..greater_or_equal](g,c,lscale) and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not aux.RCheckAdditional or aux.RCheckAdditional(tp,g,c))
end
function c67200601.RitualCheckAdditional(c,lscale,greater_or_equal)
	if greater_or_equal=="Equal" then
		return  function(g)
					return (not aux.RGCheckAdditional or aux.RGCheckAdditional(g)) and g:GetSum(c67200601.GetCappedLeftScale)<=lscale
				end
	else
		return  function(g,ec)
					if lscale==0 then return #g<=1 end
					if ec then
						return (not aux.RGCheckAdditional or aux.RGCheckAdditional(g,ec)) and g:GetSum(c67200601.GetCappedLeftScale)-c67200601.GetCappedLeftScale(ec)<=lscale
					else
						return not aux.RGCheckAdditional or aux.RGCheckAdditional(g)
					end
				end
	end
end
function c67200601.RitualUltimateFilter(c,filter,e,tp,m1,m2,m3,lscale_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if m3 then
		mg:Merge(m3)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lscale=lscale_function(c)
	aux.GCheckAdditional=c67200601.RitualCheckAdditional(c,lscale,greater_or_equal)
	local res=mg:CheckSubGroup(c67200601.RitualCheck,1,#mg,tp,c,lscale,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
function c67200601.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(c67200601.matfilter,nil)
		local mg2=Duel.GetMatchingGroup(c67200601.mfilter,tp,LOCATION_SZONE+LOCATION_FZONE,0,nil)
		local mg3=Duel.GetMatchingGroup(c67200601.mfilterm,tp,LOCATION_EXTRA,0,nil)
		aux.RCheckAdditional=c67200601.rcheck
		aux.RGCheckAdditional=c67200601.rgcheck
		local res=Duel.IsExistingMatchingCard(c67200601.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,c67200601.filter,e,tp,mg,mg2,mg3,c67200601.GetCappedLeftScale,"Greater")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c67200601.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp):Filter(c67200601.matfilter,nil)
	local mg2=Duel.GetMatchingGroup(c67200601.mfilter,tp,LOCATION_SZONE+LOCATION_FZONE,0,nil)
	local mg3=Duel.GetMatchingGroup(c67200601.mfilterm,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c67200601.rcheck
	aux.RGCheckAdditional=c67200601.rgcheck
	local tg=Duel.SelectMatchingCard(tp,c67200601.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,c67200601.filter,e,tp,mg1,mg2,mg3,c67200601.GetCappedLeftScale,"Greater")
	local tc=tg:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		mg:Merge(mg3)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=c67200601.RitualCheckAdditional(tc,tc:GetLeftScale(),"Greater")
		local mat=mg:SelectSubGroup(tp,c67200601.RitualCheck,false,1,#mg,tp,tc,tc:GetLeftScale(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		if dmat:GetCount()>0 then
			mat:Sub(dmat)
			Duel.SendtoDeck(dmat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end
