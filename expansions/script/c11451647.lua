--居合万钧切
--21.12.15
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentChain()==0 and not Duel.CheckPhaseActivity()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()>0 then e:SetLabel(0) return true end
		return false
	end
	Duel.SetTargetPlayer(tp)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_IAIDO = 0x6a
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,0))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,0))
	Duel.Win(p,WIN_REASON_IAIDO)
end