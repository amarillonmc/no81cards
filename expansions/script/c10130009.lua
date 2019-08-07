--幻层驱动 超Ω构筑
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local m=10130009
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rscf.SetSummonCondition(c,true)
	local e2=rsef.QO(c,nil,{m,1},{1,m},"pos",nil,LOCATION_MZONE,nil,rscost.cost(Card.IsCanTurnSet,{nil,cm.fun}),nil,cm.op)
	local e3,e4=rsqd.FlipFun2(c,m,"dr","ptg",cm.drtg,cm.drop)
	cm.QuantumDriver_EffectList={e3,e2}
end
function cm.fun(g,e,tp)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
function cm.op(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetTargetRange(0,LOCATION_HAND)
	e1:SetReset(rsreset.pend,2)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		rsqd.ShuffleOp(e,tp)
		rsof.SelectHint(1-tp,"pos")
		local tg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(tg)
		Duel.ChangePosition(tg,POS_FACEUP_DEFENSE)
	end
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		Duel.DiscardHand(p,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
