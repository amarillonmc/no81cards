--混沌病毒-霍普
function c49951007.initial_effect(c)
--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c49951007.mfilter,c49951007.xyzcheck,2,2)  
	 --rankup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49951007,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c49951007.rkcon)
	e1:SetOperation(c49951007.rkop)
	c:RegisterEffect(e1)
	 --atk,def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetValue(c49951007.value)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(1)
	e3:SetCondition(c49951007.actcon)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49951007,2))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,49951007)
	e4:SetCondition(c49951007.atkcon)
	e4:SetCost(aux.bfgcost)
	e4:SetOperation(c49951007.atkop)
	c:RegisterEffect(e4)
end
function c49951007.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and not c:IsSetCard(0x48)
end
function c49951007.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c49951007.rkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c49951007.rkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_RANK)
		e2:SetValue(c49951007.lvval)
		c:RegisterEffect(e2)
	end
end
function c49951007.lvval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,0,nil)
	return g:GetSum(Card.GetRank)
end
function c49951007.value(e,c)
	return c:GetRank()*1000
end
function c49951007.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c49951007.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	if not ac:IsControler(tp) then ac,tc=tc,ac end
	return ac and ac:IsControler(tp) and ac:IsFaceup() and ac:IsType(TYPE_XYZ) and tc and tc:IsControler(1-tp) and tc:IsFaceup()
end
function c49951007.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c49951007.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end