-- 面灵气 秦心·深秘
Duel.LoadScript('c47310000.lua')
local s,id=GetID()
function s.equip(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.eqcon)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and (re:IsActiveType(TYPE_MONSTER) or  re:GetHandler():IsType(TYPE_SPELL))
end
function s.defilter(c)
    return c:IsSetCard(0x3c10)
end
function s.eqfilter(c,tc,code,tp)
    return Hnk.eqfilter(c,tc,tp) and not c:IsCode(code)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsSetCard(0x3c10) end
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(s.defilter,tp,LOCATION_ONFIELD,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,s.defilter,tp,LOCATION_ONFIELD,0,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,LOCATION_ONFIELD)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
    local tc =Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        local code=tc:GetCode()
        if Duel.Destroy(tc,REASON_EFFECT)~=0 then
            local c=e:GetHandler()
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
    Hnk.eff3(c,id,LOCATION_DECK)
end
