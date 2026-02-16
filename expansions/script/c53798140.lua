local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon
	c:EnableReviveLimit()

	-- 同调召唤手续
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.syncon)
	e1:SetTarget(s.syntg)
	e1:SetOperation(s.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)

	--Extra Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,9))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_DUAL))
	e1:SetOperation(s.esop)
	c:RegisterEffect(e1)

	--Column Dual Status
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_DUAL_STATUS)
	e2:SetTarget(s.dualtg)
	c:RegisterEffect(e2)
end

function s.get_syn_levels(c,syncard)
	local raw_lv = c:GetSynchroLevel(syncard)
	local levels = {}
	-- YGOPRO中，GetSynchroLevel通常最多返回4个等级（每16位一个）
	for i=0,3 do
		-- 使用位运算提取每16位的值
		local lv = bit.band(bit.rshift(raw_lv, i*16), 0xFFFF)
		if lv > 0 then
			table.insert(levels, lv)
		end
	end
	return levels
end

-- 过滤：非调整
function s.val_nontuner(c,syncard)
	return c:IsNotTuner(syncard)
end

-- 过滤：调整（含二重逻辑）
function s.val_tuner(c,syncard,c_nt)
	if not c:IsCanBeSynchroMaterial(syncard) then return false end
	
	local lv_syn = syncard:GetLevel()
	local nt_levels = s.get_syn_levels(c_nt, syncard)
	
	-- 遍历非调整怪兽的所有可能等级
	for _, lv_nt in ipairs(nt_levels) do
		-- 逻辑A：原本就是调整，且等级相加符合
		local self_levels = s.get_syn_levels(c, syncard)
		for _, lv_self in ipairs(self_levels) do
			 if c:IsTuner(syncard) and (lv_self + lv_nt == lv_syn) then return true end
		end
		
		-- 逻辑B：二重怪兽特例（视为任意等级调整）
		-- 只要 非调整等级 < 同调等级，就能补齐
		if c:IsType(TYPE_DUAL) and c:IsDualState() and (lv_nt < lv_syn) then
			return true
		end
	end
	return false
end

-- 手续 Condition
function s.syncon(e,c,smat,mg,min,max)
	if c==nil then return true end
	if min and min>2 then return false end
	if max and max<2 then return false end
	local tp=c:GetControler()
	local g
	local mgchk=false
	if mg then g=mg; mgchk=true else g=aux.GetSynMaterials(tp,c) end
	if smat then g:AddCard(smat) end
	if not aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	
	return g:IsExists(function(c_nt)
		if not s.val_nontuner(c_nt,c) then return false end
		return g:IsExists(function(c_t)
			return c_t~=c_nt and s.val_tuner(c_t,c,c_nt) 
				   and aux.MustMaterialCheck(Group.FromCards(c_nt,c_t),tp,EFFECT_MUST_BE_SMATERIAL)
		end, 1, nil)
	end, 1, nil)
end

