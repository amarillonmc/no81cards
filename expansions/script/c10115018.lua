--炼金生命体·始源
if not pcall(function() require("expansions/script/c10115001") end) then require("script/c10115001") end
local m=10115018
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	c:EnableReviveLimit()
	local e1=rsef.STO(c,EVENT_DESTROYED,{m,1},{1,m},"dr","de,dsp,ptg",rsab.descon,nil,cm.drtg,cm.drop)
end
function cm.matfilter(c)
	return c:IsLinkSetCard(0x3330) and not c:IsLinkCode(m)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
