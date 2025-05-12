-- 邪神珠泪融合怪兽
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,62180201,572850,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
        
    -- ①效果：对方怪兽攻守减半
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SET_ATTACK_FINAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetTarget(s.atktg)
    e2:SetValue(s.atkval)
    c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e3:SetValue(s.defval)
	c:RegisterEffect(e3)
    
    -- ②效果：战斗时处理手卡/场上+堆墓
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_ATTACK_ANNOUNCE)
    e4:SetCountLimit(1,10111187)
    e4:SetTarget(s.bttg)
    e4:SetOperation(s.btop)
    c:RegisterEffect(e4)
    
    -- ③效果：被效果送墓时堆墓+烧血
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,1))
    e5:SetCategory(CATEGORY_DECKDES+CATEGORY_DAMAGE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCountLimit(1,10111187+100)
    e5:SetCondition(s.gycon)
    e5:SetTarget(s.gytg)
    e5:SetOperation(s.gyop)
    c:RegisterEffect(e5)
end

-- ①效果：攻守减半
function s.atktg(e,c)
    return c:IsFaceup() and c:GetAttack()>0
end
function s.atkval(e,c)
    return math.ceil(c:GetAttack()/2)
end

function s.defval(e,c)
	return math.ceil(c:GetDefense()/2)
end

-- ②效果：战斗时处理
function s.bttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 
        or Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND+LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function s.btop(e,tp,eg,ep,ev,re,r,rp)
    -- 处理手卡
    if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
        local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
    -- 处理场上
    local sg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
    if #sg>0 then
        Duel.SendtoGrave(sg,REASON_EFFECT)
    end
    -- 自己堆3
    Duel.SendtoGrave(Duel.GetDecktopGroup(tp,3),REASON_EFFECT)
end

-- ③效果：被效果送墓时
function s.gycon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT) and rp==1-tp
end
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
    local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
    if ct>0 then
        local g=Duel.GetDecktopGroup(tp,ct)
        Duel.SendtoGrave(g,REASON_EFFECT)
        local og=Duel.GetOperatedGroup()
        local dam=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)*200
        if dam>0 then
            Duel.Damage(1-tp,dam,REASON_EFFECT)
        end
    end
end