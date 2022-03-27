--归零界碑
function c9320000.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(c9320000.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--Atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetTarget(c9320000.atk)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetValue(0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e4:SetValue(0)
	c:RegisterEffect(e4)
	--set p
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c9320000.setcon)
	e5:SetTarget(c9320000.settg)
	e5:SetOperation(c9320000.setop)
	c:RegisterEffect(e5)
end
function c9320000.disable(e,c)
	return (c:IsType(TYPE_EFFECT+TYPE_SPELL+TYPE_TRAP) or c:GetOriginalType()&TYPE_EFFECT~=0)
			and not c:IsOriginalCodeRule(9320000) and e:GetHandler():GetColumnGroup():IsContains(c)
end
function c9320000.atk(e,c)
	return e:GetHandler():GetColumnGroup():IsContains(c)
end
function c9320000.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c9320000.filter(c)
	return c:GetLeftScale()==0 and not c:IsForbidden()
end
function c9320000.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c9320000.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
end
function c9320000.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c9320000.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
