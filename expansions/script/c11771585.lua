--水墨云图 骇爪
function c11771585.initial_effect(c)
	-- 特殊召唤限制
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c11771585.limit)
	c:RegisterEffect(e0)
	-- 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11771585,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11771585)
	e1:SetCondition(c11771585.con1)
	e1:SetCost(c11771585.cost1)
	e1:SetTarget(c11771585.tg1)
	e1:SetOperation(c11771585.op1)
	c:RegisterEffect(e1)
	-- 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11771585,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11771586)
	e2:SetTarget(c11771585.tg2)
	e2:SetOperation(c11771585.op2)
	c:RegisterEffect(e2)
	-- 3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11771585,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,11771587)
	e3:SetTarget(c11771585.tg3)
	e3:SetOperation(c11771585.op3)
	c:RegisterEffect(e3)
	-- 记录效果发动
	if not c11771585.global_check then
		c11771585.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c11771585.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
-- 记录效果发动
function c11771585.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsLocation(LOCATION_HAND) and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) then
		Duel.RegisterFlagEffect(rp,11771583,RESET_PHASE+PHASE_END,0,1)
	end
	if rc:IsLocation(LOCATION_GRAVE) and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) then
		Duel.RegisterFlagEffect(rp,11771584,RESET_PHASE+PHASE_END,0,1)
	end
end
-- 特殊召唤限制
function c11771585.limit(e,se,sp,st)
	return se and se:IsActiveType(TYPE_MONSTER) and se:GetHandler():IsRace(RACE_WARRIOR)
end
-- 1
function c11771585.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,11771583)>0 and Duel.GetFlagEffect(tp,11771584)>0
end
function c11771585.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c11771585.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11771585.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
-- 2
function c11771585.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11771585.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.ShuffleHand(1-tp)
	end
	Duel.Draw(tp,1,REASON_EFFECT)
end
-- 3
function c11771585.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if chk==0 then return g1:GetCount()>0 or g2:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,PLAYER_ALL,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,0)
end
function c11771585.op3(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local ct1=g1:GetCount()
	local ct2=g2:GetCount()
	if ct1>0 then
		Duel.SendtoDeck(g1,nil,SEQ_DECKTOP,REASON_EFFECT)
		Duel.SortDecktop(tp,tp,ct1)
		for i=1,ct1 do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
	if ct2>0 then
		Duel.SendtoDeck(g2,nil,SEQ_DECKTOP,REASON_EFFECT)
		Duel.SortDecktop(1-tp,1-tp,ct2)
		for i=1,ct2 do
			local mg=Duel.GetDecktopGroup(1-tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
	if ct1>0 or ct2>0 then
		Duel.BreakEffect()
		if ct1>0 then
			Duel.Draw(tp,ct1,REASON_EFFECT)
		end
		if ct2>0 then
			Duel.Draw(1-tp,ct2,REASON_EFFECT)
		end
	end
end
