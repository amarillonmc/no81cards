-- 卡号：10111176
-- 怪兽名称：假设名称为"机械王统御者"
local s,id=GetID()

function s.initial_effect(c)
	aux.AddCodeList(c,10111169)
    -- ①：装备效果
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.eqcon)
    e1:SetTarget(s.eqtg)
    e1:SetOperation(s.eqop)
    c:RegisterEffect(e1)

    -- ②：装备效果赋予
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_SET_CONTROL)
    e2:SetValue(s.ctval)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_CHANGE_RACE)
    e3:SetValue(RACE_MACHINE)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetValue(s.atkval)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e5)

    -- ③：离场检索效果
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,1))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_TO_GRAVE)
    e6:SetProperty(EFFECT_FLAG_DELAY)
    e6:SetCountLimit(1,id+1)
    e6:SetCondition(s.thcon)
    e6:SetTarget(s.thtg)
    e6:SetOperation(s.thop)
    c:RegisterEffect(e6)
end

-- ①：装备条件（有无敌机械王存在）
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.mechfilter,tp,LOCATION_MZONE,0,1,nil)
end

-- ①：装备目标选择
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end

-- ①：装备操作
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsFacedown() then
        Duel.Equip(tp,c,tc)
        -- 装备限制
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetValue(s.eqlimit)
        e1:SetLabelObject(tc)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1)
    end
end

function s.eqlimit(e,c)
    return c==e:GetLabelObject()
end

-- ②：控制权转移
function s.ctval(e,c)
    return e:GetHandlerPlayer()
end

-- ②：攻击力/守备力计算（排除被装备的怪兽）
function s.atkval(e,c)
    local ec=e:GetHandler():GetEquipTarget() -- 获取被装备的怪兽
    local g=Duel.GetMatchingGroup(s.mechfilter2,c:GetControler(),LOCATION_MZONE,0,ec)
    return #g*100
end

-- ③：离场条件（从场上送墓）
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

-- ③：检索过滤
function s.thfilter(c)
    return aux.IsCodeOrListed(c,10111169) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

-- ③：检索目标
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- ③：检索操作
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

-- 辅助函数
function s.mechfilter(c)
    return c:IsCode(10111169) and c:IsFaceup()
end

function s.mechfilter2(c)
    return c:IsRace(RACE_MACHINE) and c:IsFaceup()
end