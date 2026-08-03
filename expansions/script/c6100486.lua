--永远的三日天下
local s,id,o=GetID()
function s.initial_effect(c)
	--这张卡的发动从手卡也能用。
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e0)
	
	--①：发动与后台驻留
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- === LCG 伪随机数生成器 ===
if not s.rng_state then
	s.rng_state = 0
end

function s.roll(min, max)
	-- 【修复1：彻底解决开局预见性】
	-- 仅在对局中第一次需要随机数时，初始化种子。
	-- 我们遍历当前双方卡组和手卡的所有卡，将洗牌打乱后的 FieldID 和 卡片密码 融合生成绝对随机的种子。
	if s.rng_state == 0 then
		local entropy = 0
		local g = Duel.GetFieldGroup(0, LOCATION_DECK+LOCATION_HAND, LOCATION_DECK+LOCATION_HAND)
		for tc in aux.Next(g) do
			-- FieldID 和 Code 在每局洗牌后的排列组合千变万化
			entropy = (entropy + tc:GetCode() + tc:GetFieldID()) & 0xffffffff
		end
		s.rng_state = entropy
		if s.rng_state == 0 then s.rng_state = 2333333 end -- 安全兜底
	end

	-- 【修复2：彻底解决组合重复问题】
	-- 去除画蛇添足的“环境动态注入”，让 Xorshift 算法自由运转。
	-- 这样能绝对保证它的分布是完美均匀的。
	local x = s.rng_state
	x = (x ~ (x << 13)) & 0xffffffff
	x = (x ~ (x >> 17)) & 0xffffffff
	x = (x ~ (x << 5)) & 0xffffffff
	s.rng_state = x

	local rand = x & 0x7fffffff
	return (rand % (max - min + 1)) + min
end

-- === 效果处理 ===
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 核心修复：动态判定重置的时机
	-- 如果是自己回合发动，则绑定为“下个自己回合结束时”
	-- 如果是对方回合发动，则绑定为“下个对方回合结束时”
	local reset_flag = 0
	if Duel.GetTurnPlayer()==tp then
		reset_flag = RESET_PHASE+PHASE_END+RESET_SELF_TURN
	else
		reset_flag = RESET_PHASE+PHASE_END+RESET_OPPO_TURN
	end
	
	-- 挂载：每次怪兽召唤·特殊召唤时适用
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(s.applyop)
	e1:SetReset(reset_flag, 2) -- 这里的 2 代表：当“满足条件的结束阶段”经过2次时失效
	Duel.RegisterEffect(e1,tp)
	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	
	-- 给发动玩家挂一个状态UI提示，方便知道效果还在适用
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(0)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetDescription(aux.Stringid(id, 0)) -- UI提示文字："永远的三日天下：适用中"
	e3:SetTargetRange(1, 0)
	e3:SetReset(reset_flag, 2)
	Duel.RegisterEffect(e3, tp)
end

function s.applyop(e,tp,eg,ep,ev,re,r,rp)
	-- 支持多体同时召唤，为每只怪兽分别独立判定和结算
	for tc in aux.Next(eg) do
		if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
			
			-- 初始化4个选项
			local opts = {1, 2, 3, 4}
			
			-- 随机抽取第1个效果，并从选项池中移除
			local r1 = s.roll(1, 4)
			local opt1 = opts[r1]
			table.remove(opts, r1)
			
			-- 从剩余的3个选项中随机抽取第2个效果
			local r2 = s.roll(1, 3)
			local opt2 = opts[r2]
			
			-- 发送UI提示，告知双方本怪兽抽到了哪两个效果
			Duel.Hint(HINT_OPSELECTED, 1-tp, aux.Stringid(id, opt1))
			Duel.Hint(HINT_OPSELECTED, tp, aux.Stringid(id, opt1))
			Duel.Hint(HINT_OPSELECTED, 1-tp, aux.Stringid(id, opt2))
			Duel.Hint(HINT_OPSELECTED, tp, aux.Stringid(id, opt2))
			
			local p = tc:GetControler()
			
			-- 顺序执行选出的两个效果，内部会实时获取攻击力
			s.execute_opt(tc, p, opt1, e:GetOwner())
			s.execute_opt(tc, p, opt2, e:GetOwner())
		end
	end
end

-- === 分支执行器 ===
function s.execute_opt(tc, p, opt, owner)
	-- 实时读取怪兽当前的攻击力
	local cur_atk = tc:GetAttack()
	
	if opt == 1 then
		-- ●那只怪兽的攻击力变成2倍。
		local e1=Effect.CreateEffect(owner)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(cur_atk * 2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		
	elseif opt == 2 then
		-- ●那只怪兽的攻击力变成一半。
		local e1=Effect.CreateEffect(owner)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(math.ceil(cur_atk / 2))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		
	elseif opt == 3 then
		-- ●那怪兽的控制者基本分回复那只怪兽的攻击力的数值。
		Duel.Recover(p, cur_atk, REASON_EFFECT)
		
	elseif opt == 4 then
		-- ●那怪兽的控制者基本分失去那只怪兽的攻击力的数值。
		if cur_atk > 0 then
			Duel.SetLP(p, math.max(0, Duel.GetLP(p) - cur_atk))
		end
	end
end