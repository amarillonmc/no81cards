--炽魂·魂帝 天武
local s, id = GetID()

-- 定义炽魂字段常量
s.soul_setcode = 0xa96c

-- 假设的连接怪兽卡号（请根据实际情况修改）
s.impact_id = 95018080   -- 炽魂之冲击
s.dodge_id = 95018070   -- 炽魂之遁形
s.block_id = 95018060	-- 炽魂之格挡
function s.initial_effect(c)
	
	-- 允许放置炽魂指示物
	c:EnableCounterPermit(s.soul_setcode)
	
	-- 特殊召唤规则：除外2只放置炽魂指示物的炽魂怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	
	-- 效果①：特殊召唤时放置3个炽魂指示物
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	
	-- 效果②：去除指示物选择效果发动
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCost(s.effcost)
	e3:SetTarget(s.efftg)
	e3:SetOperation(s.effop)
	c:RegisterEffect(e3)
	
	-- 效果③：被对方效果破坏时，结束阶段除外对方怪兽
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,id+2)
	e4:SetCondition(s.descon)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
end

-- 特殊召唤条件：检查是否有2只放置炽魂指示物的炽魂怪兽
function s.spfilter(c)
	return c:IsSetCard(s.soul_setcode) and c:IsFaceup() and c:GetCounter(s.soul_setcode)>0
end

function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and g:GetCount()>=2
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

-- 效果①：放置指示物条件
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_VALUE_SELF
end

function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,s.soul_setcode)
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup()  then
		c:AddCounter(s.soul_setcode,3)
	end
end

-- 效果②：去除指示物作为代价
function s.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,s.soul_setcode,1,REASON_COST) end
	c:RemoveCounter(tp,s.soul_setcode,1,REASON_COST)
end

-- 效果②：目标设定（选择效果）
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 检查墓地是否有对应的怪兽
		local g1=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,s.impact_id)
		local g2=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,s.dodge_id)
		local g3=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,s.block_id)
		return #g1>0 or #g2>0 or #g3>0
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end

-- 效果②：操作处理
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	
	-- 检查墓地可用选项
	local options={}
	local texts={}
	
	-- 选项1：除外炽魂之冲击
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,s.impact_id) then
		table.insert(options,1)
		table.insert(texts,aux.Stringid(id,4))
	end
	
	-- 选项2：除外炽魂之遁形
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,s.dodge_id) then
		table.insert(options,2)
		table.insert(texts,aux.Stringid(id,5))
	end
	
	-- 选项3：除外炽魂之格挡
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,s.block_id) then
		table.insert(options,3)
		table.insert(texts,aux.Stringid(id,6))
	end
	
	if #options==0 then return end
	
	-- 让玩家选择
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=options[Duel.SelectOption(tp,table.unpack(texts))+1]
	
	if op==1 then
		-- 选项1：除外炽魂之冲击
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_GRAVE,0,1,1,nil,s.impact_id)
		if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
			-- 这个回合，对方在战斗阶段中不能把效果发动
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(1)
			e1:SetTargetRange(0,1)
			e1:SetCondition(s.actlimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
		
	elseif op==2 then
		-- 选项2：除外炽魂之遁形
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_GRAVE,0,1,1,nil,s.dodge_id)
		if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
			-- 选择场上1张卡效果无效化
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local dg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if #dg>0 then
				local tc=dg:GetFirst()
				-- 无效效果
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				
				-- 对方不能把这张卡作为效果的对象
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e3:SetValue(aux.tgoval)
				e3:SetReset(RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
			end
		end
		
	elseif op==3 then
		-- 选项3：除外炽魂之格挡
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_GRAVE,0,1,1,nil,s.block_id)
		if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
			-- 这个回合，场上的这张卡不受其他卡的效果影响
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(s.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end

-- 战斗阶段不能发动效果的限制
function s.actlimit(e,re,tp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end

-- 不受其他卡的效果影响
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

-- 效果③：被对方效果破坏的条件
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and rp==1-tp
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	-- 创建延迟效果，在结束阶段执行
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.excon)
	e1:SetOperation(s.exop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.excon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function s.exop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	e:Reset()
end