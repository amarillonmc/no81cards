--英豪挑战者 继承之枪兵
function c98920698.initial_effect(c)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920698,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c98920698.thcost)
	e1:SetTarget(c98920698.mattg)
	e1:SetOperation(c98920698.matop)
	c:RegisterEffect(e1)
	--get effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_XMATERIAL)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(c98920698.condition)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--get effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920698,1))
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98920698.xcon)
	e2:SetValue(c98920698.xval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_XMATERIAL)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c98920698.efilter)
	e5:SetCondition(c98920698.effcon)
	--c:RegisterEffect(e5)？
	--remove material
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98920698,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_XMATERIAL)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c98920698.rmcon)
	e6:SetOperation(c98920698.rmop)
	c:RegisterEffect(e6)
end
function c98920698.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6f) and c:IsType(TYPE_XYZ)
end
function c98920698.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920698.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920698.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c98920698.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function c98920698.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c98920698.cfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsFaceupEx()
end
function c98920698.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920698.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920698.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98920698.condition(e)
	return e:GetHandler():GetOriginalRace()==RACE_WARRIOR  
end
function c98920698.atkfilter(c)
	return c:IsCode(98920698)
end
function c98920698.xcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetHandler():GetOverlayGroup():Filter(c98920698.atkfilter,nil)
	return c:GetOriginalRace()==RACE_WARRIOR and g:GetCount()>=2 
end
function c98920698.xval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c98920698.atkfilter,nil)
	return 1500/g:GetCount()
end
function c98920698.effcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup():Filter(c98920698.atkfilter,nil)
	return e:GetHandler():GetOriginalRace()==RACE_WARRIOR and g:GetCount()>=3
end
function c98920698.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c98920698.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup():Filter(c98920698.atkfilter,nil)
	return Duel.GetTurnPlayer()~=tp and g:GetCount()>=3 and e:GetHandler():IsRace(RACE_WARRIOR)
end
function c98920698.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup():Filter(Card.IsCode,nil,tp,98920698)
	if mg:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		local bc=mg:GetFirst()
		Duel.SendtoGrave(bc,REASON_EFFECT)
   end
end