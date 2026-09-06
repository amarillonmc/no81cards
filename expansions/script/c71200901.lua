--星渊虫群 -异龙-
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    -- 融合召唤手续：「星渊虫群」怪兽×2只以上
    aux.AddFusionProcFunRep2(c,s.mfilter,2,63,true)
    
    -- 效果①：翻卡特殊召唤
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    
    -- 效果②：对方场上卡回卡组
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(s.tdcon)
    e2:SetTarget(s.tdtg)
    e2:SetOperation(s.tdop)
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

-- 效果①代价：除外场上·墓地的星渊虫群卡
function s.costfilter(c)
    return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
        and c:IsSetCard(0x890)
        and c:IsAbleToRemoveAsCost()
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)
    if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,ct,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,ct,ct,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 end
end

function s.spfilter(c,e,tp)
    return c:IsSetCard(0x890) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<4 then return end
    Duel.ConfirmDecktop(tp,4)
    local g=Duel.GetDecktopGroup(tp,4)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    
    if ft>0 and g:FilterCount(s.spfilter,nil,e,tp)>0
        and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        Duel.DisableShuffleCheck()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:FilterSelect(tp,s.spfilter,1,ft,nil,e,tp)
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        g:Sub(sg)
    end
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REVEAL)
end

-- 效果②条件：使用4只以上素材融合召唤
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsSummonType(SUMMON_TYPE_FUSION) and c:GetMaterialCount()>=4
end

function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end

function s.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
    Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
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