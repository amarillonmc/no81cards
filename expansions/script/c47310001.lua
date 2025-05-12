-- 面灵气 秦心
Duel.LoadScript('c47310000.lua')
local s,id=GetID()
function s.equip(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
    e1:SetCondition(s.eqcon)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipCount()>0
end
function s.defilter(c,tc)
    return c:IsLocation(LOCATION_SZONE) and c:IsType(TYPE_EQUIP)
end
function s.eqfilter(c,tc,code,tp)
    return Hnk.eqfilter(c,tc,tp) and not c:IsCode(code)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    local c=e:GetHandler()
    local eqg=c:GetEquipGroup()
    if chk==0 then return eqg:FilterCount(s.defilter,nil)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,s.defilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,LOCATION_SZONE)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
    local tc =Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        local code=tc:GetCode()
        local c=e:GetHandler()
        if Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c,code,tp) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
            local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,c,code,tp)
            local tc2=g:GetFirst()
            Duel.Equip(tp,tc2,c)
        end
    end
end
function s.initial_effect(c)
    s.equip(c)
    Hnk.eff2(c)
    Hnk.eff3(c,id,LOCATION_GRAVE)
end