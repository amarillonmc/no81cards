--璇序锋峦-一目连“苍风”
local s,id,o=GetID()

function s.initial_effect(c)
	--①：连锁处理开始时不入连锁公开
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVING)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.revcon)
	e0:SetOperation(s.revop)
	c:RegisterEffect(e0)

	--①：卡的效果发动时，破坏手卡并召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(s.sumcon)
	e1:SetTarget(s.sumtg)
	e1:SetOperation(s.sumop)
	c:RegisterEffect(e1)

	--②：放置指示物，赋予代破，并挂载离场破坏卡组
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)

	--③：一时除外系统 (准备阶段留场)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e3:SetOperation(s.op_adjust)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_CHAINING)
	e4:SetOperation(s.op_chaining)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetOperation(s.op_solving)
	c:RegisterEffect(e5)
end

-- === 效果①：公开与手卡破坏召唤 ===
function s.revcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ev==Duel.GetCurrentChain() and c:GetFlagEffect(id)==0 and c:GetFlagEffect(id+1)==0
end

function s.revop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then -- "是否公开此卡以满足后续发动条件？"
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
		Duel.Hint(HINT_CARD,0,id)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	else
		c:RegisterFlagEffect(id+1,RESET_CHAIN,0,1)
	end
end

function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end

function s.desfilter(c)
	-- 自己手卡的「璇序锋峦」卡
	return c:IsSetCard(0x3615) and c:IsDestructable()
end

function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil)
		-- 破坏的卡必须排除自己
		and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end

function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	-- 从手卡选卡破坏（排除此卡自身）
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_HAND,0,1,1,c)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		if c:IsRelateToEffect(e) and c:IsSummonable(true,nil) then
			Duel.Summon(tp,c,true,nil)
		end
	end
end

-- === 效果②：放置指示物与离场触发 ===
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,c):GetFirst()
		tc:AddCounter(0x153f,1)
		
		if not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EFFECT_DESTROY_REPLACE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetTarget(s.reptg)
			e1:SetOperation(s.repop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(53766000,RESET_EVENT+RESETS_STANDARD,0,0)
		end
		
		-- 赋予离场追踪器
		if tc:GetFlagEffect(id+3)==0 then
			tc:RegisterFlagEffect(id+3,RESET_EVENT+RESETS_STANDARD,0,0)
			-- 注册全局监听，防离场效果重置
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_LEAVE_FIELD)
			e2:SetLabelObject(tc)
			e2:SetOperation(s.lvop)
			Duel.RegisterEffect(e2,tp)
		end
end

-- 代破判断
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) 
		and c:IsCanRemoveCounter(tp,0x153f,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,5)) -- "是否取除指示物来代替破坏？"
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x153f,1,REASON_EFFECT)
end

-- 破坏卡组对象过滤器：本家卡
function s.mtfilter(c)
	return c:IsSetCard(0x3615) and c:IsDestructable()
end

-- 离场捕捉：触发破坏卡组
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc then return end
	if eg:IsContains(tc) then
		local g1=Duel.GetDecktopGroup(tp,2)
		if #g1>0 and Duel.IsExistingMatchingCard(s.mtfilter,tp,LOCATION_DECK,0,1,g1) then
			Duel.Hint(HINT_CARD,0,id)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=Duel.SelectMatchingCard(tp,s.mtfilter,tp,LOCATION_DECK,0,1,1,g1)
			if #sg>0 then
				sg:Merge(g1)
				Duel.DisableShuffleCheck()
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
		e:Reset() -- 完成任务后自我清理
	elseif tc:GetFlagEffect(id+3)==0 then
		e:Reset() -- 若怪兽被里侧等原因抹除标志，监听器亦自我清理
	end
end


-- === 效果③：除外/回场状态机 (准备阶段留场) ===
function s.op_adjust(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local is_battle = (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	if is_battle then
		if c:IsLocation(LOCATION_REMOVED) and c:GetFlagEffect(id+2)>0 then
			Duel.ReturnToField(c)
		end
	else
		if Duel.GetCurrentChain()==0 and c:IsLocation(LOCATION_MZONE) then
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
			c:RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end

function s.op_chaining(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local is_battle = (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	if is_battle then return end
	if ev>=2 and ep==tp and c:IsLocation(LOCATION_REMOVED) and c:GetFlagEffect(id+2)>0 then
		Duel.ReturnToField(c)
	end
end

function s.op_solving(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local is_battle = (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	if is_battle then return end
	if ev==1 and c:IsLocation(LOCATION_MZONE) then
		if Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
			c:RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD,0,1)
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
		end
	end
end