--幻想曲的纯洁之核
function c60150542.initial_effect(c)
	--link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xab20),2,2)
	--summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCondition(c60150542.descon)
    e2:SetTarget(c60150542.destg)
    e2:SetOperation(c60150542.desop)
    c:RegisterEffect(e2)
	--
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_XYZ_LEVEL)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c60150542.tgtg)
    e1:SetValue(c60150542.xyzlv)
    c:RegisterEffect(e1)
    local e3=e1:Clone()
    e3:SetCode(EFFECT_CHANGE_RACE)
    e3:SetValue(RACE_FIEND)
    c:RegisterEffect(e3)
    local e4=e1:Clone()
    e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e4:SetValue(ATTRIBUTE_LIGHT)
    c:RegisterEffect(e4)
end
function c60150542.matfilter(c)
    return c:IsType(TYPE_XYZ)
end
function c60150542.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetMaterial():Filter(c60150542.matfilter,nil)
    return c:IsSummonType(SUMMON_TYPE_LINK) and g:GetCount()>0
end
function c60150542.filter(c,e,tp)
    return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsType(TYPE_XYZ) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150542.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c60150542.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c60150542.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c60150542.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60150542.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c60150542.tgtg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c60150542.xyzlv(e,c,rc)
    return 0xa0000+e:GetHandler():GetLevel()
end
