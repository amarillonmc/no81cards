--电晶结成
function c72410220.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72410220+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c72410220.target)
	e1:SetOperation(c72410220.activate)
	c:RegisterEffect(e1)   
end
function c72410220.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=aux.GetMultiLinkedZone(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,nil,nil,zone)
	if chk==0 then return ft~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,72410221,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c72410220.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,72410221,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT,POS_FACEUP) then return end
	local zone=aux.GetMultiLinkedZone(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,nil,nil,zone)
	local token=Duel.CreateToken(tp,72410221)
	if ft<=0 or (Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>1) then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,72410221,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) then
	Duel.BreakEffect()
	local c=e:GetHandler()
		for i=1,ft do
		local token=Duel.CreateToken(tp,72410220+i)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	Duel.SpecialSummonComplete()
	end
end
