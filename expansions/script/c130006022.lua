--反转世界的觉醒
if not pcall(function() require("expansions/script/c130006013") end) then require("script/c130006013") end
local m,cm=rscf.DefineCard(130006022,"FanZhuanShiJie")
function cm.initial_effect(c)
	local e1 = rsef.A(c,nil,nil,nil,"se,th,fus",nil,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.act)
	local e2 = rsef.I(c,nil,nil,"sp","tg",LOCATION_GRAVE,nil,aux.bfgcost,rstg.target({rscf.spfilter2(),cm.gcheck},"sp",LOCATION_GRAVE,0,2),cm.spop)
end
function cm.spfilter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spop(e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.spfilter2,nil,e,tp)
	if g:GetCount()<2 then return end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local xyzg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
function cm.gcheck(g,e,tp)
	return Duel.GetMZoneCount(tp) >= 2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function cm.xyzfilter(c,g)
	return rsfz.IsSet(c) and c:IsXyzSummonable(g,2,2)
end
function cm.thfilter(c)
	return rsfz.IsSet(c) and c:IsAbleToHand(c) and not c:IsCode(m)
end
function cm.act(e,tp)
	local ct,og,tc = rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	if not tc or not tc:IsLocation(LOCATION_HAND) then return end
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter1),tp,LOCATION_GRAVE,0,nil)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp):Filter(cm.filter3,nil)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) and rshint.SelectYesNo(tp,"sp") then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function cm.filter1(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf) and rsfz.IsSet(c)
end
function cm.filter3(c)
	return c:IsCanBeFusionMaterial() 
end