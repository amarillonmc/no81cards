--璇序锋峦-熏"花嶂"
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

	--②：降防，赋予连锁内全抗，下次发动效果时破坏
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.imtg)
	e2:SetOperation(s.imop)
	c:RegisterEffect(e2)

	--③：一时除外系统 (状态机)
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
	-- ev == Duel.GetCurrentChain() 确保只在连锁开始处理（最高连锁排位）时询问一次
	-- id是公开标记，id+1是本个连锁已拒绝公开的屏蔽标记
	return ev==Duel.GetCurrentChain() and c:GetFlagEffect(id)==0 and c:GetFlagEffect(id+1)==0
end

function s.revop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then -- "是否公开此卡以满足后续发动条件？"
		Duel.Hint(HINT_CARD,0,id)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4)) -- "持续公开中"
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	else
		-- 拒绝的话直到这个连锁处理完之前都不再问
		c:RegisterFlagEffect(id+1,RESET_CHAIN,0,1)
	end
end

function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end

function s.desfilter(c)
	return c:IsSetCard(0x3615) and c:IsDestructable()
end

function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil)
		and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end

function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsSummonable(true,nil) then
			Duel.Summon(tp,c,true,nil)
		end
	end
end

-- === 效果②：降防/连锁内全抗/下次发动破坏 ===
function s.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDefense()>=500 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,c,1,tp,-500)
end

function s.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:GetDefense()>=500 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)

		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc then
			-- 赋予全抗：添加 RESET_CHAIN，直至该连锁处理完毕
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_IMMUNE_EFFECT)
			e2:SetValue(s.efilter)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			tc:RegisterEffect(e2)

			-- 下次发动效果时破坏 (没有RESET_CHAIN，只要此怪兽不离场便一直留存监视)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_CHAINING)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCondition(s.descon)
			e3:SetOperation(s.desop)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3,true)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3)) -- "下次效果发动时破坏"
		end
	end
end

function s.efilter(e,re)
	return re:GetHandler()~=e:GetHandler()
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	e:Reset() -- 触发后自毁解绑
end

-- === 效果③：除外/回场状态机 ===
function s.op_adjust(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	if ph==PHASE_MAIN1 or ph==PHASE_MAIN2 then
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
	if ph==PHASE_MAIN1 or ph==PHASE_MAIN2 then return end
	if ev>=2 and ep==tp and c:IsLocation(LOCATION_REMOVED) and c:GetFlagEffect(id+2)>0 then
		Duel.ReturnToField(c)
	end
end

function s.op_solving(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	if ph==PHASE_MAIN1 or ph==PHASE_MAIN2 then return end
	if ev==1 and c:IsLocation(LOCATION_MZONE) then
		if Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
			c:RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD,0,1)
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
		end
	end
end