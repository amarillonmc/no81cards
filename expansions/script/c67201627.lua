--复转之选召者 莉兹贝尔
function c67201627.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201627,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67201627)
	e1:SetCondition(c67201627.thcon)
	e1:SetCost(c67201627.thcost)
	e1:SetTarget(c67201627.thtg)
	e1:SetOperation(c67201627.thop)
	c:RegisterEffect(e1)  
	--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67201627,3))
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c67201627.condition)
	e3:SetValue(c67201627.atkval)
	c:RegisterEffect(e3)	
end
function c67201627.condition(e)
	local tp=e:GetHandler():GetControler()
	return e:GetHandler():GetOriginalAttribute()==ATTRIBUTE_LIGHT and e:GetHandler():IsSetCard(0x367f) and Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function c67201627.atkval(e,c)
	return math.abs(Duel.GetLP(0)-Duel.GetLP(1))
end
--
function c67201627.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c67201627.thfilter(c)
	return c:IsSetCard(0x367f) and c:IsAbleToHand()
end
function c67201627.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c67201627.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.IsPlayerCanNormalDraw(tp) and Duel.IsExistingMatchingCard(c67201627.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	aux.GiveUpNormalDraw(e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
end
function c67201627.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67201627.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end