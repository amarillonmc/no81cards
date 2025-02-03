-- 卡片编号：10111166
local s,id=GetID()
function s.initial_effect(c)
    -- 效果①：自己·对方的准备阶段特殊召唤到对方场上
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.target)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    
    -- 效果②注册（修正事件类型）
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) -- F表示强制发动
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.atkcon)
    e2:SetTarget(s.atktg)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    
    -- 效果③：被除外时抽1张并丢弃1张
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,id+1)
	e5:SetTarget(s.drtg)
	e5:SetOperation(s.drop)
	c:RegisterEffect(e5)
end

-- 效果①：准备阶段特殊召唤到对方场上
function s.spcon(e,tp,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp or Duel.GetTurnPlayer()==1-tp
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,1-tp,false,false,POS_FACEUP_ATTACK) then
        -- 不能解放
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        e1:SetValue(1)
        c:RegisterEffect(e1,true)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
        c:RegisterEffect(e2,true)
        local e3=e1:Clone()
        e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
        c:RegisterEffect(e3,true)
        local e4=e1:Clone()
        e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
        c:RegisterEffect(e4,true)
        -- 离场除外
        local e5=Effect.CreateEffect(c)
        e5:SetType(EFFECT_TYPE_SINGLE)
        e5:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e5:SetValue(LOCATION_REMOVED)
        c:RegisterEffect(e5,true)
    end
    Duel.SpecialSummonComplete()
end

-- 效果②：召唤/特召削弱
function s.atkcon(e,tp,eg,ep,ev,re,r,rp) -- 正确接收eg参数
    return eg:IsExists(s.atkfilter,1,nil,tp,e:GetHandler())
end

function s.atkfilter(c,tp,selfc)
    return c:IsSummonPlayer(tp) and  -- 自己的召唤
        c:IsFaceup() and            -- 表侧表示
        c:IsLocation(LOCATION_MZONE) and -- 在怪兽区
        c~=selfc                    -- 排除自身
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=eg:Filter(s.atkfilter,nil,tp,e:GetHandler())
    Duel.SetTargetCard(g)
    local dam=#g*400
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,dam)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    if tc and tc:IsFaceup() then
        -- 降低攻击力
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-400)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        -- 降低守备力
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e2)
        -- 给予伤害
        Duel.Damage(tp,400,REASON_EFFECT)
    end
end

-- 效果③：被除外时抽1张并丢弃1张
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_ZOMBIE)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.ShuffleHand(tp)
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end