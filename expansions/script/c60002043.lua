--Re_SURGUM 伤痛与远行
local m=60002043
local cm=_G["c"..m]
cm.name="Re:SURGUM 伤痛与远行"
function c60002043.initial_effect(c)
	--no solve
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCondition(cm.nscon)
	e1:SetOperation(cm.nsop)
	c:RegisterEffect(e1)
end
function cm.nscon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetControler()==1-tp and re:IsActiveType(TYPE_SPELL)
end
function cm.nsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeChainOperation(ev,cm.repop) 
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
end