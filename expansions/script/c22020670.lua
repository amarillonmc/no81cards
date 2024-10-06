--人理之基 织吉法师
function c22020670.initial_effect(c)
	aux.AddCodeList(c,22020631)
	c:EnableReviveLimit()
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,4)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020670,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c22020670.atkcost)
	e1:SetCountLimit(1,22020670)
	e1:SetTarget(c22020670.sptg)
	e1:SetOperation(c22020670.spop)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c22020670.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local ct=math.min(ft1,ft2)
	if chk==0 then return ct>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22020631,0,0x4011,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22020631,0,0x4011,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct*2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct*2,0,0)
	Duel.SelectOption(tp,aux.Stringid(22020670,1))
end
function c22020670.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local ct=math.min(ft1,ft2)
	if ct>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22020631,0,0x4011,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22020631,0,0x4011,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP) then
		for i=1,ct do
			local token=Duel.CreateToken(tp,22020631)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			token=Duel.CreateToken(tp,22020631)
			Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c22020670.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end