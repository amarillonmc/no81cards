--支援型神威骑士 斯珀特（未解限）
function c24501054.initial_effect(c)
	-- 手卡起跳
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(24501054,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,24501054)
	e1:SetCondition(c24501054.con1)
	e1:SetTarget(c24501054.tg1)
	e1:SetOperation(c24501054.op1)
	c:RegisterEffect(e1)
    -- 加速同调
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24501054,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,24501055)
	e2:SetCondition(c24501054.con2)
	e2:SetTarget(c24501054.tg2)
	e2:SetOperation(c24501054.op2)
	c:RegisterEffect(e2)
    -- 3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24501054,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,24501056)
	e3:SetCondition(c24501054.con3)
	e3:SetTarget(c24501054.tg3)
	e3:SetOperation(c24501054.op3)
	c:RegisterEffect(e3)
end
-- 1
function c24501054.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and not c:IsCode(24501054)
end
function c24501054.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24501054.filter1,tp,LOCATION_MZONE,0,1,nil) and Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c24501054.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c24501054.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
-- 2
function c24501054.con2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c24501054.filter2(c,mc)
	return c:IsSynchroSummonable(mc) and c:IsSetCard(0x501)
end
function c24501054.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24501054.filter2,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c24501054.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c24501054.filter2,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end
-- 3
function c24501054.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24501054.filter3,tp,LOCATION_MZONE,0,1,nil)
end
function c24501054.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0x501) and c:IsLevelAbove(8)
end
function c24501054.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c24501054.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c24501054.filter3,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		if c:IsRelateToEffect(e) then
			if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e3:SetValue(LOCATION_DECKBOT)
			c:RegisterEffect(e3)
			end
		end
	end
end
