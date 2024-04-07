--诞地居民 树妖
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33300511,0x569,TYPES_TOKEN_MONSTER,100,100,2,RACE_PLANT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33300511,0x569,TYPES_TOKEN_MONSTER,100,100,2,RACE_PLANT,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,33300511)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
	local light=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ATTRIBUTE_LIGHT)
	local dark=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ATTRIBUTE_DARK)
	if light==0 and dark==0 then
		Duel.Hint(24,0,aux.Stringid(id,3))
	elseif light<dark then
		Duel.Hint(24,0,aux.Stringid(id,5))
	elseif light>dark then
		Duel.Hint(24,0,aux.Stringid(id,6))
	elseif light==dark then
		Duel.Hint(24,0,aux.Stringid(id,4))
	end
end