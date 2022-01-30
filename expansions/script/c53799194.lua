local m=53799194
local cm=_G["c"..m]
cm.name="里世界的收录 MGR和怪物YUH"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)return c:IsLocation(LOCATION_HAND) and c:IsLevelAbove(5)end)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsPreviousLocation(LOCATION_MZONE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(cm.negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not Duel.IsChainDisablable(ev) or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateEffect(ev)
	e:Reset()
end
