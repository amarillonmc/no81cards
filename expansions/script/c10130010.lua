--幻层驱动 超Ψ构筑
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local m=10130010
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rscf.SetSummonCondition(c,true)
	local e2=rsef.QO(c,nil,{m,1},{1,m},"pos",nil,LOCATION_MZONE,nil,rscost.cost(Card.IsCanTurnSet,{nil,cm.fun}),nil,cm.op)
	local e3,e4=rsqd.FlipFun2(c,m,"des,rm",nil,rsop.target(Card.IsAbleToRemove,"des,rm",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.desop2)
	cm.QuantumDriver_EffectList={e3,e2}
end
function cm.fun(g,e,tp)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local e1=rsef.FC({c,tp},EVENT_PHASE+PHASE_END,{m,0},1,nil,nil,cm.descon,cm.desop,{rsreset.pend,2})
	e1:SetLabel(Duel.GetTurnCount())
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
function cm.descon(e,tp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP)
end
function cm.desop(e,tp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.desop2(e,tp)
	rsof.SelectHint(tp,"des")
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
	end
end