--古代龙的昔毅
if not pcall(function() require("expansions/script/c40009451") end) then require("script/c40009451") end
local m,cm = rscf.DefineCard(40009461)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,EVENT_CHAINING,nil,nil,"neg,des","dsp,dcal",rscon.negcon(cm.cfilter),nil,rstg.negtg("des"),rsop.negop("des"))
	local e2=rsef.FTO(c,EVENT_TO_GRAVE,"set",{m,1},nil,"de",LOCATION_GRAVE,cm.setcon,nil,rsop.target(Card.IsSSetable),cm.setop)
end
function cm.dfilter(c,tp)
	return c:IsRace(RACE_DINOSAUR) and c:IsFaceup() and c:IsControler(tp)
end
function cm.cfilter(e,tp,re,rp,tg)
	return #tg>0 and tg:IsExists(cm.dfilter,1,nil,tp)
end
function cm.sfilter(c)
	return aux.IsCodeListed(c,40009452)
end
function cm.setcon(e,tp,eg)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.sfilter,1,nil)
end
function cm.setop(e,tp)
	local c=rscf.GetSelf(e)
	if c then
		Duel.SSet(tp,c)
	end
end