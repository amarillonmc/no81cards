--械龙机·强袭
function c75122544.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x276),aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),2,63,true)
	--battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--attack up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c75122544.cost)
	e3:SetOperation(c75122544.operation)
	c:RegisterEffect(e3)
	--spsummon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c75122544.sucop)
	c:RegisterEffect(e4)
end
c75122544.material_setcode=0x186
function c75122544.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e1:SetValue(c:GetMaterialCount()-1)
	c:RegisterEffect(e1)
end
function c75122544.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75122544.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c75122544.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c75122544.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable() and c:IsSetCard(0x276)
end
function c75122544.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end