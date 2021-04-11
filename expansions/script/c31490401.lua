local m=31490401
local cm=_G["c"..m]
cm.name="圣燧烽主教 神火"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(cm.splimcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(cm.changeop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.recovercon_1)
	e3:SetOperation(cm.recoverop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCondition(cm.recovercon_2)
	e4:SetOperation(cm.recoverop)
	c:RegisterEffect(e4)
end
function cm.splimcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsPublic,tp,LOCATION_HAND,0,nil)
	return g:GetCount()~=g:GetClassCount(Card.GetCode)
end
function cm.changeop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or Duel.GetLP(tp)<=1500 or Duel.GetLP(tp)<Duel.GetLP(1-tp) then return end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.rep_op)
end
function cm.rep_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-1500)
end
function cm.recovercon_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.recovercon_2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.recoverop(e,tp,eg,ep,ev,re,r,rp)
	local num1=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,0,nil,POS_FACEUP):FilterCount(Card.IsSetCard,nil,0x9310)
	local num2=Duel.GetMatchingGroup(Card.IsPublic,tp,LOCATION_HAND,0,nil):FilterCount(Card.IsSetCard,nil,0x9310)
	Duel.Recover(tp,(num1+num2)*500,REASON_EFFECT)
end