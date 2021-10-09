--鬼形兽 孤立无援造就的造形神
function c9981314.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),6,3,c9981314.ovfilter,aux.Stringid(9981314,1))
	c:EnableReviveLimit()
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,99813140)
	e1:SetTarget(c9981314.pctg)
	e1:SetOperation(c9981314.pcop)
	c:RegisterEffect(e1)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981314,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9981314.condition)
	e1:SetCost(c9981314.cost)
	e1:SetTarget(c9981314.target)
	e1:SetOperation(c9981314.operation)
	c:RegisterEffect(e1)
	 --material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9981314,3))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c9981314.mttg)
	e4:SetOperation(c9981314.mtop)
	c:RegisterEffect(e4)
	 --pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9981314,4))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,9981314)
	e6:SetTarget(c9981314.pentg)
	e6:SetOperation(c9981314.penop)
	c:RegisterEffect(e6)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981314.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
c9981314.pendulum_level=6
function c9981314.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981314,0))
end
function c9981314.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c9981314.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c9981314.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9981314.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c9981314.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c9981314.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3bd1) and c:IsType(TYPE_XYZ) and c:IsRank(4)
end
function c9981314.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2500
end
function c9981314.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9981314.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanOverlay()
end
function c9981314.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c9981314.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9981314.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c9981314.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c9981314.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981314,0))
end
function c9981314.mtfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x3bd1) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function c9981314.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c9981314.mtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
end
function c9981314.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c9981314.mtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981314,0))
end
function c9981314.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c9981314.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981314,0))
end
