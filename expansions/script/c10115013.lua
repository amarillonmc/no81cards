--炼金生命体 聚合缠绕体
if not pcall(function() require("expansions/script/c10115001") end) then require("script/c10115001") end
local m=10115013
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_MZONE,nil,rscost.rmxyz(1),rstg.target(rsop.list(cm.spfilter,"sp",LOCATION_HAND+LOCATION_GRAVE)),cm.spop)
	local e2=rsef.STO(c,EVENT_DESTROYED,{m,1},{1,m+100},"se,th","de,dsp",rsab.descon,nil,rstg.target(rsop.list({cm.thfilter,"th",LOCATION_HAND })),cm.thop)
end
function cm.spfilter(c,e,tp)
	return c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #sg>0 then
		rssf.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,nil,rssf.SummonBuff(nil,true))
	end
end
function cm.thfilter(c)
	return ((c:IsSetCard(0x3330) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0x3331)) and c:IsAbleToHand()
end
function cm.thcheck(g)
	return #g==1 or g:FilterCount(Card.IsSetCard,nil,0x3331)<#g 
end
function cm.thop(e,tp)
	local g1=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if #g1>0 then
		rsof.SelectHint(tp,"th")
		local tg=g1:SelectSubGroup(tp,cm.thcheck,false,1,2)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
