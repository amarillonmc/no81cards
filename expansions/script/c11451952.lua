--风灵佑佐 薇茵
local cm,m=GetID()
function cm.initial_effect(c)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(cm.efilter)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabelObject(e3)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_EFFECT))
	c:RegisterEffect(e2)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	local e4=e2:Clone()
	e4:SetLabelObject(e1)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(m)
	c:RegisterEffect(e6)
end
function cm.efilter(e,te)
	if te:GetHandler():IsHasEffect(m) and te:IsHasType(EFFECT_TYPE_GRANT) then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler()) --(g:IsContains(e:GetHandler()) and #g==1)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() and not chkc:IsLocation(LOCATION_FZONE) end
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsAbleToHand() and not c:IsLocation(LOCATION_FZONE) end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectTarget(tp,function(c) return c:IsAbleToHand() and not c:IsLocation(LOCATION_FZONE) end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	local tc=tg:GetFirst()
	local g=tc:GetColumnGroup()
	g:AddCard(tc)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g=tc:GetColumnGroup()
	g:AddCard(tc)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end