--太阳神·翼神龙X
function c9981614.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),10,3,c9981614.ovfilter,aux.Stringid(9981614,1))
--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9981614.efilter)
	c:RegisterEffect(e2)
--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9981614.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c9981614.defval)
	c:RegisterEffect(e2)
  --One Turn Kill
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9981614,7))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c9981614.atkcost)
	e6:SetOperation(c9981614.atkop)
	c:RegisterEffect(e6)
 --tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9981614,3))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c9981614.tgcost)
	e4:SetTarget(c9981614.tgtg)
	e4:SetOperation(c9981614.tgop)
	c:RegisterEffect(e4)
 --material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9981614,4))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c9981614.mttg)
	e4:SetOperation(c9981614.mtop)
	c:RegisterEffect(e4)
 --material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9981614,6))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c9981614.mttg2)
	e4:SetOperation(c9981614.mtop2)
	c:RegisterEffect(e4)
   --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981614.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981614.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981614,0))
end 
function c9981614.ovfilter(c)
	return c:IsFaceup() and c:IsCode(10000010)
end
function c9981614.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9981614.atkfilter(c)
	return c:GetAttack()>=0
end
function c9981614.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c9981614.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c9981614.deffilter(c)
	return c:GetDefense()>=0
end
function c9981614.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c9981614.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c9981614.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>100 end
	local lp=Duel.GetLP(tp)
	e:SetLabel(lp-100)
	Duel.PayLPCost(tp,lp-100)
end
function c9981614.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetLabel(c:GetAttack())
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetOperation(c9981614.damop)
		Duel.RegisterEffect(e2,tp)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981614,5))
end
function c9981614.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,e:GetLabel(),REASON_EFFECT)
end
function c9981614.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9981614.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_MZONE)
end
function c9981614.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981614,5))
end
function c9981614.mtfilter(c,e)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function c9981614.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c9981614.mtfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
end
function c9981614.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c9981614.mtfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c9981614.mtfilter2(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function c9981614.mttg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c9981614.mtfilter2,tp,LOCATION_GRAVE,0,1,nil) end
end
function c9981614.mtop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c9981614.mtfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end