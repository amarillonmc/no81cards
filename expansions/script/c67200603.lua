--征冥天的支配显现
function c67200603.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c67200603.target)
	e1:SetOperation(c67200603.activate)
	c:RegisterEffect(e1)  
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200603,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CUSTOM+67200603)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,67200603)
	e2:SetCondition(c67200603.thcon)
	e2:SetOperation(c67200603.thop)
	c:RegisterEffect(e2)  
end
--

function c67200603.matfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)~=0 and c:IsSetCard(0x677)
end
function c67200603.mfilter(c,e)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)~=0 and c:IsReleasableByEffect(e) and c:IsSetCard(0x677)
end
function c67200603.filter(c,e,tp)
	return c:IsType(TYPE_PENDULUM)
end
function c67200603.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c67200603.rgcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
--
function c67200603.GetCappedLeftScale(c)
	local lscale=c:GetLeftScale()
	if lscale>MAX_PARAMETER then
		return MAX_PARAMETER
	else
		return lscale
	end
end
--
function c67200603.RitualCheckGreater(g,c,lscale)
	if lscale==0 then return false end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(c67200603.GetCappedLeftScale,lscale)
end
function c67200603.RitualCheckEqual(g,c,lscale)
	if lscale==0 then return false end
	return g:CheckWithSumEqual(c67200603.GetCappedLeftScale,lscale,#g,#g)
end
function c67200603.RitualCheck(g,tp,c,lscale,greater_or_equal)
	return ((c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
		(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)) and c67200603["RitualCheck"..greater_or_equal](g,c,lscale) and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not aux.RCheckAdditional or aux.RCheckAdditional(tp,g,c))
end
function c67200603.RitualCheckAdditional(c,lscale,greater_or_equal)
	if greater_or_equal=="Equal" then
		return  function(g)
					return (not aux.RGCheckAdditional or aux.RGCheckAdditional(g)) and g:GetSum(c67200603.GetCappedLeftScale)<=lscale
				end
	else
		return  function(g,ec)
					if lscale==0 then return #g<=1 end
					if ec then
						return (not aux.RGCheckAdditional or aux.RGCheckAdditional(g,ec)) and g:GetSum(c67200603.GetCappedLeftScale)-c67200603.GetCappedLeftScale(ec)<=lscale
					else
						return not aux.RGCheckAdditional or aux.RGCheckAdditional(g)
					end
				end
	end
end
function c67200603.RitualUltimateFilter(c,filter,e,tp,m1,m2,lscale_function,greater_or_equal,chk)
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
	local lscale=lscale_function(c)
	aux.GCheckAdditional=c67200603.RitualCheckAdditional(c,lscale,greater_or_equal)
	local res=mg:CheckSubGroup(c67200603.RitualCheck,1,#mg,tp,c,lscale,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
function c67200603.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(c67200603.matfilter,nil)
		local mg2=Duel.GetMatchingGroup(c67200603.mfilter,tp,LOCATION_SZONE+LOCATION_FZONE,0,nil)
		aux.RCheckAdditional=c67200603.rcheck
		aux.RGCheckAdditional=c67200603.rgcheck
		local res=Duel.IsExistingMatchingCard(c67200603.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,c67200603.filter,e,tp,mg,mg2,c67200603.GetCappedLeftScale,"Greater")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c67200603.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp):Filter(c67200603.matfilter,nil)
	local mg2=Duel.GetMatchingGroup(c67200603.mfilter,tp,LOCATION_SZONE+LOCATION_FZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c67200603.rcheck
	aux.RGCheckAdditional=c67200603.rgcheck
	local tg=Duel.SelectMatchingCard(tp,c67200603.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,c67200603.filter,e,tp,mg1,mg2,c67200603.GetCappedLeftScale,"Greater")
	local tc=tg:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=c67200603.RitualCheckAdditional(tc,tc:GetLeftScale(),"Greater")
		local mat=mg:SelectSubGroup(tp,c67200603.RitualCheck,false,1,#mg,tp,tc,tc:GetLeftScale(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		e:SetLabelObject(tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetOperation(c67200603.evop)
		e1:SetLabelObject(e)
		Duel.RegisterEffect(e1,tp)
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end
--
function c67200603.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return re:GetHandler()==e:GetHandler() and tc:IsSetCard(0x677)
end
function c67200603.thfilter(c,e,tp)
	return c:IsControler(tp) and c:IsAbleToHand()
end
function c67200603.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local mat=tc:GetMaterial()
	if Duel.SelectYesNo(tp,aux.Stringid(67200603,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=mat:FilterSelect(tp,c67200603.thfilter,1,1,nil,e,tp)
		if g:GetCount()>0  then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c67200603.evop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetLabelObject()
	Duel.RaiseEvent(tc,EVENT_CUSTOM+67200603,te,0,tp,tp,0)
	te:SetLabelObject(nil)
	e:Reset()
end

