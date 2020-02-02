--天空漫步者-起降台
function c9910239.initial_effect(c)
	c:SetUniqueOnField(1,0,9910239)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910239,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x955))
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9910239.tdcon)
	e3:SetTarget(c9910239.tdtg)
	e3:SetOperation(c9910239.tdop)
	c:RegisterEffect(e3)
end
function c9910239.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9910239.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
		and Duel.IsExistingMatchingCard(c9910239.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c:GetLink())
end
function c9910239.tdfilter(c,ct)
	return c:IsLinkBelow(ct-1) and c:IsAbleToDeck()
end
function c9910239.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9910239.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910239.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c9910239.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g1:GetFirst()
	local g2=Duel.GetMatchingGroup(c9910239.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tc:GetLink())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,g2:GetCount(),0,0)
end
function c9910239.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c9910239.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tc:GetLink())
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
