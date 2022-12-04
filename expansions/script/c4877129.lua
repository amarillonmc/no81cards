function c4877129.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,4877129+EFFECT_COUNT_CODE_OATH)
	e0:SetOperation(c4877129.activate)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4877129,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,4877130)
	e1:SetTarget(c4877129.target)
	e1:SetCost(c4877129.cost)
	e1:SetOperation(c4877129.operation)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetDescription(aux.Stringid(4877129,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c4877129.drcon1)
	e3:SetTarget(c4877129.rmtg)
	e3:SetOperation(c4877129.rmop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(4877129,ACTIVITY_SPSUMMON,c4877129.counterfilter)
end
function c4877129.drcon1(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetCount()==1 and tg~=e:GetHandler() and tg:IsSummonType(SUMMON_TYPE_RITUAL) and tg:IsPreviousControler(tp)
end
function c4877129.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c4877129.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c4877129.counterfilter(c)
	return  not c:IsSummonableCard()
end
function c4877129.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(4877129,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c4877129.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c4877129.filter(c)
	return c:IsLevel(1) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand() and not c:IsSummonableCard()
end
function c4877129.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c4877129.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(4877129,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c4877129.mfilter(c,e)
	return c:IsType(TYPE_PENDULUM)
end
function c4877129.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterialEx(tp):Filter(Card.IsType,nil,TYPE_PENDULUM)
		local mg2=Duel.GetMatchingGroup(c4877129.mfilter,tp,LOCATION_PZONE,0,nil,e)
		local res=Duel.IsExistingMatchingCard(c4877129.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_PZONE,0,1,nil,nil,e,tp,mg1,mg2,Card.GetLevel,"Greater")
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c4877129.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterialEx(tp):Filter(Card.IsType,nil,TYPE_PENDULUM)
	local mg2=Duel.GetMatchingGroup(c4877129.mfilter,tp,LOCATION_PZONE,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c4877129.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_PZONE,0,1,1,nil,nil,e,tp,mg1,mg2,Card.GetLevel,"Greater")
	local tc=g:GetFirst()
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
		aux.GCheckAdditional=c4877129.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,c4877129.RitualCheck,false,1,#mg,tp,tc,tc:GetLevel(),"Greater")
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
		elseif ct2>0 and (#dg>0 or Duel.SelectYesNo(tp,aux.Stringid(4877129,3))) then
			local min=math.max(#dg,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			mat2=mat:SelectSubGroup(tp,c4877129.descheck,false,min,#mat,mg2,dg)
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
function c4877129.descheck(g,mg2,dg)
	return g:FilterCount(aux.IsInGroup,nil,dg)==#dg and mg2:FilterCount(aux.IsInGroup,nil,g)==#g
end
function c4877129.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsSummonableCard()
end
function c4877129.RitualCheckGreater(g,c,atk)
	if atk==0 then return false end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLeftScale,atk)
end
function c4877129.RitualCheckEqual(g,c,atk)
	if atk==0 then return false end
	return g:CheckWithSumEqual(Card.GetLeftScale,atk,#g,#g)
end
function c4877129.RitualCheck(g,tp,c,atk,greater_or_equal)
	return c4877129["RitualCheck"..greater_or_equal](g,c,atk) and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not aux.RCheckAdditional or aux.RCheckAdditional(tp,g,c))
end
function c4877129.RitualCheckAdditional(c,atk,greater_or_equal)
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
function c4877129.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetOriginalType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or (not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)) or not (c:IsType(TYPE_PENDULUM)) or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)==0) then return false end
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
	aux.GCheckAdditional=c4877129.RitualCheckAdditional(c,atk,greater_or_equal)
	local res=mg:CheckSubGroup(c4877129.RitualCheck,1,#mg,tp,c,atk,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
