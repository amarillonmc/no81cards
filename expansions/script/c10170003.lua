--
if not pcall(function() require("expansions/script/c10170001") end) then require("script/c10170001") end
local m=10170003
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2=rssp.PendulumAttribute(c,"hand")
	local e3,e4=rssp.ChangeOperationFun(c,m,false,cm.con,cm.op)
	local e5=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.spcon)
end
function cm.con(e,tp)
	return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.thfilter(c)
	return not c:IsCode(m) and c:IsSetCard(0xa333) and c:IsAbleToHand()
end
function cm.op(e,tp)
	rsof.SelectHint(tp,"th")
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(rscf.FilterFaceUp(Card.IsSetCard,0xa333),tp,LOCATION_MZONE,0,1,nil)
end