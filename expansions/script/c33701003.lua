--那残星倩影却在灯火阑珊处
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33701003
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsss.TargetFunction(c)
	local e1=rsef.ACT(c)
	local e2=rsss.ActFieldFunction(c,m)
	local e3=rsef.FTO(c,EVENT_TO_GRAVE,{m,1},nil,"th","de",LOCATION_FZONE,nil,nil,rstg.target2(cm.fun,{cm.cfilter,"th",LOCATION_GRAVE,0,1,true}),cm.thop)
end
function cm.fun(g)
	Duel.SetTargetCard(g)
end
function cm.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsContains(c) then return false end
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0x144d) and c:IsAbleToHand() and re and re:GetHandler()==c
end
function cm.thop(e,tp,eg)
	local tg=rsgf.GetTargetGroup()
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end