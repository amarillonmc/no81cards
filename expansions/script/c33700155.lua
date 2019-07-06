--甜蜜狂欢领导人
function c33700155.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--lp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700155,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(c33700155.cost)
	e1:SetTarget(c33700155.tg)
	e1:SetOperation(c33700155.op)
	c:RegisterEffect(e1)
end
function c33700155.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33700155.filter(c)
	return c:IsFaceup() 
end
function c33700155.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c33700155.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33700155.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33700155.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c33700155.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(c33700155.lpop)
	e1:SetDescription(aux.Stringid(33700155,1))
	e1:SetReset(RESET_EVENT+0x1ff0000)
	tc:RegisterEffect(e1)
   if not tc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
	end
end
end
function c33700155.lpop(e,tp,eg,ep,ev,re,r,rp)
   if e:GetHandler():GetAttack()>0 then
	Duel.Recover(tp,e:GetHandler():GetAttack(),REASON_EFFECT,true)
   Duel.Recover(1-tp,e:GetHandler():GetAttack(),REASON_EFFECT,true)
   Duel.RDComplete()
end
end