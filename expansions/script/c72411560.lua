--马纳历亚秘术
function c72411560.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c72411560.target2)
	e1:SetOperation(c72411560.operation2)
	c:RegisterEffect(e1)	
end

function c72411560.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,72411561,0,0x4011,1500,1500,1,RACE_MACHINE,ATTRIBUTE_EART) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)   
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c72411560.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
			or not Duel.IsPlayerCanSpecialSummonMonster(tp,72411561,0,0x4011,1500,1500,1,RACE_MACHINE,ATTRIBUTE_EART) then return end
			local token=Duel.CreateToken(tp,72411561)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
end