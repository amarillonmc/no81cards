function c4877093.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4877093,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,4877093)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c4877093.target)
	e1:SetOperation(c4877093.operation)
	c:RegisterEffect(e1)
end
function c4877093.mfilter(c,e)
	return c:IsType(TYPE_PENDULUM)
end
function c4877093.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterialEx(tp):Filter(Card.IsType,nil,TYPE_PENDULUM)
		local mg2=Duel.GetMatchingGroup(c4877093.mfilter,tp,LOCATION_PZONE+LOCATION_HAND+LOCATION_MZONE,0,nil,e)
		local res=Duel.IsExistingMatchingCard(c4877093.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,nil,e,tp,mg1,mg2,Card.GetLevel,"Greater")
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c4877093.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterialEx(tp):Filter(Card.IsType,nil,TYPE_PENDULUM)
	local mg2=Duel.GetMatchingGroup(c4877093.mfilter,tp,LOCATION_PZONE+LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c4877093.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,nil,e,tp,mg1,mg2,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if sg then
			mg:Merge(sg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=c4877093.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,c4877093.RitualCheck,false,1,#mg,tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil return end
		tc:SetMaterial(mat)
		local ct1=mat:FilterCount(aux.IsInGroup,nil,mg1)
		local ct2=mat:FilterCount(aux.IsInGroup,nil,mg2)
		local dg=mat-mg
		local mat1=mat:Clone()
		local mat2
		if ct1==0 then
			mat2=mat
			mat1:Clear()
		elseif ct2>0 and (#dg>0 or Duel.SelectYesNo(tp,aux.Stringid(4877093,2))) then
			local min=math.max(#dg,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			mat2=mat:SelectSubGroup(tp,c4877093.descheck,false,min,#mat,mg2,dg)
			mat1:Sub(mat2)
		end
		if #mat1>0 then
			Duel.ReleaseRitualMaterial(mat1)
		end
		if mat2 then
			Duel.ConfirmCards(1-tp,mat2)
			Duel.Release(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c4877093.descheck(g,mg2,dg)
	return g:FilterCount(aux.IsInGroup,nil,dg)==#dg and mg2:FilterCount(aux.IsInGroup,nil,g)==#g
end
function c4877093.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsSummonableCard()
end
function c4877093.RitualCheckGreater(g,c,atk)
	if atk==0 then return false end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLeftScale,atk)
end
function c4877093.RitualCheckEqual(g,c,atk)
	if atk==0 then return false end
	return g:CheckWithSumEqual(Card.GetLeftScale,atk,#g,#g)
end
function c4877093.RitualCheck(g,tp,c,atk,greater_or_equal)
	return c4877093["RitualCheck"..greater_or_equal](g,c,atk) and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not aux.RCheckAdditional or aux.RCheckAdditional(tp,g,c))
end
function c4877093.RitualCheckAdditional(c,atk,greater_or_equal)
	if greater_or_equal=="Equal" then
		return  function(g)
					return (not aux.RGCheckAdditional or aux.RGCheckAdditional(g)) and g:GetSum(Card.GetLeftScale)<=atk
				end
	else
		return  function(g,ec)
					if atk==0 then return #g<=1 end
					if ec then
						return (not aux.RGCheckAdditional or aux.RGCheckAdditional(g,ec)) and g:GetSum(Card.GetLeftScale)-Card.GetLeftScale(ec)<=atk
					else
						return not aux.RGCheckAdditional or aux.RGCheckAdditional(g)
					end
				end
	end
end
function c4877093.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or (not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)) or not (c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x48d)) or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)==0) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local atk=level_function(c)
	aux.GCheckAdditional=c4877093.RitualCheckAdditional(c,atk,greater_or_equal)
	local res=mg:CheckSubGroup(c4877093.RitualCheck,1,#mg,tp,c,atk,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end