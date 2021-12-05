--神代丰的激斗 优骏大赛
function c64800106.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP+CATEGORY_TODECK+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,64800106+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c64800106.condition)
	e1:SetCost(c64800106.cost)
	e1:SetTarget(c64800106.target)
	e1:SetOperation(c64800106.activate)
	c:RegisterEffect(e1)
end

--e1
function c64800106.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c64800106.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c64800106.spfilter(c,e,tp)
	return c:IsSetCard(0x641a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c64800106.eqfilter(c)
	return c:IsCode(64800097) and not c:IsForbidden()
end
function c64800106.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c64800106.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c64800106.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,64800107,0,0x4011,0,0,4,RACE_WARRIOR,ATTRIBUTE_DARK,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)

end
function c64800106.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,64800107,0,0x4011,0,0,4,RACE_WARRIOR,ATTRIBUTE_DARK,POS_FACEUP)  then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c64800106.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		local tc1=g1:GetFirst()
		if Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g2=Duel.SelectMatchingCard(tp,c64800106.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
			local tc2=g2:GetFirst()
			if tc2 then
				if Duel.Equip(tp,tc2,tc1) then   
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_EQUIP_LIMIT)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(c64800106.eqlimit)
					tc2:RegisterEffect(e1)
				end
			end
			Duel.BreakEffect()
			Duel.SendtoDeck(tc1,nil,2,REASON_EFFECT)
			local token=Duel.CreateToken(tp,64800107)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			--self destroy
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EFFECT_SELF_DESTROY)
			e2:SetCondition(c64800106.sdcon)
			token:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	end
end
function c64800106.eqlimit(e,c)
	return e:GetOwner()==c
end
function c64800106.sdfilter(c)
	return c:IsFaceup() and c:IsCode(64800097)
end
function c64800106.sdcon(e)
	return Duel.IsExistingMatchingCard(c64800106.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end