--旋风战士 大强风兽
function c16317010.initial_effect(c)
	--summon with 1 tribute
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(16317010,1))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c16317010.otcon)
	e0:SetOperation(c16317010.otop)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e0)
	local e01=e0:Clone()
	e01:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e01)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,16317010)
	e1:SetCost(c16317010.cost)
	e1:SetTarget(c16317010.postg)
	e1:SetOperation(c16317010.posop)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e11)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e2:SetCountLimit(1,16317010+1)
	e2:SetCost(c16317010.cost)
	e2:SetTarget(c16317010.target)
	e2:SetOperation(c16317010.activate)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(16317010,ACTIVITY_SPSUMMON,c16317010.counterfilter)
end
function c16317010.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA)
end
function c16317010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(16317010,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16317010.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c16317010.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
function c16317010.posfilter2(c)
	return not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function c16317010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c16317010.posfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16317010.posfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c16317010.posfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c16317010.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE)
		and not c:IsPosition(POS_FACEUP_DEFENSE) then
		if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c16317010.efilter)
			tc:RegisterEffect(e1)
		end
	end
end
function c16317010.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c16317010.posfilter(c)
	return not c:IsPosition(POS_DEFENSE) and c:IsCanChangePosition()
end
function c16317010.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16317010.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c16317010.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c16317010.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and (c:IsRace(RACE_WINDBEAST) or c:IsAttribute(ATTRIBUTE_WIND))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16317010.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c16317010.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if tc:IsPosition(POS_FACEUP_ATTACK) and Duel.ChangePosition(tc,0x4)>0 and tc:IsControler(tp) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c16317010.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
			if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(16317010,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg2=sg:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c16317010.otfilter(c)
	return c:IsLevelAbove(5) and (c:IsAttribute(ATTRIBUTE_WIND) or c:IsRace(RACE_WINDBEAST))
end
function c16317010.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c16317010.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c16317010.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c16317010.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end