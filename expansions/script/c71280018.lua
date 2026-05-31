--超量释放
function c71280018.initial_effect(c)
	aux.AddCodeList(c,2061963)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_START)
	e1:SetCountLimit(1,71280018)
	e1:SetCondition(c71280018.con)
	e1:SetTarget(c71280018.target)
	e1:SetOperation(c71280018.activate)
	c:RegisterEffect(e1)
	--end battle phase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11280018)
	e2:SetCondition(c71280018.condition)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c71280018.operation)
	c:RegisterEffect(e2)
end
function c71280018.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c71280018.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_BATTLE_START
end
function c71280018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71280018.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c71280018.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft>3 then ft=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71280018.spfilter),tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	local cg=Group.CreateGroup()
	if #g>0 then
		local tc=g:GetFirst()
		while tc do
			if tc then
				if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
					cg:AddCard(tc)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
				end
			end
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)
	if cg:GetCount()~=0 and cg:FilterCount(Card.IsControlerCanBeChanged,nil)~=0 and ft~=0
		and Duel.IsExistingMatchingCard(c71280018.llfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(1-tp,aux.Stringid(71280018,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local ct=math.min(ft,cg:FilterCount(Card.IsControlerCanBeChanged,nil))
		local ccg=cg:Filter(Card.IsControlerCanBeChanged,nil):Select(1-tp,1,ct,nil)
		Duel.GetControl(ccg,1-tp)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetTargetRange(0,1)
		e5:SetTarget(c71280018.splimit)
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
	end
end
function c71280018.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function c71280018.llfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsReleasable()
end
function c71280018.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c71280018.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		if Duel.IsExistingMatchingCard(c71280018.afilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) then
			local ct=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)
			Duel.Recover(tp,ct*1000,REASON_EFFECT)
		end
	end
end
function c71280018.afilter(c)
	return c:IsCode(2061963) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end