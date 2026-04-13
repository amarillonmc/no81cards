--后被称为芝诺的神
local s,id,o=GetID()
function s.initial_effect(c)
	-- 连接召唤设定: 可以通常召唤的怪兽2只
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,2,2)
	
	-- 自己对「后被称为芝诺的神」1回合只能有1次特殊召唤。
	c:SetSPSummonOnce(id)

	-- ①：这张卡连接召唤时，对方从以下效果让1个适用。
	-- （涵盖了获得连接标记和让对方二选一的处理）
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(s.effcon)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
end

-- 召唤条件过滤：可以通常召唤的怪兽
function s.matfilter(c)
	return c:IsSummonableCard()
end

-- 触发条件：必须是连接召唤成功时
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	-- ==========================================================
	-- 阶段一：得到最多有对方场上的怪兽数量的连接标记
	-- ==========================================================
	local ct = Duel.GetFieldGroupCount(tp, 0, LOCATION_MZONE)
	if ct > 0 then
		local _GetLink=Card.GetLink
		local _GetLinkCount=aux.GetLinkCount
		Card.GetLink=function(c)
						if c:IsHasEffect(EFFECT_CHANGE_LINK_MARKER_KOISHI) then
							local ct=0
							for i=0,8 do
								if c:GetLinkMarker()&(1<<(8-i))>0 then ct=ct+1 end
							end
							return ct
						else return _GetLink(c) end
					end
		aux.GetLinkCount=function(c)
							if c:IsHasEffect(EFFECT_CHANGE_LINK_MARKER_KOISHI) then
								if c:IsLinkType(TYPE_LINK) and _GetLink(c)>1 then
									local ct=0
									for i=0,8 do
										if c:GetLinkMarker()&(1<<(8-i))>0 then ct=ct+1 end
									end
									return 1+0x10000*ct
								else return 1 end
							else return _GetLinkCount(c) end
						end
		if not EFFECT_CHANGE_LINK_MARKER_KOISHI and not Duel.Exile then
			EFFECT_CHANGE_LINK_MARKER_KOISHI=id+1000
			local _GetLink=Card.GetLink
			local _GetLinkCount=aux.GetLinkCount
			Card.GetLink=function(c) if c:IsHasEffect(id+1000) then return math.max(0,_GetLink(c)) else return _GetLink(c) end end
			aux.GetLinkCount=function(c) if c:IsHasEffect(id+1000) then if c:IsLinkType(TYPE_LINK) and _GetLink(c)>1 then return 1+0x10000*math.max(0,_GetLink(c)) else return 1 end else return _GetLinkCount(c) end end
			---#{c:IsHasEffect(id+1000)}
			Card.GetLinkMarker=function(c)
									local res=0
									for i=0,8 do
										if i~=4 and c:IsLinkMarker(1<<i) then
											local add=true
											for _,te in pairs({c:IsHasEffect(id+1000)}) do
												if 1<<i==te:GetValue() then add=false end
											end
											if add then res=res|(1<<i) end
										end
									end
									return res
								end
		end
		local current_markers = c:GetLinkMarker()
		local added_markers = 0
		
		-- 映射所有的连接标记位与其对应的提示字符串
		-- 提示词需在 strings.conf 中注册，对应 id, 2~9
		local marker_list = {
			{LINK_MARKER_TOP_LEFT,	 aux.Stringid(id, 2)},  -- 左上
			{LINK_MARKER_TOP,		  aux.Stringid(id, 3)},  -- 正上
			{LINK_MARKER_TOP_RIGHT,	aux.Stringid(id, 4)},  -- 右上
			{LINK_MARKER_LEFT,		 aux.Stringid(id, 5)},  -- 正左
			{LINK_MARKER_RIGHT,		aux.Stringid(id, 6)},  -- 正右
			{LINK_MARKER_BOTTOM_LEFT,  aux.Stringid(id, 7)},  -- 左下
			{LINK_MARKER_BOTTOM,	   aux.Stringid(id, 8)},  -- 正下
			{LINK_MARKER_BOTTOM_RIGHT, aux.Stringid(id, 9)}   -- 右下
		}
		
		-- 循环让玩家挑选，最多挑选 ct 次
		for i = 1, ct do
			local options = {}
			local op_vals = {}
			
			-- 选项0永远是“完成选择”（因为是“最多有”，可以中途停止）
			if i > 1 then
				table.insert(options, aux.Stringid(id, 10)) 
				table.insert(op_vals, 0)
			end
			
			for _, m in ipairs(marker_list) do
				-- 只有当该方向目前没有标记，且本次循环还没被选过时，才加入候选菜单
				if (current_markers & m[1]) == 0 and (added_markers & m[1]) == 0 then
					table.insert(options, m[2])
					table.insert(op_vals, m[1])
				end
			end
			
			-- 如果只剩下“完成选择”，说明8个箭头全满了，直接跳出
			if #options == 1 then break end 
			
			Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(id, 11)) -- 提示: "请选择要增加的连接标记"
			local sel = Duel.SelectOption(tp, table.unpack(options))
			local chosen_val = op_vals[sel + 1]
			
			if chosen_val == 0 then
				break -- 玩家主动结束挑选
			else
				added_markers = added_markers | chosen_val
			end
		end
		
		if added_markers > 0 then
			for _, v in pairs(marker_list) do
				if added_markers&v[1]>0 then
					c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,v[2])
				end
			end
			-- 动态赋予选定的连接标记
			local e_marker = Effect.CreateEffect(c)
			e_marker:SetType(EFFECT_TYPE_SINGLE)
			e_marker:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
			e_marker:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e_marker:SetValue(added_markers | c:GetLinkMarker())
			e_marker:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e_marker)
		end
	end

	if c:IsDisabled() then return end

	-- ==========================================================
	-- 阶段二：对方从以下效果让1个适用 (终极悖论博弈)
	-- ==========================================================
	Duel.Hint(HINT_SELECTMSG, 1-tp, HINTMSG_EFFECT)
	-- 提示: 12为"限制怪兽发动效果", 13为"获得抗性并攻击力减半"
	local op = Duel.SelectOption(1-tp, aux.Stringid(id, 0), aux.Stringid(id, 1))
	
	if op == 0 then
		-- ●这个回合，连接状态的怪兽召唤·特殊召唤时，不在连接状态的怪兽的效果不能发动。
		-- 注册全局监听，捕捉所有召唤/特召动作
		local e_chain1 = Effect.CreateEffect(c)
		e_chain1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e_chain1:SetCode(EVENT_SUMMON_SUCCESS)
		e_chain1:SetOperation(s.limitop)
		e_chain1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e_chain1, tp)
		
		local e_chain2 = e_chain1:Clone()
		e_chain2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e_chain2, tp)
		s.limitop(e,tp,Group.FromCards(c),ep,ev,re,r,rp)
	else
		-- ●这张卡以及所连接区的怪兽不受从控制者来看的对方发动的效果影响
		local e_immune = Effect.CreateEffect(c)
		e_immune:SetType(EFFECT_TYPE_FIELD)
		e_immune:SetCode(EFFECT_IMMUNE_EFFECT)
		e_immune:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e_immune:SetRange(LOCATION_MZONE)
		e_immune:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
		e_immune:SetTarget(s.immunetg)
		e_immune:SetValue(s.immuneval)
		e_immune:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e_immune)
	end
