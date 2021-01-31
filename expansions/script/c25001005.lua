--钢铁的假面 哥布纽•奥古玛
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25001005)
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,rsloc.hg,nil,rscost.cost({cm.tdcfilter,aux.dncheck},"td",rsloc.hg+LOCATION_REMOVED,0,2,2,c),rsop.target(rscf.spfilter2(),"sp"),cm.spop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"se,th","de,dsp",nil,rscost.reglabel(100),cm.thtg,cm.thop)
	local e3=rsef.RegisterClone(c,e2,"code",EVENT_SUMMON_SUCCESS)
	local e4=rsef.STO(c,EVENT_LEAVE_FIELD,{m,1},{1,m+200},"se,th","de,dsp",cm.lcon,nil,rsop.target(cm.thfilter2,"th",rsloc.dg+LOCATION_REMOVED),cm.thop2)
end
function cm.lcon(e,tp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function cm.thfilter2(c)
	return c:IsCode(m-1) and c:IsAbleToHand() and c:RemovePosCheck()
end
function cm.thop2(e,tp)
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter2),tp,rsloc.dg+LOCATION_REMOVED,0,1,1,nil,{})
end
function cm.tdcfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToDeckOrExtraAsCost() and c:RemovePosCheck()
end
function cm.spop(e,tp)
	local c=rscf.GetSelf(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.cfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToRemoveAsCost()
end
function cm.gfilter(g,tp)
	return g:GetClassCount(Card.GetCode)==1 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,g,g:GetFirst():GetCode())
end
function cm.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand() and c:IsRace(RACE_MACHINE)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return e:GetLabel()==100 and g:CheckSubGroup(cm.gfilter,2,2,tp) end
	e:SetLabel(0)
	rshint.Select(tp,"rm")
	local rg=g:SelectSubGroup(tp,cm.gfilter,false,2,2,tp)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetValue(rg:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp)
	local code=e:GetValue()
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{},code)
end