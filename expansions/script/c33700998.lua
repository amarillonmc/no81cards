--残星倩影 人破格魂
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33700998
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsss.TargetFunction(c)
	rsss.NoTributeFunction(c,cm.con,cm.op)
end
function cm.con(e,tp)
	if not tp then tp=e:GetHandlerPlayer() end
	local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	return #g2>#g1,#g2-#g1
end
function cm.op(c)
	local e1=rsef.I(c,{m,0},1,"dr","ptg",LOCATION_MZONE,nil,nil,cm.dtg,cm.dop)
	return e1
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local _,ct=cm.con(e)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local _,ct=cm.con(e,p)
	if ct<=0 then return end
	Duel.Draw(p,ct,REASON_EFFECT)
end
