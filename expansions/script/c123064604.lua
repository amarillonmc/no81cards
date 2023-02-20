--帝王の重圧
function c123064604.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,123064604+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c123064604.target)
    e1:SetOperation(c123064604.activate)
    c:RegisterEffect(e1)
    --cannot set
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_MSET)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(0,1)
    e2:SetCondition(c123064604.discon)
    e2:SetTarget(aux.TRUE)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e3)
    local e4=e2:Clone()
    e4:SetCode(EFFECT_CANNOT_TURN_SET)
    c:RegisterEffect(e4)
    local e5=e2:Clone()
    e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e5:SetTarget(c123064604.sumlimit)
    c:RegisterEffect(e5)
    --negate
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_NEGATE+CATEGORY_SUMMON)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_CHAINING)
    e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e6:SetRange(LOCATION_SZONE)
    e6:SetCountLimit(1)
    e6:SetCondition(c123064604.ngcon)
    e6:SetTarget(c123064604.ngtg)
    e6:SetOperation(c123064604.ngop)
    c:RegisterEffect(e6)
end

function c123064604.spfilter(c,e,tp)
    return c:GetAttack()==800 and c:GetDefense()==1000 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c123064604.thfilter(c)
    return c:GetAttack()==2800 and c:GetDefense()==1000 and c:IsAbleToHand()
end
function c123064604.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.IsExistingMatchingCard(c123064604.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    local b2=Duel.IsExistingMatchingCard(c123064604.thfilter,tp,LOCATION_DECK,0,1,nil)
    if chk==0 then return true end
    local op=2
    if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(123064604,3)) then
        if b1 and b2 then
            op=Duel.SelectOption(tp,aux.Stringid(123064604,0),aux.Stringid(123064604,1))
        elseif b1 and not b2 then
            op=Duel.SelectOption(tp,aux.Stringid(123064604,0))
        elseif not b1 and b2 then
            op=Duel.SelectOption(tp,aux.Stringid(123064604,1))+1
        end
        if op==0 then
            e:SetCategory(CATEGORY_SPECIAL_SUMMON)
            Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
        else
            e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
            Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
        end
    end
    e:SetLabel(op)
end
function c123064604.activate(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabel()==2 or not e:GetHandler():IsRelateToEffect(e) then return end
    local c=e:GetHandler()
    if e:GetLabel()==0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c123064604.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
        end
    elseif e:GetLabel()==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c123064604.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end

function c123064604.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return bit.band(sumpos,POS_FACEDOWN)>0
end
function c123064604.cfilter(c)
    return bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c123064604.discon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
        and Duel.IsExistingMatchingCard(c123064604.cfilter,tp,LOCATION_MZONE,0,1,nil)
        and not Duel.IsExistingMatchingCard(c123064604.cfilter,tp,0,LOCATION_MZONE,1,nil)
end

function c123064604.ngcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if rc:IsType(TYPE_LINK) then return false end
    if not rc:IsType(TYPE_XYZ) then 
        local lv=rc:GetLevel()
        return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and ep~=tp
            and Duel.IsExistingMatchingCard(c123064604.lvfilter,tp,LOCATION_HAND,0,1,nil,lv)
    else 
        local rk=rc:GetRank()
        return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and ep~=tp
            and Duel.IsExistingMatchingCard(c123064604.rkfilter,tp,LOCATION_HAND,0,1,nil,rk)
    end
end
function c123064604.lvfilter(c,lv)
    return c:GetLevel()>=lv and (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)) and not c:IsPublic()
end
function c123064604.rkfilter(c,rk)
    return c:GetLevel()>=rk and (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)) and not c:IsPublic()
end
function c123064604.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local rc=re:GetHandler()
    if not rc:IsType(TYPE_XYZ) then 
        local lv=rc:GetLevel()
        if chk==0 then return Duel.IsExistingMatchingCard(c123064604.lvfilter,tp,LOCATION_HAND,0,1,nil,lv) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local g=Duel.SelectMatchingCard(tp,c123064604.lvfilter,tp,LOCATION_HAND,0,1,1,nil,lv)
        Duel.ConfirmCards(1-tp,g)
        local tc=g:GetFirst()
        e:SetLabelObject(tc)
        tc:RegisterFlagEffect(123064604,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
    else 
        local rk=rc:GetRank()
        if chk==0 then return Duel.IsExistingMatchingCard(c123064604.rkfilter,tp,LOCATION_HAND,0,1,nil,rk) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local g=Duel.SelectMatchingCard(tp,c123064604.rkfilter,tp,LOCATION_HAND,0,1,1,nil,rk)
        Duel.ConfirmCards(1-tp,g)
        local tc=g:GetFirst()
        e:SetLabelObject(tc)
        tc:RegisterFlagEffect(123064604,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
    end
    Duel.ShuffleHand(tp)
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,tc,1,0,0)
end
function c123064604.filter(c)
    return c:GetFlagEffect(123064604)~=0 and (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1))
end
function c123064604.ngop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local c=e:GetHandler()
    local rc=re:GetHandler()
    local tc=e:GetLabelObject()
    if not (tc or tc:GetFlagEffect(123064604)~=0) then return end
    if tc then
        local s1=tc:IsSummonable(true,nil,1)
        local s2=tc:IsMSetable(true,nil,1)
        if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
            Duel.Summon(tp,tc,true,nil,1)
        elseif s2 then
            Duel.MSet(tp,tc,true,nil,1)
        else
            return
        end
    end
    Duel.NegateEffect(ev)
    Duel.ShuffleHand(tp)
end
