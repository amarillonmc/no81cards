-- 凄陌寒昼·血绽霜芒
local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,43492020,43492000,0x3f15)
    --①效果：解放自身和另一只本家，检索怪兽和仪式魔法
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.cost1)
    e1:SetTarget(s.tg1)
    e1:SetOperation(s.op1)
    c:RegisterEffect(e1)

    --②效果：墓地诱发，当特殊召唤臻冰之剑成功时，令对方下次效果变为堆墓
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,id+1)
    e2:SetCondition(s.con2)
    e2:SetTarget(s.tg2)
    e2:SetOperation(s.op2)
    c:RegisterEffect(e2)
end

--判断卡片能否被解放（兼容魔陷与手卡）
function s.releasefilter(c,tp)
    local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
    if re then
        local val=re:GetValue()
        if val and val(re,c) then return false end
    end
    return c:IsSetCard(0x3f15)
end

function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return s.releasefilter(c,tp) and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,tp,c)
    end
    --选择另一只本家
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,s.releasefilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,tp)
    --合并自身并解放
    g:AddCard(c)
    Duel.Release(g,REASON_COST)
end

--①效果目标：检查是否有符合条件的怪兽和仪式魔法
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local b1=Duel.IsExistingMatchingCard(s.monfilter,tp,LOCATION_DECK,0,1,nil)
        local b2=Duel.IsExistingMatchingCard(s.spellfilter,tp,LOCATION_DECK,0,1,nil)
        return b1 and b2
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end

--怪兽过滤：本家怪兽
function s.monfilter(c)
    return c:IsSetCard(0x3f15) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
--仪式魔法过滤：本家仪式魔法
function s.spellfilter(c)
    return c:IsSetCard(0x3f15) and bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
end

--①效果操作：分别选择并加入手卡
function s.op1(e,tp,eg,ep,ev,re,r,rp)
    --选择怪兽
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=Duel.SelectMatchingCard(tp,s.monfilter,tp,LOCATION_DECK,0,1,1,nil)
    --选择仪式魔法
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=Duel.SelectMatchingCard(tp,s.spellfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g1>0 and #g2>0 then
        g1:Merge(g2)
        Duel.SendtoHand(g1,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g1)
    end
end

--②效果条件：自己特殊召唤臻冰之剑成功
function s.con2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsCode,1,nil,43492020) and eg:IsExists(Card.IsControler,1,nil,tp)
end

--②效果目标：无特殊要求
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end

--②效果操作：注册监听，将对方下次发动效果变为堆墓
function s.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    --监听对方发动效果
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1)
    e1:SetCondition(s.negcon)
    e1:SetOperation(s.negop)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetLabel(tp)
    Duel.RegisterEffect(e1,tp)
end

--监听条件：对方发动效果
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
    local p=e:GetLabel()
    return rp==1-p and re:IsActivated()
end

--监听操作：注册连锁处理时替换
function s.negop(e,tp,eg,ep,ev,re,r,rp)
    local p=e:GetLabel()
    local c=e:GetHandler()
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetCountLimit(1)
    e2:SetCondition(s.dis2con)
    e2:SetOperation(s.dis2op)
    e2:SetLabelObject(re)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,p)
end

--替换条件：与触发的效果匹配
function s.dis2con(e,tp,eg,ep,ev,re,r,rp)
    return re and e:GetLabelObject() and re==e:GetLabelObject()
end

--替换操作：改成对方选自身卡组1只本家怪兽送墓
function s.dis2op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,id)
    Duel.ChangeChainOperation(ev, s.repop)
end

--替换后的实际处理：对方选择自己卡组1只本家怪兽送墓
function s.repop(e,tp,eg,ep,ev,re,r,rp)
    --tp是发动这个效果（血绽霜芒）的玩家，1-tp是发动原效果的对方
    local opp=1-tp
    Duel.Hint(HINT_SELECTMSG,opp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(opp,s.monfilter,opp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end