local s, id = GetID()

function s.initial_effect(c)
	-- 发动处理
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCondition(s.condition1)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	-- 效果处理：对方效果发动时宣言卡名
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.negcon)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE) -- 修改为魔陷区生效
	e1:SetCategory(CATEGORY_DISABLE)	
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
end

-- 1
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp 
end

-- 操作：宣言卡名验证
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	-- 让对手宣言卡名
	local announce_filter = {TYPE_ANY,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(1-tp,table.unpack(announce_filter))	
	
	-- 卡名验证与无效处理
	if ac~=id then
		Duel.NegateActivation(ev)  -- 无效效果
		Duel.Hint(HINT_SOUND,0,aux.Stringid(id,1)) -- 播放音效提示
	end
end

--2
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) then
		Duel.PayLPCost(1-tp,50) -- 支付50生命值
		Duel.BreakEffect()
	else 
		Duel.NegateEffect(ev) -- 不支付则无效效果
	end
end
--0
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3962)
end
function s.check(tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(s.cfilter,1,nil)
		and not g:IsExists(aux.NOT(s.cfilter),1,nil)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return aux.NegateSummonCondition() and s.check(tp)
end