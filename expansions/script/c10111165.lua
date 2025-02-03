-- 战华之毒-李优
local s,id,o=GetID()
function s.initial_effect(c)
    
	--SP sum itself
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,5))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,id)
	e0:SetCost(s.spcost)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)
    
    -- 效果①：怪兽效果连锁处理
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id+100)
    e1:SetCondition(s.negcon)
    e1:SetCost(s.negcost)
    e1:SetTarget(s.negtg)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    
    -- 效果②：提供抗性
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(s.etarget)
    e2:SetValue(s.efilter)
    c:RegisterEffect(e2)
    
    -- 新效果：卡被除外时触发
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE+CATEGORY_DRAW)    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_REMOVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_MZONE) -- 关键修正点
    e3:SetCountLimit(1,id+200)
    e3:SetTarget(s.rmtg)
    e3:SetOperation(s.rmop)
    c:RegisterEffect(e3)
end

function s.spcostfilter(c)
	return c:IsLevelAbove(6) and c:IsRace(RACE_BEASTWARRIOR) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.spcostfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.spcostfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

-- 效果①条件修正
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_MONSTER) and rp==1-tp and Duel.IsChainDisablable(ev)
end

-- 代价处理修正（永续魔陷判定）
function s.costfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x137) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost()
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end

-- 目标处理修正
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_FZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_FZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

-- ①效果操作
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

-- 效果②抗性修正
function s.etarget(e,c)
    return c:IsCode(79582540) -- 董颖
end

function s.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

-- 修正后的效果②目标处理
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local has_dy= Duel.IsExistingMatchingCard(s.dyfilter,tp,LOCATION_MZONE,0,1,nil)
        return has_dy or true -- 至少存在伤害/抽卡选项
    end
    -- 动态设置可能的操作信息
    local has_dy= Duel.IsExistingMatchingCard(s.dyfilter,tp,LOCATION_MZONE,0,1,nil)
    if has_dy then
        Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,tp,1000)
    end
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

-- 效果②操作：精确处理选项索引
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    local has_dy=Duel.IsExistingMatchingCard(s.dyfilter,tp,LOCATION_MZONE,0,1,nil)
    local opts={}
    
    -- 动态构建选项（关键修正点）
    if has_dy then
        table.insert(opts,aux.Stringid(id,2)) -- 选项0：加攻
    end
    table.insert(opts,aux.Stringid(id,3))     -- 选项X：伤害
    table.insert(opts,aux.Stringid(id,4))     -- 选项Y：抽卡
    
    -- 无选项时返回
    if #opts==0 then return end
    
    -- 选择选项
    local op=Duel.SelectOption(tp,table.unpack(opts))
    
    -- 处理选项（新索引映射方案）
    if has_dy then
        -- 情况A：存在董颖选项
        if op==0 then
            -- 处理加攻效果
            local g=Duel.SelectMatchingCard(tp,s.dyfilter,tp,LOCATION_MZONE,0,1,1,nil)
            if #g>0 then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(1000)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                g:GetFirst():RegisterEffect(e1)
            end
            return
        else
            op=op-1 -- 调整后续选项索引
        end
    end
    
    -- 统一处理第二层选项（关键修复）
    if op==0 then
        Duel.Damage(1-tp,1000,REASON_EFFECT)
    elseif op==1 then
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end

-- 精确过滤函数（增加位置和状态验证）
function s.dyfilter(c)
    return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsCode(79582540)
end