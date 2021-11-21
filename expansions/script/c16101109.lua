--捕兽夹
function c16101109.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16101109,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c16101109.operation)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(c16101109.disop)
	c:RegisterEffect(e2)
	--cannot set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SSET)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c16101109.con)
	e3:SetTarget(c16101109.aclimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetValue(c16101109.aclimit2)
	c:RegisterEffect(e5)
	--cannot set
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_SSET)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(1,0)
	e6:SetCondition(c16101109.con2)
	e6:SetTarget(c16101109.aclimit)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e7)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetValue(c16101109.aclimit2)
	c:RegisterEffect(e7)
end
function c16101109.operation(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_MZONE,LOCATION_MZONE,nil,RACE_SPELLCASTER)
	Duel.SendtoGrave(dg,REASON_EFFECT)
end
function c16101109.disop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) and  re:GetHandler():IsRace(RACE_SPELLCASTER) then
		Duel.NegateEffect(ev)
	end
end
function c16101109.con(e)
	return e:GetHandler():GetControler()~=e:GetHandler():GetOwner()
end
function c16101109.con2(e)
	return e:GetHandler():GetControler()==e:GetHandler():GetOwner()
end
function c16101109.aclimit(e,c)
	return c:IsType(TYPE_SPELL)
end
function c16101109.aclimit2(e,re,tp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end