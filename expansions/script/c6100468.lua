--璇序锋峦-小鹿男“寻森”
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

	--②：破坏自己卡，精准数量无效对方，并注册离场遗言
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
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

-- === 效果②：破坏、无效、挂遗言记录 ===
function s.disfilter(c,e)
	return c:IsFaceup() and c:IsCanBeDisabledByEffect(e)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
			and Duel.IsExistingMatchingCard(s.disfilter,tp,0,LOCATION_ONFIELD,1,nil,e)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD)
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 动态计算当前可供破坏和无效的最大数量
	local op_g = Duel.GetMatchingGroup(s.disfilter,tp,0,LOCATION_ONFIELD,nil,e)
	local max_count = math.min(3, #op_g)
	
	if max_count == 0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	-- 选1到max_count张破坏
	local des_g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,max_count,nil)
	if #des_g>0 then
		local ct=Duel.Destroy(des_g,REASON_EFFECT)
		local og=Duel.GetOperatedGroup():Filter(Card.IsPreviousControler,nil,tp) -- 获取确实被破坏并进入有效区域的自己的卡
		
		-- 如果成功破坏了卡片，那么必须无效对应数量的对方场上卡片
		if ct>0 then
			local ng=Duel.GetMatchingGroup(s.disfilter,tp,0,LOCATION_ONFIELD,nil,e)
			if #ng>=ct then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
				local sg=ng:Select(tp,ct,ct,nil)
				Duel.HintSelection(sg)
				for tc in aux.Next(sg) do
					Duel.NegateRelatedChain(tc,RESET_TURN_SET)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
					if tc:IsType(TYPE_TRAPMONSTER) then
						local e3=Effect.CreateEffect(c)
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
						e3:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e3)
					end
				end
			end
			
			-- 挂载遗言：如果这张卡还在场上，给被破坏的卡打上专属标记，并赋予离场触发
			if #og>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
				local fid=c:GetFieldID()
				for tc in aux.Next(og) do
					tc:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD,0,1,fid)
				end
				
				if c:GetFlagEffect(id+4)==0 then
					c:RegisterFlagEffect(id+4,RESET_EVENT+RESETS_STANDARD,0,0)
					
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e3:SetCode(EVENT_LEAVE_FIELD)
					e3:SetLabel(fid)
					e3:SetLabelObject(c)
					e3:SetCondition(s.reccon)
					e3:SetOperation(s.recop_defer)
					Duel.RegisterEffect(e3,tp)
				end
			end
		end
	end
end

-- === 效果②的遗言回收 ===
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if eg:IsContains(c) then
		return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE)
	else
		if c:GetFlagEffect(id+4)==0 then
			e:Reset() -- 标志消失时自我销毁
		end
		return false
	end
end

function s.recop_defer(e,tp,eg,ep,ev,re,r,rp)
	local fid = e:GetLabel()
	local owner = e:GetOwner()
	
	-- 如果未处于连锁结算阶段（如被战破或被规则送墓），立即执行
	if Duel.GetCurrentChain()==0 then
		s.do_rec_action(tp, fid, owner)
	else
		-- 若处于连锁结算中，向系统挂载延迟监听，待该层连锁完毕瞬间穿插执行
		local chain_id = Duel.GetCurrentChain()
		if Duel.GetFlagEffectLabel(tp,id+5) ~= chain_id then
			Duel.RegisterFlagEffect(tp,id+5,RESET_CHAIN,0,1,chain_id)
			local e1=Effect.CreateEffect(owner)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetLabel(fid)
			e1:SetCondition(function(eff,tp1,eg1,ep1,ev1,re1,r1,rp1) return ev1==chain_id end)
			e1:SetOperation(s.recop_execute)
			e1:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e1,tp)
		end
	end
	e:Reset() -- 成功捕捉后立即销毁自身的LEAVE_FIELD监听
end

function s.recop_execute(e,tp,eg,ep,ev,re,r,rp)
	local fid = e:GetLabel()
	s.do_rec_action(tp, fid, e:GetOwner())
	e:Reset() -- 穿插执行完毕后自我销毁
end

function s.recfilter(c,fid)
	return c:GetFlagEffectLabel(id+1)==fid and c:IsAbleToRemove()
end

function s.do_rec_action(tp, fid, owner)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.recfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,nil,fid)
	
	if #g>0 then
		Duel.Hint(HINT_CARD,0,6100468) -- 弹本体卡图告知对手
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		
		-- 将其不入连锁除外
		if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_REMOVED) then
			tc:RegisterFlagEffect(id+3,RESET_EVENT+RESETS_STANDARD,0,1)
			-- 阶段统合，防战阶干扰
			local ct=Duel.GetTurnCount()
			
			-- 挂载全局监听：下个大阶段开始时回手
			local e1=Effect.CreateEffect(owner)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ADJUST)
			e1:SetLabel(ct)
			e1:SetLabelObject(tc)
			e1:SetCondition(s.rthcon)
			e1:SetOperation(s.rthop)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

-- 下个阶段开始时判断
function s.rthcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id+3)==0 then
		e:Reset()
		return false
	end
	return Duel.GetTurnCount()~=e:GetLabel() 
end

function s.rthop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,6100468)
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	tc:ResetFlagEffect(id+3)
	e:Reset()
end

-- === 效果③：除外/回场状态机 (战阶留场) ===
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