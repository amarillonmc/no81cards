--调莺
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174077)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	local e1=rsef.I(c,{m,0},1,"lv",nil,LOCATION_MZONE,nil,nil,rsop.target(aux.FilterBoolFunction(Card.IsLevelAbove,1),nil),cm.lvop)
	local e2=rsef.FTF(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"lv",nil,LOCATION_MZONE,nil,nil,rsop.target2(cm.fun,cm.cfilter,"dum",LOCATION_MZONE,LOCATION_MZONE),cm.sumop)
end
function cm.lvop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if not c then return end
	local op=rsop.SelectOption(tp,true,{m,1},c:IsLevelAbove(2),{m,2})
	local lv=op==1 and 1 or -1
	local e1= rscf.QuickBuff(c,"lv+",lv)
end
function cm.cfilter(c,e,tp,eg)
	local ec=e:GetHandler()
	return eg:IsContains(c) and c:IsFaceup() and ec:IsLevelAbove(1) and not c:IsLevel(ec:GetLevel()) and not eg:IsContains(ec)
end
function cm.fun(g,e,tp,eg)
	Duel.SetTargetCard(eg)
end 
function cm.sumop(e,tp)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local tg=rsgf.GetTargetGroup(Card.IsFaceup)
	for tc in aux.Next(tg) do
		if not tc:IsLevel(lv) then
			rscf.QuickBuff({c,tc},"lv",lv)
		end
	end
end