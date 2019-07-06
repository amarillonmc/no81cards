--铁虹的补给兵
if not pcall(function() require("expansions/script/c33700720") end) then require("script/c33700720") end
local m=33700721
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsneov.TunerFun(c,1200)
	rsneov.RDTurnFun(c,CATEGORY_DRAW,nil,900,cm.tg,cm.op)   
	rsneov.LPChangeFun(c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end