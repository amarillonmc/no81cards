--超古代生物 美尔巴
if not pcall(function() require("expansions/script/c25000024") end) then require("script/c25000024") end
local m,cm=rscf.DefineCard(25000028)
function cm.initial_effect(c)
	local e1,e2,e3=rsoc.SpSummonFun(c,m,1,"dr","ptg",rsop.target(cm.drct,"dr"),cm.drop)
	local e4=rsoc.TributeFun(c,m,"tg","tg",rstg.target(cm.tgfilter,"tg",0,LOCATION_ONFIELD),cm.tgop)
end
function cm.drct(e,tp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
end
function cm.drop(e,tp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,p,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if ct>0 then
		Duel.Draw(p,ct,REASON_EFFECT)
	end
end
function cm.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function cm.tgop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then Duel.SendtoGrave(tc,REASON_EFFECT) end
end
