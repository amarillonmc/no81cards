--同步点
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174040)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"sp",nil,nil,nil,rsop.target(cm.synfilter,"sp",LOCATION_EXTRA),cm.act)
end
function cm.getmat(sync,tp)
	local mg=rsgf.GetSynMaterials(tp,sync)
	local mg2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	return rsgf.Mix2(mg,mg2)
end
function cm.synfilter(c,e,tp)
	--because IsSynchroSummonable check card's summon procedure and not check if the procedure is synchro procedure,
	--so it will cause bug when a card has synchro + xyz two kinds procedure (rainsoon syn*xyz), but do not affect usage effect.
	local mat=cm.getmat(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil,mat)
end
function cm.act(e,tp)
	rshint.Select(tp,"sp")
	local sync=Duel.SelectMatchingCard(tp,cm.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if not sync then return end
	local mat=cm.getmat(sync,tp)
	--rssf.SynchroMaterialAction=cm.matfun
	--Duel.SynchroSummon(tp,sync,nil,mat)
	rssf.SynchroSummonCustom(sync, e, tp, nil, mat, nil, nil, cm.matfun)
end
function cm.matfun(g, sc)
	sc:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_SYNCHRO+REASON_MATERIAL)
end 
--I use the follow way to realize the effect 
--can also hack Duel.SendtoGrave to realize too, but it will cause more bug than this way.
--will cause bug in some other diyers' custom synchro monsters that do not use aux procedure, custom creat the procedure, and write the select operation into the Effect.SetOperation, so that the follow function cannot catch the select target
function rssf.SynchroSummonCustom(sc, e, tp, tuner, mg, minc, maxc, fun)
	if not mg then mg = rsgf.GetSynMaterials(tp, sc) end
	if not sc:IsSynchroSummonable(tuner, mg, minc, maxc) then return false end
	local syn_arr = rscf.proc_record[sc][ SUMMON_TYPE_SYNCHRO ]
	local able_arr, able_desc_arr, able_con_arr = { }, { }, { }
	for _, syne in pairs(syn_arr) do
		local con = syne:GetCondition() or aux.TRUE
		if con(syne, sc, tuner, mg, minc, maxc) then 
			table.insert(able_desc_arr, syne:GetDescription())
			table.insert(able_arr, syne)
			table.insert(able_con_arr, con)
		end
	end
	local syne
	if #able_arr == 1 then
		syne = able_arr[1]
	else
		syne = able_arr[Duel.SelectOption(tp, table.unpack(able_desc_arr)) + 1]
	end
	for _, syne2 in pairs(syn_arr) do
		if syne2 ~= syne then
			syne2:SetCondition(aux.FALSE)
		end
	end
	syne:SetOperation(rssf.SynchroSummonCustom_OP(sc, fun, syne:GetOperation(), able_arr, able_con_arr))
	Duel.SynchroSummon(tp, sc, tuner, mg, minc, maxc)
end
function rssf.SynchroSummonCustom_OP(sc, fun, op, able_arr, able_con_arr)
	return function(e, tp, eg, ep, ev, re, r, rp, c, smat, mg, min, max)
		e:SetOperation(op)
		for idx, syne in pairs(able_arr) do 
			if syne ~= e then
				syne:SetCondition(able_con_arr[idx])
			end
		end
		local mat = e:GetLabelObject()
		fun(mat, sc, e, tp, eg, ep, ev, re, r, rp, c, smat, mg, min, max)
		mat:DeleteGroup()
	end
end

--Record extra summon proc
function rssf.Record_Summon_Proc()
	if rssf.Record_Summon_Proc_Switch then return end
	rssf.Record_Summon_Proc_Switch = true
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(rssf.Record_Summon_Proc_F)
	Duel.RegisterEffect(e1,0)
end
function rssf.Record_Summon_Proc_F(e, c, sump, sumtype, sumpos, targetp, se)
	local arr = { SUMMON_TYPE_SYNCHRO, SUMMON_TYPE_XYZ, SUMMON_TYPE_LINK }
	if c:IsLocation(LOCATION_EXTRA) and se and se:GetCode() == EFFECT_SPSUMMON_PROC then
		for _, st in pairs(arr) do
			if se:GetValue() & st == st then
				if not rscf.proc_record[c] then
					rscf.proc_record[c] = { } 
				end
				if not rscf.proc_record[c][st] then 
					rscf.proc_record[c][st] = { } 
				end
				if not rsof.Table_List(rscf.proc_record[c][st], se) then
					table.insert(rscf.proc_record[c][st], se)
				end
			end
		end
	end
	return false
end 

rssf.Record_Summon_Proc()