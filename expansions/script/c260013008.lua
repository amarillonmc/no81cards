--人型掃討兵器 KOS-MOS Re
function c260013008.initial_effect(c)
    --sp summon
    local e1=Effect.CreateEffect(c)
    --e1:SetDescription(aux.Stringid(260013008,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,260013008)
    e1:SetCondition(c260013008.spcon)
    e1:SetTarget(c260013008.sptg)
    e1:SetOperation(c260013008.spop)
    c:RegisterEffect(e1)
    
    --destroy
    local e2=Effect.CreateEffect(c)
    --e2:SetDescription(aux.Stringid(260013008,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,260014008)
    e2:SetTarget(c260013008.destg)
    e2:SetOperation(c260013008.desop)
    c:RegisterEffect(e2)
    
    --damage
    local e3=Effect.CreateEffect(c)
    --e3:SetDescription(aux.Stringid(260013008,1))
    e3:SetCategory(CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_XMATERIAL)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetCondition(c260013008.damcon)
    e3:SetTarget(c260013008.damtg)
    e3:SetOperation(c260013008.damop)
    c:RegisterEffect(e3)
end


--【特殊召喚】
function c260013008.spcfilter(c,tp)
    return c:GetSummonLocation()==LOCATION_EXTRA
end
function c260013008.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c260013008.spcfilter,1,nil,tp)
end
function c260013008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c260013008.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end


--【破壊】
function c260013008.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) 
        and c:IsAbleToGrave()
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c260013008.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end


--【X素材】
function c260013008.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER) and c:IsSetCard(0x943)
end
function c260013008.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local dam=math.ceil(e:GetHandler():GetBattleTarget():GetAttack()/2)
    if dam<0 then dam=0 end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c260013008.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end