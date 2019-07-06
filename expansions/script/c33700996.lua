--残星倩影 天破格开
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33700996
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsss.TargetFunction(c)
	rsss.NoTributeFunction(c,cm.con,cm.op)	
end
function cm.con(e,tp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
end
function cm.op(c)
	local e1=rsef.I(c,{m,0},1,"tg,dr",nil,LOCATION_MZONE,nil,nil,cm.dtg,cm.dop)
	return e1
end
function cm.cfilter(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.dop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end