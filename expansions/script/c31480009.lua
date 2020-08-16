local m=31480009
local cm=_G["c"..m]
cm.name="神欲大宇宙"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.actcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTargetRange(0xff,0)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetCondition(cm.con)
	e2:SetLabel(0)
	c:RegisterEffect(e2)
	local e3=Effect.Clone(e2)
	e3:SetTargetRange(0,0xff)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_MOVE)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,0x1313)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return not Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,0x1313) end
	if e:GetLabel()==1 then return not Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil,0x1313) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_GRAVE) and not c:IsLocation(LOCATION_DECK) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		local lp=Duel.GetLP(c:GetControler())
		Duel.Recover(c:GetControler(),1000,REASON_EFFECT)
	end
end