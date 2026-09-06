--星渊虫群 -刀锋女王 凯瑞甘-
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    -- 融合召唤手续：「星渊虫群」怪兽×2只以上
    aux.AddFusionProcFunRep2(c,s.mfilter,2,63,true)
    
    -- 融合怪兽回到额外卡组
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_LEAVE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(s.retop)
    c:RegisterEffect(e1)
    
    -- 攻击力守备力上升
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_MATERIAL_CHECK)
    e0:SetValue(s.valcheck)
    c:RegisterEffect(e0)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(s.atkcon)
    e2:SetOperation(s.atkop)
    e2:SetLabelObject(e0)
    c:RegisterEffect(e2)
    
    -- 融合召唤限制
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetCode(EFFECT_SPSUMMON_CONDITION)
    e3:SetValue(aux.fuslimit)
    c:RegisterEffect(e3)
    
    -- 跳过回合
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,id)
    e4:SetCost(s.skipcost)
    e4:SetCondition(s.skipcon)
    e4:SetOperation(s.skipop)
    c:RegisterEffect(e4)
end

-- 融合素材检查
function s.mfilter(c)
    return c:IsSetCard(0x890) and c:IsType(TYPE_MONSTER)
end

-- 融合怪兽回到额外卡组
function s.refilter(c,tp)
    return c:IsSetCard(0x890) and c:IsType(TYPE_FUSION) and c:IsControler(tp)
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=eg:Filter(s.refilter,nil,tp)
    if g:GetCount()>0 then
        Duel.SendtoExtraP(g,tp,REASON_EFFECT)
    end
end

-- 攻击力守备力上升
function s.valcheck(e,c)
    local g=c:GetMaterial()
    local atk=0
    for tc in aux.Next(g) do
        atk=atk+tc:GetOriginalLevel()
    end
    e:SetLabel(atk)
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local atk=e:GetLabelObject():GetLabel()*100
    if atk>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        c:RegisterEffect(e2)
    end
end

-- 跳过回合的代价
function s.cfilter(c)
    return c:IsSetCard(0x890) and c:IsType(TYPE_FUSION) and c:IsAbleToRemoveAsCost() and c:IsFaceup()
end

function s.skipcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_EXTRA,0,nil)
    if chk==0 then return g:GetClassCount(Card.GetCode)>=3 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g1=g:SelectSubGroup(tp,aux.dlvcheck,false,3,3,tp)
    Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

-- 跳过回合的条件
function s.skipcon(e,tp)
    return Duel.GetTurnPlayer() == tp 
end

-- 跳过回合的操作
function s.skipop(e,tp)
    local c = e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_SKIP_TURN)
    e1:SetTargetRange(0,1)
    e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
    Duel.RegisterEffect(e1,tp)
    Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_EP)
    e2:SetTargetRange(1,0)
    e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
    Duel.RegisterEffect(e2,tp)
end