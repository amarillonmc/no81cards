--虹色·彩虹犬.
if not pcall(function() require("expansions/script/c10170001") end) then require("script/c10170001") end
local m=10170002
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2=rssp.PendulumAttribute(c,"set")
	local e3,e4=rssp.ChangeOperationFun(c,m,false,cm.con,cm.op)
	local e5=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.spcon,cm.spop)
end
function cm.con(e,tp)
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,e,tp)
end
function cm.spfilter(c,e,tp)
	return (c:IsType(TYPE_PENDULUM) or c:IsLocation(LOCATION_HAND)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.op(e,tp)
	rsof.SelectHint(tp,"sp")
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil,e,tp)
	if #g>0 then
		if g:GetFirst():IsLocation(LOCATION_PZONE) then
			Duel.HintSelection(g)
		end
		rssf.SpecialSummon(g)
	end
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil)
end
function cm.cfilter(c)
	return not c:IsPublic() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.spop(e,tp)
	rsof.SelectHint(tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
end