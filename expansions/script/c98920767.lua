--暗黑武装龙·雷电
function c98920767.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920767,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c98920767.spcon)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920767,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c98920767.cost)
	e3:SetTarget(c98920767.target)
	e3:SetOperation(c98920767.activate)
	c:RegisterEffect(e3)	
end
function c98920767.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.GetMatchingGroupCount(c98920767.sfilter,c:GetControler(),LOCATION_GRAVE,0,nil)>=5
end
function c98920767.sfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) or c:IsSetCard(0x111)
end
function c98920767.costfilter(c)
	return (c:IsAttribute(ATTRIBUTE_DARK)or c:IsSetCard(0x111)) and c:IsAbleToRemoveAsCost()
end
function c98920767.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920767.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98920767.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetFirst():IsSetCard(0x41) then e:SetLabel(100) end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c98920767.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if e:GetLabel()==100 then 	
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c98920767.thfilter2(c)
	return c:IsSetCard(0x111,0x41) and c:IsAbleToHand()
end
function c98920767.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		local g2=Duel.GetMatchingGroup(c98920767.thfilter2,tp,LOCATION_DECK,0,nil)
		if e:GetLabel()==100 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98920767,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g2:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end