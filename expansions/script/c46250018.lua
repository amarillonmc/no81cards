--星装命令
function c46250018.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,46250018+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c46250018.spcost)
	e1:SetTarget(c46250018.sptg)
	e1:SetOperation(c46250018.spop)
	c:RegisterEffect(e1)
end
function c46250018.rfilter(c)
	return c:IsSetCard(0x1fc0) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c46250018.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c46250018.rfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c46250018.rfilter,tp,LOCATION_HAND,0,1,99,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetSum(Card.GetLevel))
end
function c46250018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,46250001,0x1fc0,0x4011,1000,0,3,RACE_WYRM,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c46250018.spop(e,tp,eg,ep,ev,re,r,rp)
	local n=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),math.ceil(e:GetLabel()/3))
	if n>=2 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if n>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,46250001,0x1fc0,0x4011,1000,0,3,RACE_WYRM,ATTRIBUTE_DARK) then
		for i=1,n do
			Duel.SpecialSummonStep(Duel.CreateToken(tp,46250001),0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c46250018.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c46250018.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xfc0)
end
