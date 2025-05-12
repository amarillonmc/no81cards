--面灵气 秦心※心绮
Duel.LoadScript('c47310000.lua')
local s,id=GetID()
function s.tofield(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
    e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
	e1:SetCost(s.tfcost)
	e1:SetTarget(s.tftg)
	e1:SetOperation(s.tfop)
	c:RegisterEffect(e1)
end
function s.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function s.pfilter(c,tp)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x3ca0)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function s.eqfilter(c,tc)
    return tc:CheckEquipTarget(c) and c:IsSetCard(0x3ca0) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)~=0 then
        if Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_MZONE,0,1,nil,tc) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
            local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tc)
            if #g>0 then
                local ec=g:GetFirst()
                Duel.Equip(tp,tc,ec)
            else
                Duel.Destroy(tc,REASON_RULE)
            end
        else
            Duel.Destroy(tc,REASON_RULE)
        end
    end
end
function s.eff3(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_DESTROY)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id-1000)
    e1:SetCondition(Hnk.spcon)
	e1:SetTarget(Hnk.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.thfilter(c)
    return c:IsSetCard(0x3ca0) and c:IsAbleToHand()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
         and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
         and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,2)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
            local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
            Duel.SendtoHand(g,nil,REASON_EFFECT)
        end
    end
end
function s.initial_effect(c)
	s.tofield(c)
    Hnk.eff2(c)
    s.eff3(c)
end
