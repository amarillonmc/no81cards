-- SymBIOSis接应-探针回收
local s,id=GetID()
function s.initial_effect(c)
	s.sprule(c)
    s.eff1(c)
    s.eff2(c)
    s.eff3(c)
end
function s.sprule(c)
    c:SetSPSummonOnce(id)
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcc16),3,2,s.ovfilter,aux.Stringid(id,0),2,s.xyzop)
	c:EnableReviveLimit()
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcc16) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_XYZ)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
end
function s.eff1(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
    e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
end
function s.olfilter(c)
    return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay() and c:GetAttack()>0
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and s.olfilter(chkc) end
    if chk==0 then return e:GetHandler():GetFlagEffect(id)==0 and Duel.IsExistingMatchingCard(s.olfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local tg=Duel.SelectTarget(tp,s.olfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if tg:GetFirst():IsLocation(LOCATION_GRAVE) then
        Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
    end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
    local atk=tc:GetAttack()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsCanOverlay() then
		Duel.Overlay(c,Group.FromCards(tc))
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetTargetRange(0,LOCATION_MZONE)
        e1:SetValue(-atk)
        e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
        Duel.RegisterEffect(e1,tp)
	end
end
function s.eff2(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_SPSUMMON)
    e1:SetCountLimit(1)
	e1:SetCondition(s.ef2con)
    e1:SetCost(s.ef2cost)
	e1:SetTarget(s.ef2tg)
	e1:SetOperation(s.ef2op)
	c:RegisterEffect(e1)
end
function s.ef2con(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep
end
function s.ef2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.ef2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(id)==0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
end
function s.ef2op(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function s.eff3(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,3))
    e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(2,id)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.ogcon)
	e1:SetTarget(s.ogtg)
	e1:SetOperation(s.ogop)
	c:RegisterEffect(e1)
end
function s.ogcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.thfilter(c,code)
    return c:IsSetCard(0xcc16) and not c:IsCode(code) and c:IsAbleToHand()
end
function s.ogtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local code=e:GetHandler():GetCode()
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc,code) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil,code) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,code)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.ogop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
