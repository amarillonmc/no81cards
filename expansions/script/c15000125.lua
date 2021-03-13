local m=15000125
local cm=_G["c"..m]
cm.name="永无出路的童话故事"
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--You cannot escape
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.thfilter(c,tp)
	return c:GetPreviousControler()~=tp and bit.band(LOCATION_MZONE,c:GetPreviousLocation())~=0 and bit.band(TYPE_MONSTER,c:GetPreviousTypeOnField())~=0 and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ag=eg:Filter(cm.thfilter,nil,tp)
	return ag:GetCount()~=0
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ag=eg:Filter(cm.thfilter,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,ag,1,0,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local ag=eg:Filter(cm.thfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local g=ag:Select(1-tp,1,1,nil)
	Duel.HintSelection(g)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end