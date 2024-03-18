--被欺负的灰流丽
function c35531512.initial_effect(c)
	aux.AddCodeList(c,14558127) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,35531512+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c35531512.condition)
	e1:SetTarget(c35531512.target)
	e1:SetOperation(c35531512.activate)
	c:RegisterEffect(e1)
end 
function c35531512.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and (c:IsCode(14558127) or aux.IsCodeListed(c,14558127)) end,tp,LOCATION_MZONE,0,1,nil)
end
function c35531512.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,35531513,0,TYPES_TOKEN_MONSTER,0,1800,3,RACE_ZOMBIE,ATTRIBUTE_FIRE,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c35531512.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,35531513,0,TYPES_TOKEN_MONSTER,0,1800,3,RACE_ZOMBIE,ATTRIBUTE_FIRE,POS_FACEUP) then return end
	local token=Duel.CreateToken(tp,35531513) 
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)  
end






