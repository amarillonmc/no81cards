function c10111142.initial_effect(c)
	aux.AddCodeList(c,10111128)
	--fusion material
	c:EnableReviveLimit()
	--material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x8),2,true)	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c10111142.splimit)
	c:RegisterEffect(e0)
    	--double attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
    	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111142,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10111128)
	e2:SetCondition(c10111142.atkcon)
	e2:SetCost(c10111142.atkcost)
	e2:SetOperation(c10111142.atkop)
	c:RegisterEffect(e2)
    	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,101111420)
	e3:SetCondition(c10111142.spcon)
	e3:SetTarget(c10111142.sptg)
	e3:SetOperation(c10111142.spop)
	c:RegisterEffect(e3)
end
c10111142.fusion_effect=true
function c10111142.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc:IsCode(10111128)
end
function c10111142.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle()
end
function c10111142.atkcfilter(c)
	return c:IsLevelBelow(6) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x8) and c:IsAbleToGraveAsCost()
end
function c10111142.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111142.atkcfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c10111142.atkcfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	e:SetLabel(tc:GetLevel())
end
function c10111142.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local val=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		bc:RegisterEffect(e1)
	end
end
function c10111142.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c10111142.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10111143,0x9008,TYPES_TOKEN_MONSTER,2000,2000,6,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c10111142.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,10111143,0x9008,TYPES_TOKEN_MONSTER,2000,2000,6,RACE_FIEND,ATTRIBUTE_DARK) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,10111143)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end