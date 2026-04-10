-- 绝缄视界 拉普拉斯织机
local s,id,o=GetID()
function s.initial_effect(c)
	-- 必须作为同调怪兽的通用设定
	c:EnableReviveLimit()
	
	-- 自己对「绝缄视界 拉普拉斯织机」1回合只能有1次特殊召唤
	c:SetSPSummonOnce(id)

	-- 自定义同调召唤手续 (替换标准的 aux.AddSynchroProcedure)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164) -- "同调召唤"
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.SynCondition)
	e1:SetTarget(s.SynTarget)
	e1:SetOperation(s.SynOperation)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)

	-- 注册同调召唤成功时的判定效果 (诱发 e4)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(s.chcon)
	e0:SetOperation(s.chop)
	c:RegisterEffect(e0)

	-- 强制触发：对方进行选择和执行
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CUSTOM+id)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_EVENT_PLAYER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.efftg)
	e4:SetOperation(s.effop)
	c:RegisterEffect(e4)
	-- 【引擎劫持模块】：只在对局开始时执行一次
	if not s.global_hooked then
		s.global_hooked = true
		s.restricted_codes = s.restricted_codes or {}
		local unpack = table.unpack or unpack
		
		-- ==========================================
		-- 核心修复：劫持 Effect 的底层元表方法
		-- 解决增殖的G等连续效果提早注册闭包导致绕过追踪的Bug
		-- ==========================================

		-- 拦截 SetOperation
		local old_SetOperation = Effect.SetOperation
		Effect.SetOperation = function(e, op)
			if type(op) == "function" then
				local wrapped_op = function(...)
					local prev_code = s.active_code
					local args = {...}
					local e_inner = args[1] -- 传入的第一个参数必然是 Effect 对象本身
					if aux.GetValueType(e_inner) == "Effect" then
						local owner = e_inner:GetOwner()
						if owner then
							-- 无论这是谁的效果，只要执行，就点亮对应卡名的追踪灯！
							s.active_code = owner:GetOriginalCodeRule()
						end
					end
					local res = {op(...)}
					s.active_code = prev_code -- 执行完毕后熄灭/恢复追踪灯
					return unpack(res)
				end
				return old_SetOperation(e, wrapped_op)
			end
			return old_SetOperation(e, op)
		end

		-- 拦截 SetTarget
		local old_SetTarget = Effect.SetTarget
		Effect.SetTarget = function(e, tg)
			if type(tg) == "function" then
				local wrapped_tg = function(...)
					local prev_code = s.active_code
					local args = {...}
					local e_inner = args[1]
					if aux.GetValueType(e_inner) == "Effect" then
						local owner = e_inner:GetOwner()
						if owner then
							s.active_code = owner:GetOriginalCodeRule()
						end
					end
					local res = {tg(...)}
					s.active_code = prev_code
					return unpack(res)
				end
				return old_SetTarget(e, wrapped_tg)
			end
			return old_SetTarget(e, tg)
		end
		-- ==========================================
		
		-- 1. 劫持 IsAbleToHand (阻断增援等空发)
		local old_IsAbleToHand = Card.IsAbleToHand
		Card.IsAbleToHand = function(tc, ...)
			if s.active_code and s.restricted_codes[s.active_code] == Duel.GetTurnCount() then
				if tc:IsLocation(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA) then
					return false
				end
			end
			return old_IsAbleToHand(tc, ...)
		end
		
		-- 2. 劫持 Duel.Draw (完美扼杀增殖的G)
		local old_Draw = Duel.Draw
		Duel.Draw = function(p, val, r)
			if (r & REASON_EFFECT) ~= 0 and s.active_code and s.restricted_codes[s.active_code] == Duel.GetTurnCount() then
				return 0 -- 强行让抽卡数量变为0，彻底无效
			end
			return old_Draw(p, val, r)
		end
		local old_IsPlayerCanDraw = Duel.IsPlayerCanDraw
		Duel.IsPlayerCanDraw = function(p, ...)
			if s.active_code and s.restricted_codes[s.active_code] == Duel.GetTurnCount() then
				return false
			end
			return old_IsPlayerCanDraw(p, ...)
		end
		
		-- 3. 劫持 Duel.SendtoHand (阻断所有结算时的强行检索/回收)
		local old_SendtoHand = Duel.SendtoHand
		Duel.SendtoHand = function(tg, p, r, ...)
			if (r & REASON_EFFECT) ~= 0 and s.active_code and s.restricted_codes[s.active_code] == Duel.GetTurnCount() then
				if aux.GetValueType(tg) == "Card" then
					if tg:IsLocation(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA) then return 0 end
				elseif aux.GetValueType(tg) == "Group" then
					local g = tg:Filter(Card.IsLocation, nil, LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
					if #g > 0 then return 0 end
				end
			end
			return old_SendtoHand(tg, p, r, ...)
		end
	end
end

-- 新增：自定义的素材放行过滤器 (买通底层保安)
function s.SynMaterialFilter(c, syncard)
	-- 1. 引擎原生允许的怪兽（有星数、且未被限制）直接放行
	if c:IsCanBeSynchroMaterial(syncard) then return true end
	
	-- 2. 针对超量和连接怪兽的特判：如果是额外特召的超量/连接
	if s.IsExtraDeckSpSummoned(c, syncard) and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK)) then
		-- 必须确保它身上没有挂着“不能作为同调素材”的自肃效果
		local effs = {c:IsHasEffect(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)}
		for _, e in ipairs(effs) do
			local val = e:GetValue()
			if type(val) == 'function' then
				if val(e, syncard) then return false end
			elseif val == 1 then
				return false
			end
		end
		return true -- 没有自肃，强行放行进备选池！
	end
	
	return false
