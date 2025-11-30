--朦雨的远目·艾科
local s,id,o=GetID()
function s.initial_effect(c)
	--连接召唤：包含「朦雨」怪兽的怪兽3只以上
	aux.AddLinkProcedure(c,nil,2,99,s.lcheck)
	c:EnableReviveLimit()
	
	--①：连接区有怪兽则加攻+抗性
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.cond1)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	
	--②：三选一 (二速)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(2,id)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
	
	--③：暂时除外+回复
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+1)
	e4:SetCondition(s.rmcon)
	e4:SetCost(s.rmcost)
	e4:SetTarget(s.rmtg)
	e4:SetOperation(s.rmop)
	c:RegisterEffect(e4)
end

-- 连接素材检查
function s.lfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_SYNCHRO)
end
function s.lcheck(g)
	return g:IsExists(s.lfilter,1,nil)
end

-- === 效果① ===
function s.cond1(e)
	return e:GetHandler():GetLinkedGroupCount()>0
end

-- === 效果② ===
function s.tgfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc,atk) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,0,LOCATION_MZONE,1,nil,atk) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,atk)
	local tc=g:GetFirst()
	
	-- 构建选项
	-- 选项0: 破坏 (默认总是显示，除非有极特殊情况，但作为效果选项通常列出)
	-- 选项1: 无效 (需要表侧且非无效状态)
	-- 选项2: 变成里侧 (需要可翻转)
	
	local b_des=true 
	local b_neg=aux.NegateMonsterFilter(tc)
	local b_set=tc:IsCanTurnSet()
	
	local ops={}
	local opval={}
	local off=1
	
	-- 选项：破坏
	ops[off]=aux.Stringid(id,2)
	opval[off]=0
	off=off+1
	
	-- 选项：效果无效
	if b_neg then
		ops[off]=aux.Stringid(id,3)
		opval[off]=1
		off=off+1
	end
	
	-- 选项：变成里侧
	if b_set then
		ops[off]=aux.Stringid(id,4)
		opval[off]=2
		off=off+1
	end
	
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op+1]
	e:SetLabel(sel)
	
	if sel==0 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	elseif sel==1 then
		e:SetCategory(CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	elseif sel==2 then
		e:SetCategory(CATEGORY_POSITION)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	end
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local sel=e:GetLabel()
	if tc:IsRelateToEffect(e) then
		if sel==0 then
			Duel.Destroy(tc,REASON_EFFECT)
		elseif sel==1 then
			if tc:IsFaceup() and not tc:IsDisabled() then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		elseif sel==2 then
			if tc:IsFaceup() then
				Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end

-- === 效果③ ===
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end

function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	end
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
end