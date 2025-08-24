--收尸人-静寂
function c67201512.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c67201512.target)
	e0:SetOperation(c67201512.activate)
	c:RegisterEffect(e0)
	--confirm
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,67201512)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c67201512.target1)
	e2:SetOperation(c67201512.operation1)
	c:RegisterEffect(e2)	  
end
--
function c67201512.matfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)~=0
end
function c67201512.mfilter(c,e)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)~=0 and c:IsReleasableByEffect(e)
end
function c67201512.filter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_REPTILE)
end
function c67201512.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c67201512.rgcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
--
function c67201512.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(c67201512.matfilter,nil)
		local mg2=Duel.GetMatchingGroup(c67201512.mfilter,tp,LOCATION_SZONE+LOCATION_FZONE,0,nil)
		aux.RCheckAdditional=c67201512.rcheck
		aux.RGCheckAdditional=c67201512.rgcheck
		local res=Duel.IsExistingMatchingCard(c67201512.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,c67201512.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c67201512.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp):Filter(c67201512.matfilter,nil)
	local mg2=Duel.GetMatchingGroup(c67201512.mfilter,tp,LOCATION_SZONE+LOCATION_FZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c67201512.rcheck
	aux.RGCheckAdditional=c67201512.rgcheck
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,c67201512.filter,e,tp,mg1,mg2,Card.GetLevel,"Greater")
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
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,#mg,tp,tc,tc:GetLevel(),"Greater")
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
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
	if tc:IsCode(67201511) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c67201512.spfilter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) and Duel.GetFlagEffect(tp,67201512)==0 and Duel.SelectYesNo(tp,aux.Stringid(67201512,1)) then
		Duel.RegisterFlagEffect(tp,67201512,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c67201512.spfilter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c67201512.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
--
function c67201512.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c67201512.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c67201512.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67201512.filter1,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67201512,2))
	local g=Duel.SelectTarget(tp,c67201512.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c67201512.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end