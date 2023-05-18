--时间潜行者 监察者
function c98920333.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c98920333.lcheck)
	c:EnableReviveLimit()
	--xyz
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920333,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920333)
	e1:SetTarget(c98920333.target)
	e1:SetOperation(c98920333.operation)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,98930333)
	e1:SetCondition(c98920333.condition)
	e1:SetTarget(c98920333.target1)
	e1:SetOperation(c98920333.activate)
	c:RegisterEffect(e1)
end
function c98920333.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x126)
end
function c98920333.tgfilter(c,lg)
	return lg:IsContains(c) and c:IsType(TYPE_XYZ)
end
function c98920333.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920333.tgfilter(chkc,lg) end
	if chk==0 then return Duel.IsExistingTarget(c98920333.tgfilter,tp,LOCATION_MZONE,0,1,nil,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c98920333.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,lg)
end
function c98920333.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_GRAVE,1,1,nil,tc)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
function c98920333.toexfilter(c,tp)
	return c:GetOwner()~=tp
end
function c98920333.filter(c,cg,tp)
	local mg=c:GetOverlayGroup()
	return cg:IsContains(c) and c:IsFaceup() and c:GetOverlayCount()>0 and mg:IsExists(c98920333.toexfilter,1,nil,tp) 
end
function c98920333.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c98920333.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920333.filter(chkc,cg,tp) end
	if chk==0 then return Duel.IsExistingTarget(c98920333.filter,tp,LOCATION_MZONE,0,1,nil,cg,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c98920333.filter,tp,LOCATION_MZONE,0,1,1,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c98920333.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetOverlayGroup()
	local g=mg:FilterSelect(tp,c98920333.toexfilter,1,1,nil,e,tp)
	if tc:IsLocation(LOCATION_MZONE) then
	   Duel.SendtoGrave(g,REASON_EFFECT)
	   Duel.NegateActivation(ev)
	end
end