end

-- 判断是否为从额外卡组特殊召唤的怪兽
function s.IsExtraDeckSpSummoned(c, syncard)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(syncard:GetControler()) --and c:IsSummonLocation(LOCATION_EXTRA)
end

-- 获取怪兽用于同调此卡时的所有合法【等级 + 调整状态】
function s.GetValidPairs(c, syncard)
	local pairs = {}
	local is_tuner = c:IsTuner(syncard)
	local lv = c:GetSynchroLevel(syncard)
	
	-- 原有等级与原本的调整状态
	local lv1 = lv & 0xffff
	local lv2 = lv >> 16
	if lv1 > 0 then table.insert(pairs, {lv1, is_tuner}) end
	if lv2 > 0 then table.insert(pairs, {lv2, is_tuner}) end
	
	-- 如果是从额外卡组特殊召唤的，当作任意等级的调整
	-- 此卡是8星同调，单只怪兽最大不会超过7星
	local ct = Duel.GetFieldGroupCount(syncard:GetControler(), 0, LOCATION_HAND)
	if s.IsExtraDeckSpSummoned(c, syncard) and ct > 1 then
		for i = 1, ct do
			table.insert(pairs, {i, true})
		end
	end
	return pairs
end

-- 深度优先搜索：验证能否相加等于8，并且【至少包含1只 3星以下的调整】
function s.CheckSum(cards, index, target_lv, has_valid_tuner, syncard)
	if index > #cards then return (target_lv == 0 and has_valid_tuner) end
	if target_lv <= 0 then return false end
	
	local c = cards[index]
	local pairs = s.GetValidPairs(c, syncard)
	for _, p in ipairs(pairs) do
		local current_lv = p[1]
		local current_is_tuner = p[2]
		
		-- 【核心判定】：不仅要是调整，而且它的星数必须 <= 3 ！！
		-- 如果是4星或以上的调整，它在这条判定下为 false，只能充当非调凑数部分
		local is_valid_tuner = (current_is_tuner and current_lv <= 3)
		
		if s.CheckSum(cards, index + 1, target_lv - current_lv, has_valid_tuner or is_valid_tuner, syncard) then
			return true
		end
	end
	return false
end

-- 验证当前的一组素材是否合法
function s.CheckGroup(g, syncard, tp)
	if g:GetCount() < 2 then return false end
	
	if not aux.MustMaterialCheck(g, tp, EFFECT_MUST_BE_SMATERIAL) then return false end
	if Duel.GetLocationCountFromEx(tp, tp, g, syncard) <= 0 then return false end
	
	local cards = {}
	for c in aux.Next(g) do table.insert(cards, c) end
	-- 初始传入 false，等待 CheckSum 去捕捉 <= 3星的调整
	return s.CheckSum(cards, 1, 8, false, syncard) 
