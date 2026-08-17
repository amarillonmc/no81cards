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

-- === 效果②：破坏、无效、并附加离场除外与回手 ===
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
	local op_g = Duel.GetMatchingGroup(s.disfilter,tp,0,LOCATION_ONFIELD,nil,e)
	local max_count = math.min(3, #op_g)
	
	if max_count == 0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local des_g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,max_count,nil)
	if #des_g>0 then
		local ct=Duel.Destroy(des_g,REASON_EFFECT)
		if ct>0 then
			local ng=Duel.GetMatchingGroup(s.disfilter,tp,0,LOCATION_ONFIELD,nil,e)
			local act_count = math.min(ct, #ng)
			if act_count>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
				local sg=ng:Select(tp,act_count,act_count,nil)
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
			
			if c:IsRelateToEffect(e) and c:IsFaceup() and c:GetFlagEffect(id+100)==0 then
			c:RegisterFlagEffect(id+100,RESET_EVENT+RESETS_STANDARD,0,0)
			-- 注册全局监听，防离场效果重置
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_LEAVE_FIELD)
			e2:SetLabelObject(c)
			e2:SetOperation(s.lvop)
			Duel.RegisterEffect(e2,tp)
			end
		end
	end
end

function s.disfilter(c,e)
	return c:IsFaceup() and c:IsCanBeDisabledByEffect(e)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 这个回合这个同名卡的②效果适用次数 + 1
	local des_count = Duel.GetFlagEffect(tp,id+1000) + 1
	
	if chk==0 then 
		return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_HAND+LOCATION_ONFIELD,0,des_count,nil)
			and Duel.IsExistingMatchingCard(s.disfilter,tp,0,LOCATION_ONFIELD,1,nil,e)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,des_count,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD)
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local des_count = Duel.GetFlagEffect(tp,id+1000) + 1
	
	local dg = Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if #dg < des_count then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	-- 把那个数量的自己的手卡·场上的卡破坏
	local des_g = dg:Select(tp,des_count,des_count,nil)
	if #des_g > 0 then
		local ct = Duel.Destroy(des_g,REASON_EFFECT)
		-- 破坏数量达标，且对方场上有可无效的卡时处理
		if ct == des_count then
			local ng = Duel.GetMatchingGroup(s.disfilter,tp,0,LOCATION_ONFIELD,nil,e)
			if #ng > 0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
				local sg = ng:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				local tc = sg:GetFirst()
				if tc then
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
			
			-- 处理适用完毕：增加本回合该同名卡效果的适用次数记录
			Duel.RegisterFlagEffect(tp,id+1000,RESET_PHASE+PHASE_END,0,1)
			
			-- 挂载遗言：如果这张卡还在场上，注册防重置的离场监听
			if c:IsRelateToEffect(e) and c:IsFaceup() and c:GetFlagEffect(id+100)==0 then
				c:RegisterFlagEffect(id+100,RESET_EVENT+RESETS_STANDARD,0,0)
				-- 注册全局监听，防离场效果重置
				local e_lv=Effect.CreateEffect(c)
				e_lv:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e_lv:SetCode(EVENT_LEAVE_FIELD)
				e_lv:SetLabelObject(c)
				e_lv:SetOperation(s.lvop)
				Duel.RegisterEffect(e_lv,tp)
			end
		end
	end
end

-- === 附属的离场不入连锁加入手卡 ===
function s.thfilter_rec(c,tp)
	return c:IsAbleToHand() and c:IsControler(tp)
end

function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc then return end
	-- 如果发生离场的群组包含我们锁定的这张卡
	if eg:IsContains(tc) then
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter_rec),tp,LOCATION_REMOVED,0,nil,tp)
		if #g>0 then
			Duel.Hint(HINT_CARD,0,id)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			if #sg>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				if sg:GetFirst():IsLocation(LOCATION_HAND) then
				Duel.ConfirmCards(1-tp,sg)
				Duel.Destroy(sg,REASON_EFFECT)
				end
			end
		end
		e:Reset() -- 任务完成自我销毁
	-- 如果卡片由于转里侧等原因清空了标记，监听器亦自我清理
	elseif tc:GetFlagEffect(id+100)==0 then
		e:Reset()
	end
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
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
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