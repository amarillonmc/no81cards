--天下布武
function c22020640.initial_effect(c)
	aux.AddCodeList(c,22020631)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22020640+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22020640.target)
	e1:SetOperation(c22020640.activate)
	c:RegisterEffect(e1)
end
function c22020640.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c22020640.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22020631,0,0x4011,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_EARTH)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22020631,0,0x4011,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_EARTH,1-tp) 
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local token1=Duel.CreateToken(tp,22020631)
	local token2=Duel.CreateToken(tp,22020631)
	Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep(token2,0,tp,1-tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
end

