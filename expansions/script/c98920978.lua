--审判之斯芬克斯
local s, id = GetID()
function s.initial_effect(c)
	--①：可以从以下效果选择1个发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--②：自己场上的「斯芬克斯」怪兽被破坏的场合，可以作为代替把墓地的这张卡除外
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end

-- 特殊召唤过滤
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5c) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
end

-- 盖放过滤
function s.setfilter(c)
	return c:IsSetCard(0x5c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(id) and c:IsSSetable()
end

-- ① 效果的目标检查与分支选择
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 检测分支1：特召「斯芬克斯」怪兽（Flag: id）
	local b1 = Duel.GetFlagEffect(tp, id) == 0
		and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, nil, e, tp)
	
	-- 检测分支2：盖放同名卡以外的「斯芬克斯」魔陷（Flag: id + 10000000）
	local b2 = Duel.GetFlagEffect(tp, id+10000000) == 0
		and Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
		and Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, nil)
		
	if chk == 0 then return b1 or b2 end
	
	-- 选择要发动的分支
	local op = 0
	if b1 and b2 then
		op = Duel.SelectOption(tp, aux.Stringid(id, 1), aux.Stringid(id, 2))
	elseif b1 then
		op = Duel.SelectOption(tp, aux.Stringid(id, 1))
	else
		op = Duel.SelectOption(tp, aux.Stringid(id, 2)) + 1
	end
	e:SetLabel(op)
	
	-- 根据选择注册对应的1回合1次Flag，并设置Category
	if op == 0 then
		Duel.RegisterFlagEffect(tp, id, RESET_PHASE+PHASE_END, 0, 1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK+LOCATION_GRAVE)
	else
		Duel.RegisterFlagEffect(tp, id+10000000, RESET_PHASE+PHASE_END, 0, 1)
		e:SetCategory(0)
	end
end

-- ① 效果的执行
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op = e:GetLabel()
	if op == 0 then
		-- 分支1：特召
		if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.spfilter), tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
		local tc = g:GetFirst()
		if tc then
			-- 判断可以表侧攻击还是里侧守备
			local pos = 0
			local can_atk = tc:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP_ATTACK)
			local can_def = tc:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEDOWN_DEFENSE)
			if can_atk and can_def then
				pos = Duel.SelectPosition(tp, tc, POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
			elseif can_atk then
				pos = POS_FACEUP_ATTACK
			elseif can_def then
				pos = POS_FACEDOWN_DEFENSE
			end
			
			if pos > 0 then
				Duel.SpecialSummon(tc, 0, tp, tp, false, false, pos)
				if pos == POS_FACEDOWN_DEFENSE then
					Duel.ConfirmCards(1-tp, tc) -- 里侧特殊召唤向对手确认卡片
				end
			end
		end
	else
		-- 分支2：盖放魔陷
		if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
		local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.setfilter), tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, 1, nil)
		local tc = g:GetFirst()
		if tc then
			if Duel.SSet(tp, tc) ~= 0 then
				-- 如果是速攻魔法或陷阱卡，使其在盖放的回合也能发动
				if tc:IsType(TYPE_QUICKPLAY) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				elseif tc:IsType(TYPE_TRAP) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
		end
	end
end

-- ② 代破效果过滤
function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x5c)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end

-- ② 代破效果目标
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,3))
end

-- ② 代破价值
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end

-- ② 代破执行（除外此卡）
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end