--故国龙裔·长垣城塞
function c88480133.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c88480133.lcheck)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c88480133.spcost)
	e1:SetTarget(c88480133.sptg)
	e1:SetOperation(c88480133.spop)
	c:RegisterEffect(e1)
	--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,88480133)
	e2:SetCondition(c88480133.atkcon)
	e2:SetCost(c88480133.atkcost)
	e2:SetOperation(c88480133.atkop)
	c:RegisterEffect(e2)
end
function c88480133.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x410)
end
function c88480133.spfilter(c,tp)
	return c:IsSetCard(0x410) and Duel.GetMZoneCount(tp,c)>1
end
function c88480133.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c88480133.spfilter,1,REASON_COST,true,nil,tp) end
	local g=Duel.SelectReleaseGroupEx(tp,c88480133.spfilter,1,1,REASON_COST,true,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c88480133.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,88480150,0x410,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,4,RACE_WYRM,ATTRIBUTE_DARK,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c88480133.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,88480150,0x410,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,4,RACE_WYRM,ATTRIBUTE_DARK,POS_FACEUP) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,88480150)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetAbsoluteRange(tp,1,0)
			e1:SetTarget(c88480133.splimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function c88480133.splimit(e,c)
	return not c:IsRace(RACE_WYRM+RACE_MACHINE) and c:IsLocation(LOCATION_EXTRA)
end
function c88480133.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c88480133.costfilter(c)
	return c:IsSetCard(0x410) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c88480133.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88480133.costfilter,tp,0x3,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c88480133.costfilter,tp,0x3,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c88480133.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end