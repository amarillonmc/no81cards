--观众-精神
function c67201510.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c67201510.target)
	e0:SetOperation(c67201510.activate)
	c:RegisterEffect(e0)
	--confirm
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,67201510)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c67201510.target1)
	e2:SetOperation(c67201510.operation)
	c:RegisterEffect(e2)	
end
--
function c67201510.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_SUMMON)
end
function c67201510.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c67201510.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	Duel.ConfirmCards(tp,g)
end
--
function c67201510.matfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)~=0
end
function c67201510.mfilter(c,e)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)~=0 and c:IsReleasableByEffect(e)
end
function c67201510.filter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_DRAGON)
end
function c67201510.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c67201510.rgcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
--
function c67201510.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(c67201510.matfilter,nil)
		local mg2=Duel.GetMatchingGroup(c67201510.mfilter,tp,LOCATION_SZONE+LOCATION_FZONE,0,nil,e)
		aux.RCheckAdditional=c67201510.rcheck
		aux.RGCheckAdditional=c67201510.rgcheck
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,c67201510.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c67201510.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp):Filter(c67201510.matfilter,nil)
	local mg2=Duel.GetMatchingGroup(c67201510.mfilter,tp,LOCATION_SZONE+LOCATION_FZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c67201510.rcheck
	aux.RGCheckAdditional=c67201510.rgcheck
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,c67201510.filter,e,tp,mg1,mg2,Card.GetLevel,"Greater")
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
	if tc:IsCode(67201501) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.GetFlagEffect(tp,67201510)==0 and Duel.SelectYesNo(tp,aux.Stringid(67201510,1)) then
		Duel.RegisterFlagEffect(tp,67201510,RESET_PHASE+PHASE_END,0,1)
		--local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if #g>0 then
			Duel.ConfirmCards(tp,g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g:FilterSelect(tp,Card.IsAbleToDeck,1,1,nil)
			if #sg<=0 then return end
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			Duel.ShuffleHand(1-tp)
		end
	end
end