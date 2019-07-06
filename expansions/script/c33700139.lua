--努力吧台服务员 乌贼娘
function c33700139.initial_effect(c)
	 --lv up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700139,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCost(c33700139.cost)
	e1:SetOperation(c33700139.op1)
	c:RegisterEffect(e1)
	--atk
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(33700139,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetOperation(c33700139.op2)
	c:RegisterEffect(e2)
	--atk2
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(33700139,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetOperation(c33700139.op3)
	c:RegisterEffect(e3)
end
function c33700139.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_TOKEN) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	 local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_TOKEN)
	Duel.Release(g,REASON_COST)
end
function c33700139.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(1)
		c:RegisterEffect(e1)
	end
end
function c33700139.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function c33700139.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(500)
		c:RegisterEffect(e1)
	end
end