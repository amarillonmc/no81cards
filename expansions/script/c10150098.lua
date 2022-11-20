--超魔导龙骑士-青眼龙骑士
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10150098)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,46986414,89631139,true,true)
	local e1=rsef.SV_IMMUNE_EFFECT(c,rsval.imntg1)
	local e2=rsef.SV_INDESTRUCTABLE(c,"battle")
	local e3=rsef.QO(c,nil,{m,0},1,"rm,atk","tg",LOCATION_MZONE,nil,nil,rstg.target(Card.IsAbleToRemove,"rm",0,LOCATION_ONFIELD),cm.rmop)
	local e4=rsef.QO(c,nil,{m,1},nil,"sp",nil,LOCATION_MZONE,nil,rscost.cost(cm.cfilter,"td"),rsop.target(cm.spfilter,"sp",rsloc.hdg),cm.spop)
end
function cm.rmop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	local tc=rscf.GetTargetCard()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_REMOVED) and c then
		local e1=rscf.QuickBuff(c,"atk+",1000)
	end
end
function cm.cfilter(c,e,tp)
	return c:IsAbleToExtraAsCost() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x10a2,0xdd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.gcheck(g)
	if #g==1 then return true end 
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	return (tc1:IsSetCard(0x10a2) and tc2:IsSetCard(0xdd)) or (tc2:IsSetCard(0x10a2) and tc1:IsSetCard(0xdd))
end
function cm.spop(e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,rsloc.hdg,0,nil,e,tp)
	if #g>0 then
		rshint.Select(tp,"sp")
		local sg=g:SelectSubGroup(tp,cm.gcheck,false,1,math.min(ft,2))
		rssf.SpecialSummon(sg)
	end
end