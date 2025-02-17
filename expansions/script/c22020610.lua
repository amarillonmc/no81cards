--人理之基 卫宫·暗杀者
function c22020610.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xff1),1)
	c:EnableReviveLimit()
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c22020610.condition0)
	e1:SetValue(c22020610.aclimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020610,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCost(c22020610.cost)
	e2:SetCondition(c22020610.condition)
	e2:SetTarget(c22020610.target)
	e2:SetOperation(c22020610.operation)
	c:RegisterEffect(e2)
end
function c22020610.condition0(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c22020610.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c22020610.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22020610.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c22020610.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22020611,0,0x4011,1200,1200,1,RACE_SPELLCASTER,ATTRIBUTE_EARTH,POS_FACEUP_ATTACK,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c22020610.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22020611,0,0x4011,1200,1200,1,RACE_SPELLCASTER,ATTRIBUTE_EARTH,POS_FACEUP_ATTACK,1-tp) then
		local token=Duel.CreateToken(tp,22020611)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
	end
	Duel.ChainAttack()
end
