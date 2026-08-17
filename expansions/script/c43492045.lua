-- 凄陌寒昼·千里冰封
local s,id,o=GetID()
function s.initial_effect(c)
    -- ① 发动时可选从卡组选1张本家卡解放
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)

    -- ② 免疫效果：不成为对象、不被效果破坏、效果不被无效化
    -- 范围：手卡、怪兽区、魔陷区、场地区、墓地、除外
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0)
    e2:SetTarget(s.immtg)
    e2:SetValue(1)
    c:RegisterEffect(e2)

    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0)
    e3:SetTarget(s.immtg)
    e3:SetValue(1)
    c:RegisterEffect(e3)

    -- 效果不会被无效化
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetValue(s.effectfilter)
	c:RegisterEffect(e4)

    -- ③ 被解放时回场
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_RELEASE)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetTarget(s.reltg)
    e5:SetOperation(s.relop)
    c:RegisterEffect(e5)
end

-- 免疫目标过滤：自己的「凄陌寒昼」卡
function s.immtg(e,c)
    return c:IsSetCard(0x3f15) and c:IsControler(e:GetHandlerPlayer()) and c:IsFaceupEx()
end

-- 免疫无效效果的判定
function s.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0x3f15) and bit.band(loc,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)~=0
end

-- ① 发动效果处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    -- 询问是否解放
    if not Duel.IsExistingMatchingCard(s.relfilter,tp,LOCATION_DECK,0,1,nil) then return end
    if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,s.relfilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        -- 将卡组卡送去墓地并视为解放
        Duel.SendtoGrave(tc,REASON_RELEASE)
        -- 触发EVENT_RELEASE，让相关效果可以发动
        Duel.RaiseEvent(Group.FromCards(tc),EVENT_RELEASE,e,REASON_RELEASE,tp,tp,0)
    end
end

-- ① 解放过滤：任意本家卡，且不受“不能解放”影响
function s.relfilter(c)
    local tp=c:GetControler()
    local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
    if re then
        local val=re:GetValue()
        if val and val(re,c) then return false end
    end
    return c:IsSetCard(0x3f15)
end

-- ③ 目标检查
function s.reltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end

-- ③ 操作：放置到场地区（王谷检测后）
function s.relop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    -- 破坏原有场地
    local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
    if fc then
        Duel.SendtoGrave(fc,REASON_RULE)
    end
    Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
end