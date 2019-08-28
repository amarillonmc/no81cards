--幻梦迷境 斯坦奇卡
function c65010040.initial_effect(c)
	--spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65010040)
	e1:SetCost(c65010040.spscost)
	e1:SetTarget(c65010040.spstg)
	e1:SetOperation(c65010040.spsop)
	c:RegisterEffect(e1)
	--the power
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,65010041)
	e2:SetCondition(c65010040.pwcon)
	e2:SetTarget(c65010040.pwtg)
	e2:SetOperation(c65010040.pwop)
	c:RegisterEffect(e2)
end
function c65010040.spscostfil(c)
	return c:IsSetCard(0x6da0) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end

function c65010040.spscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010040.spscostfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c65010040.spscostfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c65010040.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end

function c65010040.spsop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end

function c65010040.pwconfil(c)
	return c:IsSetCard(0x6da0) and c:GetSequence()<5
end

function c65010040.pwcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c65010040.pwconfil,tp,LOCATION_MZONE,0,e:GetHandler())==0  
end

function c65010040.pwtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or (Duel.GetMatchingGroupCount(Card.IsRace,tp,LOCATION_REMOVED,0,nil,RACE_CYBERSE)>=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133))) and Duel.IsPlayerCanSpecialSummonMonster(tp,65010044,0,0x4011,2500,2000,10,RACE_CYBERSE,ATTRIBUTE_FIRE,POS_FACEUP_DEFENSE,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c65010040.pwop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gt=Duel.GetMatchingGroupCount(Card.IsRace,tp,LOCATION_REMOVED,0,nil,RACE_CYBERSE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if gt>=2 and (Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65010044,0,0x4011,2500,2000,10,RACE_CYBERSE,ATTRIBUTE_FIRE,POS_FACEUP_DEFENSE,tp) then return end
	if gt<=1 then
		local token=Duel.CreateToken(tp,65010044)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	else
		for i=1,2 do
		local token=Duel.CreateToken(tp,65010044)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end