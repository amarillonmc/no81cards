--恶沼的泥龙王
function c98920758.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c98920758.lcheck)
	c:EnableReviveLimit()
	--fusion substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e2:SetCondition(c98920758.subcon)
	c:RegisterEffect(e2)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920758,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920758)
	e1:SetTarget(c98920758.target)
	e1:SetOperation(c98920758.operation)
	c:RegisterEffect(e1)
end
function c98920758.lcheck(g)
	local tc=g:GetFirst()
	return aux.SameValueCheck(g,Card.GetLinkAttribute) and g:GetClassCount(Card.GetLinkRace)==#g
end
function c98920758.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_MZONE+LOCATION_GRAVE)
end
function c98920758.tgfilter(c,lg)
	return lg:IsContains(c)
end
function c98920758.thfilter(c)
	return c:IsSetCard(0x46) and c:GetType()==TYPE_SPELL and c:IsAbleToHand()
end
function c98920758.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920758.tgfilter(chkc,lg) end
	if chk==0 then return Duel.IsExistingTarget(c98920758.tgfilter,tp,LOCATION_MZONE,0,1,nil,lg) and Duel.IsExistingMatchingCard(c98920758.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c98920758.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,lg)
end
function c98920758.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920758.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c98920758.damcon)
	e3:SetOperation(c98920758.damop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c98920758.damcon1)
	e2:SetOperation(c98920758.damop1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e3)
	Duel.RegisterEffect(e2,tp)
end
function c98920758.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()~=1
end
function c98920758.damop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,2000,REASON_EFFECT)
end
function c98920758.damcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function c98920758.damop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(1)
end