--星渊虫群 -飞蛇-
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    -- 融合召唤手续：「星渊虫群」怪兽×2只以上
    aux.AddFusionProcFunRep2(c,s.mfilter,2,63,true)
    
    -- 效果①：回卡组并放置永续魔法·陷阱
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.tdcon)
    e1:SetCost(s.tdcost)
    e1:SetTarget(s.tdtg)
    e1:SetOperation(s.tdop)
    c:RegisterEffect(e1)
    
    -- 效果②：不受对方效果影响
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetCondition(s.indcon)
    e2:SetValue(s.efilter)
    c:RegisterEffect(e2)
    
    -- 效果③：攻击力守备力上升
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_MATERIAL_CHECK)
    e3:SetValue(s.valcheck)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetCondition(s.atkcon)
    e4:SetOperation(s.atkop)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
end

-- 融合素材检查
function s.mfilter(c)
    return c:IsSetCard(0x890) and c:IsType(TYPE_MONSTER)
end

-- 效果①条件：融合召唤成功
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

-- 效果①代价：从墓地除外任意数量星渊虫群卡
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    return true
end

function s.costfilter(c)
    return c:IsSetCard(0x890) and c:IsAbleToRemoveAsCost()
end

function s.setfilter(c,tp)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x890) and not c:IsCode(id)
        and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end

function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
    if chk==0 then
        if e:GetLabel()==1 then
            e:SetLabel(0)
            return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE,0,1,nil)
                and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil,tp)
        else return false end
    end
    e:SetLabel(0)
    local rt=Duel.GetTargetCount(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,e:GetHandler())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local cg=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_GRAVE,0,1,rt,nil)
    local ct=cg:GetCount()
    Duel.Remove(cg,POS_FACEUP,REASON_COST)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,ct,ct,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end

function s.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
    local ct=sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==0 then return end
    
    -- 修正：放置的卡数量应该是回去的数量，不受对方场地数量限制
    local ft=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),ct)
    if ft<=0 then return end
    
    local g2=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil,tp)
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local tg=g2:SelectSubGroup(tp,aux.dncheck,false,1,ft)
    if tg then
        local tc=tg:GetFirst()
        while tc do 
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            tc=tg:GetNext()
        end
    end
end

-- 效果②条件：场上有3张以上星渊虫群卡
function s.indfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x890)
end

function s.indcon(e)
    return Duel.IsExistingMatchingCard(s.indfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,3,nil)
end

function s.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

-- 效果③：攻击力守备力上升
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