-- 手续 Target（最关键的逻辑部分）
function s.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
	local g
	if mg then g=mg else g=aux.GetSynMaterials(tp,c) end
	if smat then g:AddCard(smat) end
	if not aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	-- 1. 选择非调整
	local g_nt = g:FilterSelect(tp, function(c_nt)
		if not s.val_nontuner(c_nt,c) then return false end
		if smat and c_nt~=smat then
			 if not s.val_tuner(smat,c,c_nt) then return false end
			 local check_g = Group.FromCards(c_nt, smat)
			 return aux.MustMaterialCheck(check_g,tp,EFFECT_MUST_BE_SMATERIAL)
		end
		return g:IsExists(function(c_t)
			return c_t~=c_nt and s.val_tuner(c_t,c,c_nt) 
				   and aux.MustMaterialCheck(Group.FromCards(c_nt,c_t),tp,EFFECT_MUST_BE_SMATERIAL)
		end, 1, nil)
	end, 1, 1, nil)
	
	if #g_nt == 0 then return false end
	local c_nt = g_nt:GetFirst()
	
	-- 2. 解析非调整的等级，确定需要补足的星数列表
	local sync_lv = c:GetLevel()
	local nt_raw_levels = s.get_syn_levels(c_nt, c)
	local needed_levels = {}
	local needed_map = {} -- 反向映射，方便查找
	
	for _, lv in ipairs(nt_raw_levels) do
		if lv < sync_lv then
			local need = sync_lv - lv
			if not needed_map[need] then
				table.insert(needed_levels, need)
				needed_map[need] = true -- 标记已存在，避免重复
			end
		end
	end

	-- 3. 选择调整/二重怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local g_t = g:FilterSelect(tp, function(c_t)
		if c_t == c_nt then return false end
		if not aux.MustMaterialCheck(Group.FromCards(c_nt,c_t),tp,EFFECT_MUST_BE_SMATERIAL) then return false end
		if not c_t:IsCanBeSynchroMaterial(c) then return false end

		-- 检查：是否能作为调整
		if c_t:IsTuner(c) then
			local self_lvs = s.get_syn_levels(c_t, c)
			for _, slv in ipairs(self_lvs) do
				 if needed_map[slv] then return true end
			end
		end
		-- 检查：是否能作为二重怪兽（如果是非二重且不满足上面Tuner条件，这里会过滤掉）
		if c_t:IsType(TYPE_DUAL) and c_t:IsDualState() then
			 return true -- 只要是二重，总有一个 needed_level 适合它
		end
		return false
	end, 1, 1, nil)
	
	if #g_t == 0 then return false end
	local c_t = g_t:GetFirst()
	
	-- 4. 确定最终等级并注册 EFFECT_SYNCHRO_LEVEL
	-- 如果是非调整有多种等级（如 调和支援士），导致 needed_levels 有多种可能
	-- 我们需要询问玩家想把它当作几星来用（这直接决定了二重怪兽变成几星）
	local final_needed_lv = 0
	
	-- 找出当前选中的这一对组合，所有合法的 needed_level 选项
	local valid_options = {}
	local valid_ops = {} -- 用于 Duel.SelectOption
	
	local is_dual_special = c_t:IsType(TYPE_DUAL)
	
	for _, need in ipairs(needed_levels) do
		local is_valid = false
		-- 如果是普通调整，必须原本就有这个等级
		if c_t:IsTuner(c) then
			local self_lvs = s.get_syn_levels(c_t, c)
			for _, slv in ipairs(self_lvs) do
				if slv == need then is_valid = true break end
			end
		end
		-- 如果是二重特例，则总是合法的（因为它能变成任何 needed level）
		if is_dual_special then is_valid = true end
		
		if is_valid then
			-- 记录这个选项：二重怪兽变星为 need，意味着 非调整怪兽等级为 (sync_lv - need)
			table.insert(valid_options, need)
			table.insert(valid_ops, aux.Stringid(id,sync_lv - need)) -- 提示文本：把非调整当作X星
		end
	end
	
	if #valid_options == 0 then return false end -- 理论上不会发生
	
	if #valid_options == 1 then
		final_needed_lv = valid_options[1]
	else
		-- 只有在非调整怪兽有多种可能等级时才会触发（如调和支援士）
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_LVRANK)
		local choice = Duel.SelectOption(tp, table.unpack(valid_ops))
		final_needed_lv = valid_options[choice + 1]
	end
	
	-- **核心操作**：给二重怪兽注册 EFFECT_SYNCHRO_LEVEL
	-- 只有当它是通过二重效果变星时才需要注册，如果它本来就是调整且等级对上了，就不需要改
	-- 但为了保险起见，只要是二重怪兽，我们都给它强制设定这个等级，防止原本等级虽对但有负面效果（如王道同调士）
	if c_t:IsType(TYPE_DUAL) and c_t:IsDualState() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SYNCHRO_LEVEL)
		e1:SetValue(final_needed_lv)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c_t:RegisterEffect(e1, true) -- true 表示强制注册，即使有免疫
	end

	g_nt:Merge(g_t)
	g_nt:KeepAlive()
	e:SetLabelObject(g_nt)
	return true
end

function s.synop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end

function s.esop(e,tp,eg,ep,ev,re,r,rp,c)
	--Cost: Send this card from Extra Deck to GY
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	--Restriction: Cannot Summon/Special Summon except Gemini (excluding Extra Deck)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end

function s.sumlimit(e,c)
	return not c:IsType(TYPE_DUAL) and not c:IsLocation(LOCATION_EXTRA)
end

function s.dualtg(e,c)
	return c:IsType(TYPE_DUAL) and e:GetHandler():GetColumnGroup():IsContains(c)
end