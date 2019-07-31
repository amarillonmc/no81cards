--
if not pcall(function() require("expansions/script/c10170001") end) then require("script/c10170001") end
local m=10170009
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,cm.lcheck)
	local e1=rssp.LinkCopyFun(c)
	local e2=rssp.ChangeOperationFun2(c,m,false,cm.con,cm.op)
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xa333)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local bool=false
	local chain=Duel.GetCurrentChain()
	if chain<=1 then return false end
	for i=1,chain do
		local te,p=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_CONTROLER)
		if p~=tp and Duel.IsChainNegatable(i) then 
		   bool=true
		end
	end
	return bool
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	local chain=Duel.GetCurrentChain()
	for i=1,chain do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if tc:IsControler(1-tp) and Duel.NegateActivation(i) and tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) then
		   dg:AddCard(tc)
		end
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
