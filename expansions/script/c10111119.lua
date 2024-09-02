function c10111119.initial_effect(c)
	c:SetUniqueOnField(1,0,10111119)
	c:EnableReviveLimit()
	--fusion summon
	aux.AddFusionProcFunRep(c,c10111119.ffilter,2,true)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10111119.splimit)
	c:RegisterEffect(e1)
    	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111119,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,10111119)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10111119.sptg)
	e2:SetOperation(c10111119.spop)
	c:RegisterEffect(e2)
 	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c10111119.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
end
function c10111119.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x2b) and (not sg or not sg:IsExists(Card.IsRace,1,c,c:GetRace()))
end
function c10111119.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c10111119.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,39972130,0,TYPES_TOKEN_MONSTER,-2,0,1,RACE_BEAST,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10111119.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,39972130,0,TYPES_TOKEN_MONSTER,-2,0,1,RACE_BEAST,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,39972130)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		local g,atk=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetMaxGroup(Card.GetAttack)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function c10111119.ifilter(c)
	return c:IsFaceup() and c:IsCode(10111118)
end
function c10111119.indcon(e)
	return Duel.IsExistingMatchingCard(c10111119.ifilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end