local m=53799270
local cm=_G["c"..m]
cm.name="遏止"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,1))
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(cm.con)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(m)
	e2:SetCost(cm.cost)
	c:RegisterEffect(e2)
end
function cm.con(e,tp)
	Duel.DisableActionCheck(true) 
	local dc=Duel.CreateToken(1-tp,m)
	local res=dc:GetActivateEffect():IsActivatable(1-tp,false,false)
	Duel.DisableActionCheck(false) 
	return res
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.RaiseSingleEvent(e:GetHandler(),m,re,r,1-tp,1-tp,ev)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	e:SetType(EFFECT_TYPE_ACTIVATE)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(cm.reset)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e:Reset()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,g:GetFirst():GetAttack())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Recover(1-tp,tc:GetAttack(),REASON_EFFECT)
	end
end
