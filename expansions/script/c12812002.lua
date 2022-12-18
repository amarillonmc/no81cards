--恋爱头脑战-白银御行
local m=12812002
local cm=_G["c"..m]
function c12812002.initial_effect(c)
	aux.EnablePendulumAttribute(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.psplimit)
	c:RegisterEffect(e1)
	--special summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,m)
    e2:SetCondition(cm.spcon)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
end
function cm.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa73) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
--效果1
function cm.cfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xa73)  and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
--效果2