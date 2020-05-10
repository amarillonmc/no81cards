--阿消
function c9910432.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910432)
	e1:SetTarget(c9910432.target)
	e1:SetOperation(c9910432.operation)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9910432.sumsuc)
	c:RegisterEffect(e8)
end
function c9910432.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9910432,0))
end
function c9910432.tgfilter(c,lg,tp)
	return lg:IsContains(c) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(c9910432.gyfilter,tp,0,LOCATION_ONFIELD,1,nil,c:GetColumnGroup())
end
function c9910432.gyfilter(c,g)
	return g:IsContains(c)
end
function c9910432.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c9910432.tgfilter(chkc,lg,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910432.tgfilter,tp,0,LOCATION_MZONE,1,nil,lg,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9910432.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,lg,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)	
end
function c9910432.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.IsExistingMatchingCard(c9910432.gyfilter,tp,0,LOCATION_ONFIELD,1,nil,tc:GetColumnGroup()) then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9910432,1))
end
