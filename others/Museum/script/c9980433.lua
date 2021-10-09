--AgitΩ·G4计划
function c9980433.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980433,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e1:SetCost(c9980433.spcost1)
	e1:SetTarget(c9980433.sptg1)
	e1:SetOperation(c9980433.spop1)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c9980433.actcon)
	c:RegisterEffect(e2)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980433,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c9980433.spcon)
	e2:SetTarget(c9980433.sptg)
	e2:SetOperation(c9980433.spop)
	c:RegisterEffect(e2)
	--def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetCondition(c9980433.defcon)
	e3:SetValue(c9980433.defval)
	c:RegisterEffect(e3)
end
function c9980433.cfilter1(c,tp)
	return  c:IsType(TYPE_MONSTER)
end
function c9980433.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c9980433.cfilter1,1,nil,tp) end
	local g=Duel.SelectReleaseGroupEx(tp,c9980433.cfilter1,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c9980433.spfilter1(c,e,tp,ec)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x5bca) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c9980433.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980433.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9980433.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9980433.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980433,2))
		Duel.SpecialSummon(g,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP,0x60)
	end
end
function c9980433.actcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function c9980433.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c9980433.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9980433,0x1bca,0x21,2000,2000,4,RACE_MACHINE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9980433.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,9980433,0x1bca,0x21,2000,2000,4,RACE_MACHINE,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980433,2))
		Duel.SpecialSummonStep(c,1,tp,tp,true,false,POS_FACEUP_DEFENSE)
		--redirect
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e2:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function c9980433.defcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c9980433.filter(c)
	return c:IsSetCard(0x5bca) and c:IsType(TYPE_MONSTER)
end
function c9980433.defval(e,c)
	return Duel.GetMatchingGroupCount(c9980433.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*500
end
