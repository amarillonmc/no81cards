--青蛙之魔姬 青蛙姬
function c95101022.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,c95101022.uqfilter,LOCATION_MZONE)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c95101022.sprcon)
	e1:SetOperation(c95101022.sprop)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c95101022.tkcon)
	e2:SetTarget(c95101022.tktg)
	e2:SetOperation(c95101022.tkop)
	c:RegisterEffect(e2)
end
function c95101022.uqfilter(c)
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),95101028) then
		return c:IsCode(95101022)
	else
		return c:IsSetCard(0xbba)
	end
end
function c95101022.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,c)
	return g:GetCount()>=2 and g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==g:GetCount()
end
function c95101022.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c95101022.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c95101022.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local ct=math.min(ft1,ft2)
	if chk==0 then return ct>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,95101022+1,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,95101022+1,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct*2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct*2,0,0)
end
function c95101022.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local ct=math.min(ft1,ft2)
	if ct>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,95101022+1,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,95101022+1,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE,1-tp) then
		for i=1,ct do
			local token=Duel.CreateToken(tp,95101022+1)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			token=Duel.CreateToken(tp,95101022+1)
			Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
		end
		Duel.SpecialSummonComplete()
	end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c95101022.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
end
function c95101022.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