end

-- 递归查找是否存在合法的选材组合 (绝对安全的穷举结构)
function s.CheckRecursive(mg, sg, cards, idx, smat, syncard, tp, minc, maxc)
	if sg:GetCount() >= minc and sg:GetCount() <= maxc then
		if smat==nil or sg:IsContains(smat) then
			if s.CheckGroup(sg, syncard, tp) then return true end
		end
	end
	if sg:GetCount() >= maxc then return false end
	if idx > #cards then return false end
	
	for i = idx, #cards do
		local c = cards[i]
		if not sg:IsContains(c) then
			sg:AddCard(c)
			if s.CheckRecursive(mg, sg, cards, i + 1, smat, syncard, tp, minc, maxc) then
				sg:RemoveCard(c)
				return true
			end
			sg:RemoveCard(c)
		end
	end
	return false
end

-- 获取全场可以作为同调素材的怪兽（包含手卡）
function s.GetSynchroMaterials(tp, syncard)
	local mg = Duel.GetMatchingGroup(s.SynMaterialFilter, tp, LOCATION_MZONE, 0, nil, syncard)
	if mg:IsExists(Card.GetHandSynchro, 1, nil) then
		local mg2 = Duel.GetMatchingGroup(s.SynMaterialFilter, tp, LOCATION_HAND, 0, nil, syncard)
		if mg2:GetCount() > 0 then mg:Merge(mg2) end
	end
	return mg
end

-- 同调条件 (Condition)
function s.SynCondition(e,c,smat,mg,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local minc = min or 2
	local maxc = max or 99
	
	local mg1 = nil
	if mg then
		mg1 = mg:Filter(s.SynMaterialFilter, nil, c)
	else
		mg1 = s.GetSynchroMaterials(tp, c)
	end
	if smat then mg1:AddCard(smat) end
	
	local cards = {}
	for tc in aux.Next(mg1) do table.insert(cards, tc) end
	return s.CheckRecursive(mg1, Group.CreateGroup(), cards, 1, smat, c, tp, minc, maxc)
end

-- 同调目标选择 (Target)
function s.SynTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
	local minc = min or 2
	local maxc = max or 99
	local mg1 = nil
	if mg then
		mg1 = mg:Filter(s.SynMaterialFilter, nil, c)
	else
		mg1 = s.GetSynchroMaterials(tp, c)
	end
	if smat then mg1:AddCard(smat) end
	
	local cards = {}
	for tc in aux.Next(mg1) do table.insert(cards, tc) end
	
	local sg = Group.CreateGroup()
	local cancel = Duel.IsSummonCancelable()
	
	while true do
		local cancelable = (sg:GetCount() == 0 and cancel)
		local finishable = (sg:GetCount() >= minc and sg:GetCount() <= maxc)
			and (smat == nil or sg:IsContains(smat))
			and s.CheckGroup(sg, c, tp)
		
		if sg:GetCount() >= maxc then
			if finishable then break end
			return false
		end
		
		local valid_additions = Group.CreateGroup()
		for i = 1, #cards do
			local tc = cards[i]
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
				if s.CheckRecursive(mg1, sg, cards, 1, smat, c, tp, minc, maxc) then
					valid_additions:AddCard(tc)
				end
				sg:RemoveCard(tc)
			end
		end
		
		if valid_additions:GetCount() == 0 then
			if finishable then break else return false end
		end
		
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SMATERIAL)
		local tc = Group.SelectUnselect(valid_additions, sg, tp, finishable, cancelable, 1, 1)
		if not tc then
			if finishable then break else return false end
		end
		if sg:IsContains(tc) then
			sg:RemoveCard(tc)
		else
			sg:AddCard(tc)
		end
	end
	
	if sg:GetCount() > 0 then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	end
	return false
end

-- 同调处理执行 (Operation)
function s.SynOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g, REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end

