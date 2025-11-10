--恶魔的残响
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,70781052)
	--select effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)	
end
--special summon chk
function s.spfilter(c,e,tp)
	return c:IsCode(70781052) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--ritual chk
function s.mfilter(c,e)
	return c:IsFaceup() and c:GetLevel()>0 and not c:IsImmuneToEffect(e) and c:IsReleasable()
end
function s.rfilter(c,e,tp)
	return aux.IsCodeListed(c,70781052)
end
function s.RitualUltimateTarget(e,tp)
	local mg1=Duel.GetRitualMaterial(tp)
	mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
	local mg2=Duel.GetMatchingGroup(s.mfilter,tp,0,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,s.rfilter,e,tp,mg1,nil,Card.GetLevel,"Equal")
end
--fusion chk
function s.fusfilter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function s.fusfilter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function s.fusfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and aux.IsCodeListed(c,70781052) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.fusfilter3(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function s.fustg(e,tp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	local mg2=Duel.GetMatchingGroup(s.fusfilter0,tp,0,LOCATION_MZONE,nil)
	mg1:Merge(mg2)
	local res=Duel.IsExistingMatchingCard(s.fusfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(s.fusfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
		end
	end
	return res
end
--synchro and xyz chk
function s.sxfilter(c,mg)
	return aux.IsCodeListed(c,70781052) and (c:IsSynchroSummonable(nil,mg) or c:IsXyzSummonable(mg))
end
function s.synorxyz(e,tp)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(s.fusfilter3,tp,0,LOCATION_MZONE,nil,e)
	if g2 and #g2>0 then
		g1:Merge(g2)
	end
	return Duel.IsExistingMatchingCard(s.sxfilter,tp,LOCATION_EXTRA,0,1,nil,g1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=(Duel.GetFlagEffect(tp,id)==0 or not e:IsCostChecked()) and
		Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,0x13,0,1,nil,e,tp)
	local b2=(Duel.GetFlagEffect(tp,id+1)==0 or not e:IsCostChecked()) and
		s.RitualUltimateTarget(e,tp)
	local b3=(Duel.GetFlagEffect(tp,id+2)==0 or not e:IsCostChecked()) and
		s.fustg(e,tp)
	local b4=(Duel.GetFlagEffect(tp,id+3)==0 or not e:IsCostChecked()) and
		s.synorxyz(e,tp)

	if chk==0 then return b1 or b2 or b3 or b4 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,0)},
		{b2,1168},
		{b3,1169},
		{b4,aux.Stringid(id,1)})
	if e:IsCostChecked() then
		Duel.RegisterFlagEffect(tp,id-1+op,RESET_PHASE+PHASE_END,0,1)
	end
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		end
		e:SetOperation(s.spop)
	elseif op==2 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		end
		e:SetOperation(s.ritop)
	elseif op==3 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
		end
		e:SetOperation(s.fusop)
	elseif op==4 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		end
		e:SetOperation(s.effop)
	end
end
--Special Summon 
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,0x13,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--ritual
function s.ritop(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg1=Duel.GetRitualMaterial(tp)
	mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
	local mg2=Duel.GetMatchingGroup(s.mfilter,tp,0,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,s.rfilter,e,tp,mg1,nil,Card.GetLevel,"Equal")
	local tc=tg:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
--fusion
function s.fusop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.fusfilter3,nil,e)
	local mg2=Duel.GetMatchingGroup(s.fusfilter1,tp,0,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(s.fusfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.fusfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
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
end
--synchro or xyz
function s.synfilter(c,g)
	return aux.IsCodeListed(c,70781052) and c:IsSynchroSummonable(nil,g)
end
function s.xyzfilter(c,g)
	return aux.IsCodeListed(c,70781052) and c:IsXyzSummonable(g,1,#g)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(s.fusfilter3,tp,0,LOCATION_MZONE,nil,e)
	if g2 and #g2>0 then
		g1:Merge(g2)
	end
	local b1=Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,g1)
	local b2=Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g1)
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,
		{b1,1164},
		{b2,1165})
	if op==1 then
		local sg=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,g1)
		if sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(tp,1,1,nil):GetFirst()
			Duel.SynchroSummon(tp,sc,nil,g1)
		end
	else
		local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,g1)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=xyzg:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,tg:GetFirst(),g1,1,#g1)
		end
	end
end
