--反转世界的黎花 贝尔贝特
if not pcall(function() require("expansions/script/c130006013") end) then require("script/c130006013") end
local m,cm=rscf.DefineCard(130006024,"FanZhuanShiJie")
function cm.initial_effect(c)
	local e1 = rsef.QO(c,nil,"sctrl",nil,"sctrl","tg",LOCATION_HAND,nil,rscost.cost(0,"dh"),rstg.target({cm.filter,"sctrl",LOCATION_MZONE },{cm.filter2,"sctrl",0,LOCATION_MZONE }),cm.ctop)
	local e2 = rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,"rth",nil,"rth","de",LOCATION_GRAVE,nil,nil,rsop.target2(cm.fun,{cm.thfilter,"th",0,LOCATION_MZONE,true},{Card.IsAbleToHand,"th"}),cm.thop)
end
function cm.thfilter(c,e,tp,eg)
	return eg:IsContains(c) and c:IsControler(1-tp) and c:IsAbleToHand() and c:GetOwner() == tp
end
function cm.fun(g,e,tp,eg)
	Duel.SetTargetCard(eg)
end
function cm.thop(e,tp)
	local tg = rsgf.GetTargetGroup()
	local tg2 = tg:Filter(cm.thfilter,nil,e,tp,tg)
	local c = rscf.GetSelf(e)
	if not c or #tg2 <= 0 then return end
	Duel.SendtoHand(tg2 + c, nil, REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg2+c)
end
function cm.filter(c)
	local tp=c:GetControler()
	return c:IsAbleToChangeControler()
		and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function cm.filter2(c)
	local tp=c:GetControler()
	return c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local a=g:GetFirst()
	local b=g:GetNext()
	if a:IsRelateToEffect(e) and b:IsRelateToEffect(e) and Duel.SwapControl(a,b) then
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end