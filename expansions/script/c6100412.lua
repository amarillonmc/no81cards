--月时计之幻象
local s,id,o=GetID()
function s.initial_effect(c)
	--这张卡的发动从手卡也能用
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e0)

	--①：召唤怪兽并赋予后续效果抗性
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- === 发动条件 ===
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	-- 只有对方场上有怪兽存在的自己主要阶段才能发动
	return Duel.GetTurnPlayer()==tp and Duel.IsMainPhase()
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end

-- === 发动目标与连锁限制 ===
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,true,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	
	-- 对方场上的怪兽是3只以上的场合，不能对应这张卡的发动把卡的效果发动
	if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>=3 then
		Duel.SetChainLimit(aux.FALSE)
	end
end

-- === 效果处理 ===
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 这张卡的发动后，直到回合结束时对方受到的全部伤害变成0
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)

	-- 把1只怪兽召唤 (true代表不占用每回合一次的通召权)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,true,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end

	-- 记录对方场上的表侧表示卡的数量
	local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if ct>0 then
		-- 将可用次数写入 FlagEffect
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		Duel.SetFlagEffectLabel(tp,id,ct)
		
		-- 注册持续监听发动的效果
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAINING)
		e4:SetOperation(s.chainop)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end

-- === 持续监听钩子 ===
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	-- 自己把卡的效果发动时
	if ep==tp then
		local ct=Duel.GetFlagEffectLabel(tp,id)
		-- 检查是否有剩余次数
		if ct and ct>0 then
			-- 发动后直接询问“是否要让效果不会被对应”
			if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				-- 扣除1次使用机会
				Duel.SetFlagEffectLabel(tp,id,ct-1)
				-- 为刚刚发动的效果上抗性，使得任何人都不能连锁
				Duel.SetChainLimit(aux.FALSE)
			end
		end
	end
end