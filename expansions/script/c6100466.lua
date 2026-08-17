--璇序锋峦-山风“初翎”
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

	--①：卡的效果发动时，破坏并召唤
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

	--②：二速装备墓地·除外速攻魔法并赋予遗言
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)

	--③：一时除外系统 (战斗阶段留场)
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

-- === 效果①：公开与召唤 ===
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
	-- 自己场上的「璇序锋峦」卡
	return c:IsSetCard(0x3615) and c:IsDestructable()
end

function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil)
		and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end

function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsSummonable(true,nil) then
			Duel.Summon(tp,c,true,nil)
		end
	end
end

-- === 效果②：装备与赋予遗言 ===
function s.eqfilter(c)
	return c:IsSetCard(0x3615) and c:IsType(TYPE_SPELL) and c:IsFaceup() and not c:IsForbidden()
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
			Duel.Equip(tp,tc,c) 
			-- 装备限制
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		e1:SetLabelObject(c)
		tc:RegisterEffect(e1)
			
			if tc:GetFlagEffect(id+3)==0 then
				tc:RegisterFlagEffect(id+3,RESET_EVENT+RESETS_STANDARD,0,0)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_LEAVE_FIELD)
				e2:SetLabelObject(tc)
				e2:SetOperation(s.rmop_defer)
				Duel.RegisterEffect(e2,tp)
			end
  end
end

function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end

-- 附加给装备卡的遗言：除外对方墓地3卡
function s.rmop_defer(e,tp,eg,ep,ev,re,r,rp)
	local tc = e:GetLabelObject()
	if not tc then return end
	if eg:IsContains(tc) then
		-- 确保是从魔陷区（作为装备卡时）表侧离开的
		if tc:IsPreviousPosition(POS_FACEUP) and tc:IsPreviousLocation(LOCATION_SZONE) then
			-- 如果不在连锁处理中，立即执行不入连锁操作
			if Duel.GetCurrentChain()==0 then
				s.do_rm_action(tc, tp)
			else
				-- 如果正在连锁处理中，则注册至该连锁块结算完毕时再执行
				local chain_id = Duel.GetCurrentChain()
				local e1=Effect.CreateEffect(e:GetOwner())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_CHAIN_SOLVED)
				e1:SetLabel(chain_id)
				e1:SetLabelObject(tc) -- 传递实体卡片指针
				e1:SetOperation(s.rmop_execute)
				e1:SetReset(RESET_CHAIN)
				Duel.RegisterEffect(e1,tp)
			end
		end
		e:Reset() -- 触发后销毁全局监听器
	elseif tc:GetFlagEffect(id+3)==0 then
		e:Reset() -- 若被盖放等导致标志消失，也自动销毁监听器
	end
end

-- 连锁块结算完毕时的接力执行
function s.rmop_execute(e,tp,eg,ep,ev,re,r,rp)
	if ev==e:GetLabel() then
		s.do_rm_action(e:GetLabelObject(), tp)
		e:Reset() -- 触发一次后注销自身
	end
end

-- 真正的除外动作执行器
function s.do_rm_action(tc, tp)
	local sg = Group.CreateGroup()

	if tc and tc:IsLocation(LOCATION_GRAVE) and tc:IsAbleToRemove(tp,POS_FACEDOWN) then
		sg:AddCard(tc)
	end

	local g = Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil,tp,POS_FACEDOWN)
	if #g>0 then
		Duel.Hint(HINT_CARD,0,id) -- UI闪烁，明示效果来源
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg = g:Select(tp,1,1,nil)
		sg:Merge(tg)
	end

	if #sg>0 then
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	end
end

-- === 效果③：除外/回场状态机 (战阶留场) ===
function s.op_adjust(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local is_battle = (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	-- 只要是在战斗阶段，不论发生什么都必须在场
	if is_battle then
		if c:IsLocation(LOCATION_REMOVED) and c:GetFlagEffect(id+2)>0 then
			Duel.ReturnToField(c)
		end
	else
		-- 非战斗阶段且不在连锁中(空闲状态)，执行除外
		if Duel.GetCurrentChain()==0 and c:IsLocation(LOCATION_MZONE) then
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
			c:RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD,0,1)
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
		end
	end
end

function s.op_chaining(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local is_battle = (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	if is_battle then return end
	-- 在战斗阶段外：自己把效果连锁发动+当前是连锁2以上 -> 回场
	if ev>=2 and ep==tp and c:IsLocation(LOCATION_REMOVED) and c:GetFlagEffect(id+2)>0 then
		Duel.ReturnToField(c)
	end
end

function s.op_solving(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local is_battle = (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	if is_battle then return end
	-- 在战斗阶段外：连锁处理到连锁1时 -> 不入连锁除外
	if ev==1 and c:IsLocation(LOCATION_MZONE) then
		if Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
			c:RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD,0,1)
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
		end
	end
end