--天基兵器轨道
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
--e1
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFieldGroup(tp,32,0):Filter(Card.IsSetCard,nil,0x564):Filter(Card.IsFaceup,nil):Filter(Card.IsType,nil,1):GetClassCount(Card.GetCode)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTargetRange(1,0)
	e1:SetValue(n)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(cm.op1_val)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.op1_val(e,re,dam,r,rp,rc)
	local n=Duel.GetFieldGroup(e:GetHandler():GetControler(),32,0):Filter(Card.IsSetCard,nil,0x564):FilterCount(Card.IsFaceup,nil)
	dam=dam-n*500
	return dam>0 and dam or 0
end
