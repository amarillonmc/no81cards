local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Select Effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	-- 参考神芸学徒(Source 16)的主阶段判断
	return Duel.IsMainPhase()
end

-- 参考Victrica(Source 4)，Cost函数仅做标记
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end

-- 选项1的Cost过滤：自己墓地，且对方场上有种族不同的怪兽
function s.cfilter1(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_MZONE,1,nil,c:GetRace())
end
-- 选项1的场上对象过滤：种族不同
function s.rmfilter(c,rc)
	return c:IsType(TYPE_MONSTER) and c:IsSummonType(SUMMON_TYPE_SPECIAL) and not c:IsRace(rc) and c:IsAbleToRemove()
end

-- 选项2的Cost过滤：对方墓地，且对方场上有种族相同的表侧怪兽
function s.cfilter2(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(s.disfilter,tp,0,LOCATION_MZONE,1,nil,c:GetRace())
end
-- 选项2的场上对象过滤：种族相同，表侧表示，且可以被无效
function s.disfilter(c,rc)
	return c:IsFaceup() and c:IsRace(rc) and aux.NegateMonsterFilter(c)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_GRAVE,0,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(s.cfilter2,tp,0,LOCATION_GRAVE,1,nil,tp)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return b1 or b2
	end
	e:SetLabel(0)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		Duel.SelectOption(tp,aux.Stringid(id,1))
		op=0
	else
		Duel.SelectOption(tp,aux.Stringid(id,2))
		op=1
	end
	
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	-- 参考Victrica(Source 5)，在Target中选择Cost并除外
	if op==0 then
		-- Option 1: Banish from own GY
		g=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE)
	else
		-- Option 2: Banish from opp GY
		g=Duel.SelectMatchingCard(tp,s.cfilter2,tp,0,LOCATION_GRAVE,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_MZONE)
	end
	
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local rc=tc:GetRace()
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
		-- 按照要求，将选项和种族同时SetLabel
		e:SetLabel(op,rc)
	end
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local op,rc=e:GetLabel()
	
	if op==0 then
		-- Option 1: Banish 1 monster with different Race
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,0,LOCATION_MZONE,1,1,nil,rc)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	else
		-- Option 2: Negate all face-up with same Race + Redirect
		local g=Duel.GetMatchingGroup(s.disfilter,tp,0,LOCATION_MZONE,nil,rc)
		if g:GetCount()>0 then
			for tc in aux.Next(g) do
				-- 参考神芸学徒(Source 17)的无效化逻辑
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				
				-- 参考Ghoti Snopios(Source 21)的离场除外逻辑
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetDescription(aux.Stringid(id,3))
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e3:SetValue(LOCATION_REMOVED)
				e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
				tc:RegisterEffect(e3)
			end
		end
	end
end