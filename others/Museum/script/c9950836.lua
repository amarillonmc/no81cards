--fate·神枪李书文
function c9950836.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),4,2)
	c:EnableReviveLimit()
--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c9950836.actcon)
	e3:SetValue(c9950836.actlimit)
	c:RegisterEffect(e3)
--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950836,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c9950836.condition)
	e2:SetOperation(c9950836.operation)
	c:RegisterEffect(e2)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950836,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_BATTLE_PHASE)
	e2:SetCondition(c9950836.btcon)
	e2:SetCost(c9950836.btcost)
	e2:SetOperation(c9950836.btop)
	c:RegisterEffect(e2)
 --spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9950836,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(c9950836.spcon)
	e4:SetTarget(c9950836.sptg)
	e4:SetOperation(c9950836.spop)
	c:RegisterEffect(e4)
	--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950836.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950836.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950836,1))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950836,0))
end
function c9950836.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c9950836.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c9950836.filter(c,tc)
	if not c:IsFaceup() then return false end
	return tc:GetBaseAttack()~=c:GetAttack() or tc:GetBaseAttack()~=c:GetDefense()
end
function c9950836.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and c9950836.filter(c,bc) and bc:IsFaceup() and bc:IsRelateToBattle()
end
function c9950836.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(bc:GetBaseAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function c9950836.btcon(e,tp,eg,ep,ev,re,r,rp)
	local bt=Duel.GetAttacker()
	if bt and bt:IsControler(tp) then return true end
	bt=Duel.GetAttackTarget()
	return bt and bt:IsControler(tp)
end
function c9950836.btcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9950836.btop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
  Duel.Hint(HINT_SOUND,0,aux.Stringid(9950836,2))
end
function c9950836.spfilter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c9950836.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
		and not Duel.IsExistingMatchingCard(c9950836.spfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
end
function c9950836.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9950836.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
