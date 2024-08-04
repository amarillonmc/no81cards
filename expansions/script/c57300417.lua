--pvz bt z 超新星僵尸
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	Zombie_Characteristics_EX(c,600)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x33) and not c:IsCode(2009101)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(s.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetLabel(tc:GetOriginalCode())
		e1:SetTargetRange(0,1)
		e1:SetValue(s.actlimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetLabel(tc:GetOriginalCode())
		e2:SetProperty(0,EFFECT_FLAG2_WICKED)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetTarget(s.atktg)
		e2:SetValue(s.atkval)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.actlimit(e,re,tp)
	return re:GetHandler():IsOriginalCodeRule(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end
function s.atktg(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
function s.atkval(e,c)
	return 0
end