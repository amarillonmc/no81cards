--虹色·奇彩雀
if not pcall(function() require("expansions/script/c10170001") end) then require("script/c10170001") end
local m=10170004
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2=rssp.PendulumAttribute(c,"set")
	local e3,e4=rssp.ChangeOperationFun(c,m,false,cm.con,cm.op)
	local e5=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.spcon,cm.spop)
end
function cm.con(e,tp)
	return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
end
function cm.desfilter(c)
	return Duel.IsPlayerCanDraw(c:GetControler(),1)
end
function cm.op(e,tp)
	rsof.SelectHint(tp,"des")
	local dg=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e))
	if #dg>0 then
		Duel.HintSelection(dg)
		if Duel.Destroy(dg,REASON_EFFECT)>0 then
			Duel.Draw(dg:GetFirst():GetControler(),1,REASON_EFFECT)
		end
	end
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.spop(e,tp)
	rsof.SelectHint(tp,"rm")
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function cm.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end