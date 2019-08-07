--羁绊龙
function c10150082.initial_effect(c)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(21159309)
	c:RegisterEffect(e1)
	--tk	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150082,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetCountLimit(1,10150082)
	e2:SetCondition(c10150082.spcon)
	e2:SetTarget(c10150082.sptg)
	e2:SetOperation(c10150082.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()  
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3) 
end
function c10150082.spcon(e,tp)
	return Duel.IsExistingMatchingCard(c10150082.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c10150082.cfilter(c)
	return (c:IsRace(RACE_DRAGON) or c:IsSetCard(0xc2)) and c:IsFaceup()
end
function c10150082.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsPlayerCanSpecialSummonMonster(tp,10150084,0,0x4011,0,0,1,RACE_DRAGON,ATTRIBUTE_LIGHT,POS_FACEUP) or Duel.IsPlayerCanSpecialSummonMonster(tp,10150085,0,0x5011,0,0,3,RACE_DRAGON,ATTRIBUTE_DARK,POS_FACEUP)) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10150082.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local b1=Duel.IsPlayerCanSpecialSummonMonster(tp,10150084,0,0x4011,0,0,1,RACE_DRAGON,ATTRIBUTE_LIGHT,POS_FACEUP)
	local b2=Duel.IsPlayerCanSpecialSummonMonster(tp,10150085,0,0x5011,0,0,3,RACE_DRAGON,ATTRIBUTE_DARK,POS_FACEUP)
	if not b1 and not b2 then return end
	local token=0
	if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(10150082,1))) then
	   token=Duel.CreateToken(tp,10150084)
	else
	   token=Duel.CreateToken(tp,10150085)
	end
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