end

-- 选项A的核心：捕捉召唤瞬间并切断时空
function s.limitop(e,tp,eg,ep,ev,re,r,rp)
	-- 只要本次召唤/特召的怪兽中，有处于“连接状态”的怪兽
	if eg:IsExists(Card.IsLinkState, 1, nil) then
		-- 对本次响应的连锁进行严格限制
		Duel.SetChainLimitTillChainEnd(s.chainlimit)
	end
end

-- 判定谁有资格在这个连锁中发声
function s.chainlimit(e,rp,tp)
	local tc = e:GetHandler()
	-- 如果发动的效果来源于怪兽（过滤掉魔陷）
	if e:IsActiveType(TYPE_MONSTER) then
		-- 只有处于“连接状态”的怪兽才能通过判定（手坑、墓地、未连接怪兽返回 false 被拦截）
		return tc:IsLinkState()
	end
	return true
end

-- 选项B的核心：赋予所指目标抗性
function s.immunetg(e,c)
	local handler = e:GetHandler()
	-- 目标是这张卡自身，或者是它连接区（网内）的怪兽
	return c == handler or handler:GetLinkedGroup():IsContains(c)
end

function s.immuneval(e,te,c)
	-- c: 受保护的怪兽； te: 企图发动的效果
	-- 条件1：必须是“发动的效果”
	-- 条件2：效果的控制者，不能是受保护怪兽的控制者（即：从控制者来看的对方）
	if not (te:IsActivated() and te:GetOwnerPlayer() ~= c:GetControler()) then return false end
	-- 那个场合攻击力变成一半
	local e_atk = Effect.CreateEffect(c)
	e_atk:SetType(EFFECT_TYPE_SINGLE)
	e_atk:SetCode(EFFECT_SET_ATTACK_FINAL)
	e_atk:SetValue(math.ceil(c:GetAttack() / 2))
	e_atk:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e_atk,true)
	return true
end