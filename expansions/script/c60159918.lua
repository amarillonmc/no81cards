--银龙裁决 泰隆
function c60159918.initial_effect(c)
	c:SetUniqueOnField(1,1,60159918)
	c:EnableReviveLimit()
	--cannot special summon
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.synlimit)
    c:RegisterEffect(e0)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c60159918.sprcon)
    e2:SetOperation(c60159918.sprop)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
    c:RegisterEffect(e2)
	--lv
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_CHANGE_LEVEL)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c60159918.val)
    c:RegisterEffect(e4)
	--atk
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_SET_BASE_ATTACK)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c60159918.adval)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_SET_BASE_DEFENSE)
    c:RegisterEffect(e5)
	--atk
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60159918,0))
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c60159918.atkcon)
    e1:SetCost(c60159918.spcost)
    e1:SetTarget(c60159918.target)
    e1:SetOperation(c60159918.atkop)
    c:RegisterEffect(e1)
end
function c60159918.sprfilter1(c,tp)
    local lv=c:GetLevel()
    return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGraveAsCost()
        and Duel.IsExistingMatchingCard(c60159918.sprfilter2,tp,LOCATION_MZONE,0,1,nil,lv)
end
function c60159918.sprfilter2(c,lv)
    return c:IsFaceup() and c:GetLevel()~=lv and not c:IsType(TYPE_TUNER) and not c:IsType(TYPE_XYZ)
		and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGraveAsCost()
end
function c60159918.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetMZoneCount(tp)>-2
        and Duel.IsExistingMatchingCard(c60159918.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c60159918.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=Duel.SelectMatchingCard(tp,c60159918.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=Duel.SelectMatchingCard(tp,c60159918.sprfilter2,tp,LOCATION_MZONE,0,1,1,nil,g1:GetFirst():GetLevel())
    g1:Merge(g2)
    Duel.SendtoGrave(g1,REASON_COST)
    c:SetMaterial(g1)
end
function c60159918.val(e,c)
	local g=c:GetMaterial()
	local lv=0
	local tc=g:GetFirst()
    while tc do
        lv=lv+(tc:GetLevel())
        tc=g:GetNext()
    end
    return lv
end
function c60159918.adval(e,c)
    return e:GetHandler():GetLevel()*300
end
function c60159918.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c60159918.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
    Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60159918.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c60159918.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue((tc:GetAttack())/2)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
        e5:SetValue((tc:GetDefense())/2)
		c:RegisterEffect(e5)
        tc=g:GetNext()
    end
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetCondition(c60159918.thcon)
    e1:SetOperation(c60159918.thop)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c60159918.thfilter(c)
    return c:IsFaceup() and (c:GetAttack()~=c:GetBaseAttack() or c:GetDefense()~=c:GetBaseDefense())
end
function c60159918.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c60159918.thfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c60159918.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,60159918)
    local sg=Duel.GetMatchingGroup(c60159918.thfilter,tp,0,LOCATION_MZONE,nil)
    local ct=Duel.Destroy(sg,REASON_EFFECT)
    if ct>0 then
        Duel.Damage(1-tp,ct*600,REASON_EFFECT)
    end
end
