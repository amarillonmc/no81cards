local s,id=GetID()
function s.initial_effect(c)
    -- ①效果：特殊召唤+封锁
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
end

function s.spfilter(c,e,tp)
    return c:IsLocation(LOCATION_HAND|LOCATION_GRAVE) 
        and c:GetBaseAttack()==2500
        and c:GetBaseDefense()==2000
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local tc=g:GetFirst()
        -- 修正点1：使用IsOriginalType检查原本的通常怪兽
        if tc:IsType(TYPE_NORMAL) then
            -- 修正点2：添加效果到当前回合
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
            e1:SetTargetRange(0,1)
            e1:SetTarget(s.splimit)
            e1:SetReset(RESET_PHASE+PHASE_END)
            Duel.RegisterEffect(e1,tp)
            
            local e2=e1:Clone()
            e2:SetCode(EFFECT_CANNOT_SUMMON)
            Duel.RegisterEffect(e2,tp)
            
            local e3=Effect.CreateEffect(e:GetHandler())
            e3:SetType(EFFECT_TYPE_FIELD)
            e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e3:SetCode(EFFECT_CANNOT_ACTIVATE)
            e3:SetTargetRange(0,1)
            e3:SetValue(s.aclimit)
            e3:SetReset(RESET_PHASE+PHASE_END)
            Duel.RegisterEffect(e3,tp)
        end
    end
end

-- 修正点3：精确条件判断
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return (c:GetBaseAttack()>=2500 or c:GetBaseDefense()>=2000)
end

-- 新增：禁止发动相关效果
function s.aclimit(e,re,tp)
    local rc=re:GetHandler()
    return re:IsActiveType(TYPE_MONSTER) 
        and (rc:GetBaseAttack()>=2500 or rc:GetBaseDefense()>=2000)
        and rc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false)
end