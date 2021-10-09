--魔法纪录·吴纪里香
function c9980246.initial_effect(c)
	c:SetUniqueOnField(1,0,9980246)
	c:EnableCounterPermit(0x1,LOCATION_MZONE)
	c:SetCounterLimit(0x1,5)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c9980246.acop)
	c:RegisterEffect(e3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9980246.spcon)
	c:RegisterEffect(e1)
	--atkup-c
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c9980246.atkval)
	c:RegisterEffect(e2)
	--atkdown
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980246,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c9980246.cost)
	e3:SetTarget(c9980246.target)
	e3:SetOperation(c9980246.operation)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980246.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
c9980246.counter_add_list={0x1}
function c9980246.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980246,0))
end
function c9980246.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function c9980246.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbc4)
end
function c9980246.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9980246.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c9980246.atkval(e,c)
	return c:GetCounter(0x1)*400
end
function c9980246.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x1)>0 end
	local ct=e:GetHandler():GetCounter(0x1)
	e:SetLabel(ct*400)
	e:GetHandler():RemoveCounter(tp,0x1,ct,REASON_COST)
end
function c9980246.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
end
function c9980246.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local val=e:GetLabel()
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-val)
		tc:RegisterEffect(e1)
		if val>atk then Duel.Damage(1-tp,atk,REASON_EFFECT)
		else Duel.Damage(1-tp,val,REASON_EFFECT) end
	end
end
