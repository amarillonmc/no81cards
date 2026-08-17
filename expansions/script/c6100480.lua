--璇序锋峦“瞬壑”森之灵
local s,id,o=GetID()
function s.initial_effect(c)
	--全局监听：记录同名卡的发动
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end

	--发动后继续留在场上
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e0)

	--①：发动并放置指示物
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE,TIMINGS_CHECK_MONSTER)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--①分支A：怪兽召唤·特殊召唤时 - 不入连锁取除指示物，回收本家卡
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(s.thop1)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2a)

	--①：有卡被破坏时，不入连锁宣告卡名赋予连击 (连续效果 + 延迟穿插机制)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.rmcon)
	e3:SetOperation(s.rmop_defer)
	c:RegisterEffect(e3)

	--②：被破坏回收
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.thcon)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(id) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
end

-- === 发动放置指示物 ===
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x161f,3)
	end
end

-- === 伤判结束扣血 ===
function s.thfilter(c)
	return c:IsSetCard(0x3615) and c:IsReason(REASON_DESTROY) and c:IsAbleToHand()
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end

function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCounter(0x161f)==0 then return end
	
	-- 此时去寻找自己的墓地、除外、表侧额外里带有被破坏属性的本家卡
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,nil)
	if #g>0 and c:IsCanRemoveCounter(tp,0x161f,1,REASON_EFFECT) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then 
			c:RemoveCounter(tp,0x161f,1,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
		if c:GetCounter(0x161f)==0 then
		Duel.Destroy(c,REASON_EFFECT)
	end
end

-- === 破坏触发：穿插延迟宣告机制 ===
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	-- 排除这张卡自身被破坏的事件
	return not eg:IsContains(e:GetHandler())
end

function s.rmop_defer(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCounter(0x161f)==0 then return end
	local is_zero = (c:GetCounter(0x161f)==0)
	-- 若未涉入连锁结算直接执行
	if Duel.GetCurrentChain()==0 then
		s.do_announce_action(c,tp)
	else
		-- 延后交由系统完成连锁的一瞬间执行
		local chain_id = Duel.GetCurrentChain()
		if c:GetFlagEffectLabel(id+2) ~= chain_id then
			c:RegisterFlagEffect(id+2, RESET_EVENT+RESETS_STANDARD+RESET_CHAIN, 0, 1, chain_id)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetLabel(chain_id)
			e1:SetOperation(s.rmop_execute)
			e1:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e1,tp)
		end
	if c:GetCounter(0x161f)==0 then
		Duel.Destroy(c,REASON_EFFECT)
	end
	end
end

function s.rmop_execute(e,tp,eg,ep,ev,re,r,rp)
	if ev == e:GetLabel() then
		s.do_announce_action(e:GetHandler(), tp)
		e:Reset()
	end
end

function s.do_announce_action(c, tp)
	if c:GetCounter(0x161f)==0 then return end
	
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then -- "是否取除1个指示物宣言怪兽使之获得2次攻击？"
		c:RemoveCounter(tp,0x161f,1,REASON_EFFECT)
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(c).announce_filter={0x3615,OPCODE_ISSETCARD,ATTRIBUTE_EARTH,OPCODE_ISATTRIBUTE,OPCODE_AND,TYPE_MONSTER,OPCODE_ISTYPE,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(c).announce_filter))
	Duel.SetTargetParam(ac)
		
		-- 赋予全场全局光环：同名怪兽可2次攻击 (不写Reset，存在于整场决斗)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(function(eff,tc) return tc:IsCode(ac) end)
		e1:SetValue(1)
		Duel.RegisterEffect(e1,tp)
	end
	if c:GetCounter(0x161f)==0 then
		Duel.Destroy(c,REASON_EFFECT)
	end
end

-- === 回收 ===
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)==0
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end