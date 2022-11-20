--灰烬人
if not pcall(function() require("expansions/script/c10171001") end) then require("script/c10171001") end
local m,cm=rscf.DefineCard(10171002)
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_HAND+LOCATION_GRAVE,nil,rsds.cost2(1),rsop.target(rscf.spfilter2(),"sp"),cm.spop)
	local e2=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,1},nil,"se,th","de,dsp",nil,rscost.reglabel(100),rsop.target2(cm.fun,cm.thfilter,"th",rsloc.dg),cm.thop)
	local e3=rsef.RegisterClone(c,e2,"code",EVENT_SPSUMMON_SUCCESS)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.thfilter(c,e,tp)
	return c:IsCode(m-1) and c:IsAbleToHand() and (c:IsLocation(LOCATION_DECK) or Duel.IsPlayerAffectedByEffect(tp,10171024))
end
function cm.fun(g,e,tp)
	local c=e:GetHandler()
	local op=rsop.SelectOption(tp,true,{m,2},c:IsReleasable() and e:GetLabel()==100,{m,3})
	e:SetLabel(0)
	if op==2 then
		Duel.Release(c,REASON_COST)
		e:SetValue(2)
	else
		e:SetValue(1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp)
	local c=e:GetHandler()
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,rsloc.dg,0,1,e:GetValue(),nil,{},e,tp)
end