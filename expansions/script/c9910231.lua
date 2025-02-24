--天空漫步者-起降台
function c9910231.initial_effect(c)
	c:SetUniqueOnField(1,0,9910231)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--link
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e2:SetValue(LINK_MARKER_TOP)
	c:RegisterEffect(e2)
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910231,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6956))
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOEXTRA)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c9910231.tdcon)
	e4:SetTarget(c9910231.tdtg)
	e4:SetOperation(c9910231.tdop)
	c:RegisterEffect(e4)
end
function c9910231.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9910231.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
		and Duel.IsExistingMatchingCard(c9910231.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c:GetLink())
end
function c9910231.tdfilter(c,lk)
	return c:IsType(TYPE_LINK) and c:GetLink()<lk and c:IsAbleToDeck()
end
function c9910231.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9910231.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910231.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c9910231.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g1:GetFirst()
	local g2=Duel.GetMatchingGroup(c9910231.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tc:GetLink())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,g2:GetCount(),0,0)
end
function c9910231.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c9910231.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tc:GetLink())
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
