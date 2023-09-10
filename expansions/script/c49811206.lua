--サ・バイバル
function c49811206.initial_effect(c)
	--spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811206,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_REMOVE)
    e1:SetCountLimit(1,49811206)
    e1:SetTarget(c49811206.sptg)
    e1:SetOperation(c49811206.spop)
    c:RegisterEffect(e1)
    --synchro summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c49811206.sctg)
    e2:SetOperation(c49811206.scop)
    c:RegisterEffect(e2)
end
function c49811206.filter(c,e,tp)
    return c:IsLevelBelow(3) and c:IsType(TYPE_TUNER) and c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811206.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c49811206.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c49811206.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c49811206.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2,true)
    end
    Duel.SpecialSummonComplete()
end
function c49811206.mfilter(c)
    return c:IsRace(RACE_PSYCHO)
end
function c49811206.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetMatchingGroup(c49811206.mfilter,tp,LOCATION_MZONE,0,nil)
        return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c49811206.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local mg=Duel.GetMatchingGroup(c49811206.mfilter,tp,LOCATION_MZONE,0,nil)
    local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        local sc=sg:GetFirst()
        Duel.SynchroSummon(tp,sc,nil,mg)
	    --draw
	    local e1=Effect.CreateEffect(c)
	    e1:SetDescription(aux.Stringid(49811206,2))
	    e1:SetCategory(CATEGORY_DRAW)
	    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	    e1:SetProperty(EFFECT_FLAG_DELAY)
	    e1:SetCondition(c49811206.drcon)
	    e1:SetTarget(c49811206.drtg)
	    e1:SetOperation(c49811206.drop)
	    sc:RegisterEffect(e1)
	    local e0=Effect.CreateEffect(c)
	    e0:SetType(EFFECT_TYPE_SINGLE)
	    e0:SetCode(EFFECT_MATERIAL_CHECK)
	    e0:SetValue(c49811206.valcheck)
	    e0:SetLabelObject(e1)
	    sc:RegisterEffect(e0)		    
    end
end
function c49811206.valcheck(e,c)
    e:GetLabelObject():SetLabel(c:GetMaterialCount()-1)
end
function c49811206.drcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c49811206.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=e:GetLabel()
    if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ct)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c49811206.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end