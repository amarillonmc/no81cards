--炼金生命体·混乱
if not pcall(function() require("expansions/script/c10115001") end) then require("script/c10115001") end
local m=10115009
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"se,th","de,dsp",nil,nil,rstg.target(rsop.list(cm.thfilter,"th",LOCATION_DECK)),cm.thop)
	local e3=rsef.RegisterClone(c,e1,"code",EVENT_SUMMON_SUCCESS)
	local e2=rsab.MaterialGainEffectFun(c,m,"des,sp",rstg.target(rsop.list({cm.desfilter,"des",true},{cm.spfilter,"sp",LOCATION_DECK })),cm.matop)
end
function cm.thfilter(c)
	return c:IsSetCard(0x3331) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function cm.desfilter(c)
	return c:IsDestructable() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x3330) and not c:IsCode(m)
end
function cm.matop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or Duel.Destroy(c,REASON_EFFECT)<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg>0 then
		rssf.SpecialSummon(sg)
	end
end