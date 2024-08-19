--精神同化的恋慕屋敷
function c9911070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911070+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911070.target)
	e1:SetOperation(c9911070.activate)
	e1:SetValue(c9911070.zones)
	c:RegisterEffect(e1)
end
c9911070.fusion_effect=true
function c9911070.filter(c,b)
	return c:IsSetCard(0x9954) and c:IsType(TYPE_PENDULUM) and ((b and not c:IsForbidden()) or c:IsAbleToHand())
end
function c9911070.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function c9911070.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c9911070.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9954) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9911070.filter3(c,e)
	return not c:IsImmuneToEffect(e)
end
function c9911070.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c9911070.filter0,tp,0,LOCATION_MZONE,nil)
	mg1:Merge(mg2)
	local res=Duel.IsExistingMatchingCard(c9911070.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(c9911070.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
		end
	end
	local sp=Duel.IsExistingMatchingCard(c9911070.filter,tp,LOCATION_DECK,0,1,nil,false) or res
	if p0==p1 or sp then return zone end
	if p0 then zone=zone-0x1 end
	if p1 then zone=zone-0x10 end
	return zone
end
function c9911070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c9911070.filter0,tp,0,LOCATION_MZONE,nil)
	mg1:Merge(mg2)
	local res=Duel.IsExistingMatchingCard(c9911070.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(c9911070.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
		end
	end
	local b=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local g2=Duel.GetMatchingGroup(c9911070.filter,tp,LOCATION_DECK,0,nil,b)
	if chk==0 then return res or #g2>0 end
	local s=0
	if res and #g2==0 then
		s=Duel.SelectOption(tp,aux.Stringid(9911070,0))
	end
	if not res and #g2>0 then
		s=Duel.SelectOption(tp,aux.Stringid(9911070,1))+1
	end
	if res and #g2>0 then
		s=Duel.SelectOption(tp,aux.Stringid(9911070,0),aux.Stringid(9911070,1))
	end
	e:SetLabel(s)
	if s==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function c9911070.addfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsLocation(LOCATION_MZONE) and c:IsCanAddCounter(0x1954,2)
end
function c9911070.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c9911070.filter3,nil,e)
	local mg2=Duel.GetMatchingGroup(c9911070.filter1,tp,0,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c9911070.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c9911070.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	local res=sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)
	local b=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local g2=Duel.GetMatchingGroup(c9911070.filter,tp,LOCATION_DECK,0,nil,b)
	if e:GetLabel()==0 and res then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	if e:GetLabel()==1 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g2:Select(tp,1,1,nil):GetFirst()
		if not tc then return end
		local b1=tc:IsAbleToHand()
		local b2=b and not tc:IsForbidden()
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1160)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
