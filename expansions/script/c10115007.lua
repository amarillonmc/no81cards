--炼金生命体·中立
if not pcall(function() require("expansions/script/c10115001") end) then require("script/c10115001") end
local m=10115007
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"sum","de,dsp",nil,nil,rstg.target(rsop.list(cm.sumfilter,"sum",LOCATION_HAND)),cm.sumop)
	local e3=rsef.RegisterClone(c,e1,"code",EVENT_SUMMON_SUCCESS)
	local e2=rsab.MaterialGainEffectFun(c,m,"des,th",rstg.target(rsop.list({Card.IsDestructable,"des",true},{cm.thfilter,"th",LOCATION_HAND })),cm.matop)
end
function cm.sumfilter(c,e,tp)
	return c:IsSetCard(0x3330) and c:IsSummonable(true,nil)
end
function cm.sumop(e,tp)
	rsof.SelectHint(tp,"sum")
	local sc=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if sc then
		Duel.Summon(tp,sc,true,nil)
	end
end
function cm.thfilter(c)
	return ((c:IsSetCard(0x3330) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0x3331)) and c:IsAbleToHand()
end
function cm.thcheck(g)
	return #g==1 or g:FilterCount(Card.IsSetCard,nil,0x3331)<#g 
end
function cm.matop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or Duel.Destroy(c,REASON_EFFECT)<=0 then return end
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,nil)
	if #g1>0 then
		rsof.SelectHint(tp,"th")
		local tg=g1:SelectSubGroup(tp,cm.thcheck,false,1,2)
		Duel.HintSelection(tg)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end