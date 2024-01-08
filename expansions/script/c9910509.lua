--桃绯咒具 不知火
function c9910509.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c9910509.target)
	e1:SetOperation(c9910509.operation)
	c:RegisterEffect(e1)
	--atk,attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c9910509.val)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e3)
	--Equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c9910509.eqlimit)
	c:RegisterEffect(e4)
	--atk down
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c9910509.atkop)
	c:RegisterEffect(e5)
	if c9910509.counter==nil then
		c9910509.counter=true
		c9910509[0]=0
		c9910509[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c9910509.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_RELEASE)
		e3:SetOperation(c9910509.addcount)
		Duel.RegisterEffect(e3,0)
	end
end
function c9910509.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c9910509[0]=0
	c9910509[1]=0
end
function c9910509.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_MZONE) or (tc:IsPreviousLocation(LOCATION_HAND) and tc:IsType(TYPE_MONSTER)) then
			local p=tc:GetPreviousControler()
			c9910509[p]=c9910509[p]+1
		end
		tc=eg:GetNext()
	end
end
function c9910509.eqlimit(e,c)
	return c:IsType(TYPE_RITUAL) and c:IsRace(RACE_WARRIOR)
end
function c9910509.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsRace(RACE_WARRIOR)
end
function c9910509.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9910509.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910509.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9910509.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9910509.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c9910509.val(e,c)
	return c9910509[e:GetHandlerPlayer()]*500
end
function c9910509.atkfilter(c,tp)
	return c:GetEquipCount()>0 and c:IsControler(tp)
end
function c9910509.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a or not d then return end
	if not c9910509.atkfilter(a,tp) then a,d=d,a end
	if not c9910509.atkfilter(a,tp) or d:IsControler(tp) or not d:IsRelateToBattle() then return end
	local atk=d:GetBaseAttack()
	local def=d:GetBaseDefense()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BATTLE_ATTACK)
	e1:SetValue(math.ceil(atk/2))
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	d:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BATTLE_DEFENSE)
	e2:SetValue(math.ceil(def/2))
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	d:RegisterEffect(e2,true)
end
