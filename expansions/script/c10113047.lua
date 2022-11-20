--超量单车
function c10113047.initial_effect(c)
	--xyzm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10113047,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,10113047)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c10113047.macon)
	e1:SetTarget(c10113047.matg)
	e1:SetOperation(c10113047.maop)
	c:RegisterEffect(e1)   
	--xyzm2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113047,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10113147)
	e2:SetCost(c10113047.macost)
	e2:SetTarget(c10113047.matg2)
	e2:SetOperation(c10113047.maop)
	c:RegisterEffect(e2)   
end
function c10113047.cfilter(c)
	return c:IsCode(10113047) and c:IsAbleToRemoveAsCost()
end
function c10113047.macost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c10113047.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10113047.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10113047.mafilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0
end
function c10113047.matg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10113047.mafilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10113047.mafilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10113047.mafilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10113047.macon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c10113047.mafilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c10113047.matg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10113047.mafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10113047.mafilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10113047.mafilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10113047.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
	   Duel.Overlay(tc,Group.FromCards(c))
	end
end