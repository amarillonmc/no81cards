-- 废铁传送机构
function c49811459.initial_effect(c)
    aux.AddCodeList(c,49811459)

    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetCountLimit(1,49811459+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e0)

    -- Effect 1: Protect "Scrap" cards from banishing
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_REMOVE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetTargetRange(LOCATION_ONFIELD,0)
    e1:SetTarget(c49811459.protect)
    c:RegisterEffect(e1)

    -- Effect 2: Special Summon a "Scrap" monster
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c49811459.spcon)
    e2:SetTarget(c49811459.sptg)
    e2:SetOperation(c49811459.spop)
    c:RegisterEffect(e2)

    -- Effect 3: Destroy all non-"Scrap" cards when destroyed
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCondition(c49811459.descon)
    e3:SetTarget(c49811459.destg)
    e3:SetOperation(c49811459.desop)
    c:RegisterEffect(e3)
end

-- Effect 1: Protection from banishing
function c49811459.protect(e,c)
    return c:IsSetCard(0x24)
end

-- Effect 2: Condition for Special Summon
function c49811459.spcon(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    -- 触发条件：对手发动非破坏效果，且来源不是这张卡
    return re:IsActiveType(TYPE_EFFECT) 
        and rp~=tp 
        and (not rc or not rc:IsCode(49811459)) 
        and not re:IsHasCategory(CATEGORY_DESTROY) -- 排除破坏类效果
end

function c49811459.spfilter(c,e,tp)
    return c:IsSetCard(0x24) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
        or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end

function c49811459.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c49811459.spfilter(chkc,e,tp) end
    if chk==0 then 
        return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0)
            and Duel.IsExistingTarget(c49811459.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c49811459.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c49811459.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    local s1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
    local s2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
    local op=0
    Duel.Hint(HINT_SELECTMSG,tp,0)
    if s1 and s2 then 
        op=Duel.SelectOption(tp,aux.Stringid(49811459,1),aux.Stringid(49811459,2))
    elseif s1 then 
        op=Duel.SelectOption(tp,aux.Stringid(49811459,1))
    elseif s2 then 
        op=Duel.SelectOption(tp,aux.Stringid(49811459,2))+1
    else 
        return 
    end
    if op==0 then 
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    else 
        Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP) 
    end

    -- Restriction: Cannot Special Summon same card name using "Scrap Recycler"
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c49811459.splimit(tc:GetCode()))
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end

function c49811459.splimit(code)
    return function(e,c,sump,sumtype,sumpos,targetp,se)
        return c:IsCode(code) and se:GetHandler():IsCode(49811459)
    end
end


-- Effect 3: Destroy all non-"Scrap" cards when destroyed
function c49811459.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT+REASON_DESTROY)
end

function c49811459.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    g:Remove(Card.IsSetCard,nil,0x24) -- Exclude "Scrap" cards
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end

function c49811459.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    g:Remove(Card.IsSetCard,nil,0x24) -- Exclude "Scrap" cards
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
