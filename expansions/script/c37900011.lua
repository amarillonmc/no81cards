--黑白魔法使
function c37900011.initial_effect(c)
	aux.AddXyzProcedure(c,nil,6,2,c37900011.ovfilter,aux.Stringid(37900011,0),2,c37900011.xyzop)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c37900011.cost)
	e1:SetTarget(c37900011.tg)
	e1:SetOperation(c37900011.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x389))
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x389))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c37900011.tg4)
	e4:SetOperation(c37900011.op4)
	c:RegisterEffect(e4)	
end
function c37900011.ovfilter(c)
	return c:IsFaceup() and c:IsCode(37900096)
end
function c37900011.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,37900011)==0 end
	Duel.RegisterFlagEffect(tp,37900011,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c37900011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c37900011.recfilter(c)
	local atk,def = c:GetAttack(),c:GetDefense()
	if def <= 0 then def = 0 end
	return c:IsFaceup() and atk+def > 0
end
function c37900011.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c37900011.recfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c37900011.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c37900011.recfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
	local atk,def = g:GetFirst():GetAttack(),g:GetFirst():GetDefense()		
	Duel.Recover(tp,atk+def,REASON_EFFECT)
	end
end
function c37900011.mtfilter(c)
	return c:IsSetCard(0x389) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c37900011.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c37900011.mtfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c37900011.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c37900011.mtfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end