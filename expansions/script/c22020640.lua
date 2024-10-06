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
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if chk==0 then return ft1>0 and ft2>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22020631,0,TYPES_TOKEN_MONSTER,1000,1000,4,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22020631,0,TYPES_TOKEN_MONSTER,1000,1000,4,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP,1-tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
end
function c22020640.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if ft1<=0 or ft2<=0 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,22020631,0,TYPES_TOKEN_MONSTER,1000,1000,4,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22020631,0,TYPES_TOKEN_MONSTER,1000,1000,4,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP,1-tp) then
		local token=Duel.CreateToken(tp,22020631)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local token=Duel.CreateToken(tp,22020631)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end

