-- 卡片名：源能特工·暗影
local s, id = GetID()
s.source_set = 0x5962  -- 源能战术字段
s.token_id = 95021055  -- 幽影衍生物ID（需确认实际ID）

function s.initial_effect(c)
	-- 效果①：自己主要阶段2从手卡特殊召唤（规则效果）
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon1)
	c:RegisterEffect(e1)

	-- 效果②：以对方场上1只怪兽为对象，变守备并检索
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.postg)
	e2:SetOperation(s.posop)
	c:RegisterEffect(e2)

	-- 效果③：自己·对方回合，在对方场上特召衍生物，并赋予自身效果
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+100+EFFECT_COUNT_CODE_DUEL)  -- 决斗中一次
	e3:SetTarget(s.tokentg)
	e3:SetOperation(s.tokenop)
	c:RegisterEffect(e3)
end

-- 效果①条件
function s.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

-- 效果②目标
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
			and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thfilter(c)
	return c:IsSetCard(s.source_set) and c:IsAbleToHand()
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsAttackPos() then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		end
		-- 直到下个回合结束，不能变更表示形式
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
	end
	-- 检索源能战术卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- 效果③目标
function s.tokentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK)
end

-- 效果③操作
function s.tokenop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	-- 在对方场上特殊召唤衍生物
	local token=Duel.CreateToken(tp,s.token_id)
	if Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)==0 then return end

	-- 全局效果：对方不能发动包含从卡组特召怪兽的魔法陷阱（依赖于衍生物存在）
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(s.tokenfiltercon)
	e1:SetValue(s.tokenlimit)
	e1:SetLabelObject(token)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)

	-- 衍生物在回合结束时破坏（不入连锁）
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabelObject(token)
	e2:SetOperation(s.tokendestroy)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)

	-- 给自身附加一个临时效果（直到回合结束）：可以破坏衍生物并移动
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTarget(s.movetg)
	e3:SetOperation(s.moveop)
	c:RegisterEffect(e3)
end

-- 条件：衍生物存在且在自己场上（对方场上）
function s.tokenfiltercon(e)
	local token=e:GetLabelObject()
	return token and token:IsLocation(LOCATION_MZONE) and token:IsControler(1-e:GetHandlerPlayer())
end

-- 禁止的值：检查效果是否包含从卡组特召怪兽的魔法陷阱
function s.tokenlimit(e,re,tp)
	local ev=Duel.GetCurrentChain()
	if ev==0 then return false end
	local ex,_,_,_,loc=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	return ex and (loc & LOCATION_DECK) == LOCATION_DECK and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end

-- 回合结束时破坏衍生物
function s.tokendestroy(e,tp,eg,ep,ev,re,r,rp)
	local token=e:GetLabelObject()
	if token and token:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(token,REASON_RULE)
	end
end

-- 附加的移动效果目标
function s.movetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCode(s.token_id) end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsCode,tp,0,LOCATION_MZONE,1,nil,s.token_id)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsCode,tp,0,LOCATION_MZONE,1,1,nil,s.token_id)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.moveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	if not tc or not tc:IsRelateToEffect(e) then return end
	local seq=tc:GetSequence()
	if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
	-- 检查目标格子是否可用（在对方场上）
	local zone = 0
	if seq>=0 and seq<=4 then
		zone = 1 << seq
	else
		return
	end
	-- 转移控制权到对方并放置在指定格子
	if Duel.GetControl(c, 1-tp, 0, 0, zone) then
		-- 此卡效果无效化
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		-- 破坏左右相邻的卡（现在在对方场上）
		local left_seq=seq-1
		local right_seq=seq+1
		local g=Group.CreateGroup()
		if left_seq>=0 then
			local lc=Duel.GetFieldCard(1-tp, LOCATION_MZONE, left_seq)
			if lc then g:AddCard(lc) end
		end
		if right_seq<=4 then
			local rc=Duel.GetFieldCard(1-tp, LOCATION_MZONE, right_seq)
			if rc then g:AddCard(rc) end
		end
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end