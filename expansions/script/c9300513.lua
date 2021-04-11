--曾被称为龟的替身使者
function c9300513.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,c9300513.ovfilter,aux.Stringid(9300513,0),99,c9300513.xyzop)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9300513,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9300513)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c9300513.mttg)
	e1:SetOperation(c9300513.mtop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9300513,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9301513)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c9300513.thtg)
	e2:SetOperation(c9300513.thop)
	c:RegisterEffect(e2)
end
function c9300513.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1f99) and not c:IsCode(9300513)
end
function c9300513.mtfilter(c,e)
	return (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_ONFIELD)) and c:IsCanOverlay() and (c:IsType(TYPE_EQUIP) or c:IsType(TYPE_PENDULUM) or not c:IsType(TYPE_SPELL))
end
function c9300513.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c9300513.mtfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
end
function c9300513.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c9300513.mtfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c9300513.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_OVERLAY)
end
function c9300513.thop(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	if og:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local bg=og:Select(tp,1,1,nil)
		Duel.SendtoHand(bg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,bg)
	end
end



