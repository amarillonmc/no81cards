local m=15000590
local cm=_G["c"..m]
cm.name="巳日灵君"
function cm.initial_effect(c)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(cm.rctg)
	e2:SetOperation(cm.rcop)
	c:RegisterEffect(e2)
end
function cm.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,2025)
end
function cm.rcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,2025,REASON_EFFECT)
	Duel.Recover(1-tp,2025,REASON_EFFECT)
end
