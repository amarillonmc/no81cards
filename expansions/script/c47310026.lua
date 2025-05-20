--面灵气 秦心※祝舞
Duel.LoadScript('c47310000.lua')
local s,id=GetID()
function s.sprule(c)
    c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.mfilter,1)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function s.mfilter(c)
	return c:IsLinkSetCard(0x3c10)
end
function s.spsummon(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local eqg=c:GetEquipGroup()
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and (#eqg==0 or eqg:FilterCount(Card.IsAbleToRemoveAsCost,nil)==#eqg) end
	if #eqg>0 then
        Duel.Remove(eqg,POS_FACEUP,REASON_COST)
    end
    Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x3c10) and not c:IsCode(47310026) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and s.spfilter(chkc,e,tp) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,#tg,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetMZoneCount(tp)<=0 then return end
	local tc=Duel.GetFirstTarget()
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and ft>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        Duel.BreakEffect()
        local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Hnk.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,tc,tp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,3))
        if not sg then return end
        local tc1=sg:GetFirst()
        while tc1 do
            Duel.Equip(tp,tc1,tc,true,true)
            tc1=sg:GetNext()
        end
        Duel.EquipComplete()
	end
end
function s.atk(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3c10))
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(600)
	c:RegisterEffect(e2)
end
function s.spsummonself(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_REMOVED)
    e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCountLimit(1,id-1000)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg2)
	e1:SetOperation(s.spop2)
	c:RegisterEffect(e1)
end
function s.lffilter(c,tp)
    return c:IsSetCard(0x3c10) and c:IsType(TYPE_MONSTER) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.lffilter,1,nil,tp) and rp==1-tp
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,TYPE_MONSTER)
     end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,1)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetMZoneCount(tp)>0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,TYPE_MONSTER)
        if #g>0 then
            local ec=g:GetFirst()
            if not ec:IsImmuneToEffect(e) then
                Duel.Equip(tp,ec,c)
            end
        end
    end
end
function s.initial_effect(c)
    s.sprule(c)
    s.spsummon(c)
    s.atk(c)
    s.spsummonself(c)
end
