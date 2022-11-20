--背弃王座的薪王
if not pcall(function() require("expansions/script/c10171001") end) then require("script/c10171001") end
local m,cm=rscf.DefineCard(10171023)
function cm.initial_effect(c)
	local e1=rsds.TributeFun(c,m,"tg",nil,rsop.target(cm.tgfilter,"tg",LOCATION_DECK),cm.tgop,true)
	local e2=rsef.QO(c,nil,{m,1},{1,m+500},"sp,eq,lg","tg",LOCATION_GRAVE,nil,rscost.cost(cm.cfilter,"rm",LOCATION_GRAVE),rstg.target2(cm.fun,cm.spfilter,"sp",LOCATION_GRAVE),cm.spop)
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and (c:IsSetCard(0xa335) or c:IsCode(10171001))
end
function cm.gcheck(g)
	return g:FilterCount(Card.IsSetCard,nil,0xa335)<=1 and g:FilterCount(Card.IsCode,nil,10171001)<=1
end
function cm.tgop(e,tp)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil)
	if #g<=0 then return end
	rshint.Select(tp,"tg")
	local tg=g:SelectSubGroup(tp,cm.gcheck,false,1,2)
	Duel.SendtoGrave(tg,REASON_EFFECT)
end
function cm.cfilter(c)
	return c:IsCode(10171002) and c:IsAbleToRemoveAsCost()
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(m-1) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.spop(e,tp)
	local c,tc=aux.ExceptThisCard(e),rscf.GetTargetCard()
	if not tc or Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)<=0 or not c or not rsop.eqop(e,c,tc) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(rsval.imoe)
	e1:SetReset(rsreset.est)
	c:RegisterEffect(e1,true)
end