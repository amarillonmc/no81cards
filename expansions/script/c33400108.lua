--刻刻帝 「八之弹」
function c33400108.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400108+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(3)
	e1:SetCost(c33400108.cost)
	e1:SetTarget(c33400108.target)
	e1:SetOperation(c33400108.activate)
	c:RegisterEffect(e1)
end
function c33400108.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34f,ct,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x34f,ct,REASON_COST)
end
function c33400108.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33400016,0x3341,0x4011,1800,300,4,RACE_FAIRY,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c33400108.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33400016,0x3341,0x4011,1800,300,4,RACE_FAIRY,ATTRIBUTE_DARK) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,33400016)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)				
		end
		Duel.SpecialSummonComplete()
		 local e1=Effect.CreateEffect(e:GetHandler())
		 e1:SetType(EFFECT_TYPE_FIELD)
		 e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		 e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		 e1:SetTargetRange(1,0)
		 e1:SetTarget(c33400108.splimit)
		 e1:SetReset(RESET_PHASE+PHASE_END)
		 Duel.RegisterEffect(e1,tp)
	end
   Duel.RegisterFlagEffect(tp,33400101,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end
function c33400108.splimit(e,c)
	return not c:IsSetCard(0x341)
end