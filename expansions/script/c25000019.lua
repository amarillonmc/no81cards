--斯菲亚合成兽 新乔莫斯
if not pcall(function() require("expansions/script/c25000011") end) then require("script/c25000011") end
local m,cm=rscf.DefineCard(25000019)
function cm.initial_effect(c)
	local e1,e2,e3,e4=rsgs.FusProcFun(c,m,TYPE_FUSION,"se,th",nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e5=rsef.QO(c,nil,{m,0},{1,m},"des,dam","tg",LOCATION_MZONE,nil,nil,rstg.target({aux.TRUE,"des",0,LOCATION_ONFIELD},rsop.list(nil,"dam",0,1000)),cm.desop)
end
function cm.thfilter(c)
	return c:IsSetCard(0xaf2) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.desop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end 
end