-- 确保只有同调召唤成功才触发
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 将事件的 ep 设定为对方玩家 (1-c:GetControler())
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+id,re,r,1-c:GetControler(),1-c:GetControler(),0)
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	-- 因为 e4 带有 EFFECT_FLAG_EVENT_PLAYER，这里的 tp 已经是【对方玩家】
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	-- 假设 Stringid(id,1) 为选项一，Stringid(id,2) 为选项二
	local op=Duel.SelectOption(tp, aux.Stringid(id,0), aux.Stringid(id,1))
	e:SetLabel(op)
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	-- 此时 tp 是对方(进行选择的人)，1-tp 是这张卡的控制者
	
	if op==0 then
		-- ●双方各自宣言1个卡名。
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local code1=Duel.AnnounceCard(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CODE)
		local code2=Duel.AnnounceCard(1-tp)
		
		-- 记录限制回合数 (当回合结束时，值过期，限制自动解除)
		s.restricted_codes[code1] = Duel.GetTurnCount()
		s.restricted_codes[code2] = Duel.GetTurnCount()
		
		-- 给这两张卡进行最高权限的动态代码劫持
		s.HookCardCode(tp, code1)
		s.HookCardCode(tp, code2)
		
	else
		-- ●双方轮流宣言各3个卡名。
		local codes = {}
		for i=1,3 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
			table.insert(codes, Duel.AnnounceCard(tp))
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CODE)
			table.insert(codes, Duel.AnnounceCard(1-tp))
		end
		
		-- 直到下个回合的结束时，双方不能把宣言的卡以外的效果发动。
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,1)
		e2:SetValue(s.aclimit2)
		e2:SetLabel(table.unpack(codes)) -- 核心：把包含 6 个元素的 table 强行挂到 effect 上
		e2:SetReset(RESET_PHASE+PHASE_END, 2) -- 持续到下个回合结束
		Duel.RegisterEffect(e2,tp)
	end
end

-- 选项1的限制判定：封锁宣言卡的加手/抽卡/检索效果的发动
function s.aclimit1(e,re,tp)
	local code1,code2 = e:GetLabel()
	local tc = re:GetHandler()
	-- 如果发动的不是宣言的卡，不受限制
	if not tc:IsOriginalCodeRule(code1) and not tc:IsOriginalCodeRule(code2) then return false end
	-- 如果是宣言的卡，且包含加手/检索/抽卡类别，则限制发动 (返回 true)
	return re:IsHasCategory(CATEGORY_TOHAND) or re:IsHasCategory(CATEGORY_SEARCH) or re:IsHasCategory(CATEGORY_DRAW)
end

-- 选项2的限制判定：只能发动宣言卡的效果
function s.aclimit2(e,re,tp)
	local codes = {e:GetLabel()}
	local tc = re:GetHandler()
	-- 遍历 6 个宣言的卡名
	for _, code in ipairs(codes) do
		if tc:IsOriginalCodeRule(code) then 
			return false -- 属于宣言的卡，【可以】发动
		end
	end
	-- 不在列表中，【不能】发动 (返回 true)
	return true
end

-- 【动态注入模块】：将被宣言的卡的函数全部套上追踪壳
function s.HookCardCode(tp, code)
	local ctable = _G["c"..code]
	-- 如果该卡没在双方卡组里，强制生成一个衍生物以加载它的脚本缓存
	if not ctable then 
		Duel.CreateToken(tp, code)
		ctable = _G["c"..code]
	end
	
	-- 如果卡片不存在，或已经被我们注入过，则跳过
	if not ctable or ctable.laplace_hooked then return end
	ctable.laplace_hooked = true
	
	local unpack = table.unpack or unpack
	-- 遍历该卡的所有函数 (Target, Condition, Operation...)
	for k, v in pairs(ctable) do
		if type(v) == "function" then
			ctable[k] = function(...)
				-- 保存上一层的上下文 (防止连锁嵌套)
				local prev = s.active_code
				-- 点亮全局追踪灯！
				s.active_code = code
				-- 执行原本的函数
				local res = {v(...)}
				-- 熄灭追踪灯
				s.active_code = prev
				return unpack(res)
			end
		end
	end
end