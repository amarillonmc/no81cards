--真究极龙骑士
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10150097)
function cm.initial_effect(c)
	rscf.SetSummonCondition(c,false,aux.fuslimit)
	aux.AddFusionProcFun2(c,cm.ffilter1,cm.ffilter2,true)   
	local e1=rsef.SV_IMMUNE_EFFECT(c)
	local e2,e3=rsef.SV_UPDATE(c,"atk,def",5000,rscon.phbp)
end
function cm.ffilter1(c)
	return c:IsFusionSetCard(0x10cf) and c:IsFusionType(TYPE_RITUAL)
end
function cm.ffilter2(c)
	return c:IsFusionSetCard(0xdd) and c:IsFusionType(TYPE_FUSION)
end
