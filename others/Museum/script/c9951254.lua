--宫本武藏
function c9951254.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_EARTH),2,99,c9951254.lcheck)
	c:EnableReviveLimit()
  --attack twice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetValue(6)
	c:RegisterEffect(e2)
 --disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c9951254.discon)
	e3:SetOperation(c9951254.disop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetTarget(c9951254.distg)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e7)
 --attack cost
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_ATTACK_COST)
	e8:SetCost(c9951254.atcost)
	e8:SetOperation(c9951254.atop)
	c:RegisterEffect(e8)
 --atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951254,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(c9951254.atkop1)
	c:RegisterEffect(e1)
 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951254.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951254.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951254,0))
end
function c9951254.lcheck(g,lc)
	return g:IsExists(Card.IsAttackAbove,1,nil,2000)
end
function c9951254.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsControler(tp)
end
function c9951254.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	if not c then return false end
	if c:IsControler(1-tp) then c=Duel.GetAttacker() end
	return c and c9951254.cfilter(c,tp)
end
function c9951254.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
	tc:RegisterFlagEffect(9951254,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
end
function c9951254.distg(e,c)
	return c:GetFlagEffect(9951254)~=0
end
function c9951254.atcost(e,c,tp)
	return Duel.CheckLPCost(1-tp,1000)
end
function c9951254.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(1-tp,1000)
end
function c9951254.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951254,0))
end