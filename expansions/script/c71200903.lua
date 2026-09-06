--星渊虫群 -潜伏者-
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    -- 融合召唤手续：「星渊虫群」怪兽×2只以上
    aux.AddFusionProcFunRep2(c,s.mfilter,2,63,true)
    
    -- 效果①：除外并特殊召唤
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.rmtg)
    e1:SetOperation(s.rmop)
    c:RegisterEffect(e1)
    
    -- 效果②：攻击力守备力上升
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_MATERIAL_CHECK)
    e2:SetValue(s.valcheck)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(s.atkcon)
    e3:SetOperation(s.atkop)
    e3:SetLabelObject(e2)
    c:RegisterEffect(e3)
end

-- 融合素材检查
function s.mfilter(c)
    return c:IsSetCard(0x890) and c:IsType(TYPE_MONSTER)
end

-- 效果①：除外并特殊召唤
function s.rmfilter(c)
    return c:IsFaceup() and c:IsAbleToRemove()
end

function s.spfilter(c,e,tp,clv)
    local lv=c:GetLevel()
    return lv>0 and c:IsSetCard(0x890) and (lv==clv+1 or lv==clv-1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.rmfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,s.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:GetLevel()>0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp,tc:GetLevel())
        if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=g:Select(tp,1,1,nil)
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end

-- 效果②：攻击力守备力上升
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