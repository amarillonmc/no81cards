--炼金生命体·善良
if not pcall(function() require("expansions/script/c10115001") end) then require("script/c10115001") end
local m=10115010
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.spcon)
	local e2=rsab.MaterialGainEffectFun(c,m,"des,sp",rstg.target(rsop.list({cm.desfilter,"des",true},{cm.spfilter,"sp",LOCATION_HAND+LOCATION_GRAVE })),cm.matop)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3330) and not c:IsCode(m)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(cm.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function cm.desfilter(c)
	return c:IsDestructable() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x3330) and c:IsLevel(4) and not c:IsCode(m)
end
function cm.matop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or Duel.Destroy(c,REASON_EFFECT)<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,math.min(ft,2),nil,e,tp)
	if #sg>0 then
		rssf.SpecialSummon(sg)
	end
end