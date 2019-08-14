--善意而恶意的行僧 圣白莲
function c60151329.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcb23),3,2)
    c:EnableReviveLimit()
	--special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151301,1))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60151329.regcon)
    e1:SetTarget(c60151329.sptg)
    e1:SetOperation(c60151329.spop)
    c:RegisterEffect(e1)
	--search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151329,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c60151329.cost)
    e2:SetTarget(c60151329.target)
    e2:SetOperation(c60151329.operation)
    c:RegisterEffect(e2)
	--Actlimit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetOperation(c60151329.lmop)
    c:RegisterEffect(e3)
end
function c60151329.regcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c60151329.filter2(c,e,tp)
    return not c:IsType(TYPE_XYZ) and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151329.filter3(c,e,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEUP) and c:GetControler()==tp
        and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151329.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151329.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.IsExistingMatchingCard(c60151329.filter3,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
    local g=Duel.GetMatchingGroup(c60151329.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c60151329.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,3))
    local g=Duel.SelectMatchingCard(tp,c60151329.filter3,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc:IsImmuneToEffect(e) then return end
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,2))
		local g1=Duel.SelectMatchingCard(tp,c60151329.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			local tc2=g1:GetFirst()
			if tc2:IsLocation(LOCATION_GRAVE) then Duel.HintSelection(g1) end
			Duel.Equip(tp,tc2,tc,true,true)
			Duel.EquipComplete()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c60151329.eqlimit)
			e1:SetLabelObject(tc)
			tc2:RegisterEffect(e1)
		end
    end
end
function c60151329.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c60151329.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60151329.filter(c)
    return (c:IsSetCard(0xcb23) or c:IsSetCard(0x3b24)) and c:IsAbleToHand()
end
function c60151329.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151329.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c60151329.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60151329.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
		local tc2=g:GetFirst()
		if tc2:IsLocation(LOCATION_GRAVE) then Duel.HintSelection(g) end
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c60151329.lmop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(0,1)
	e1:SetCondition(c60151329.actcon)
    e1:SetValue(c60151329.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
    Duel.RegisterEffect(e1,tp)
end
function c60151329.actcon(e)
    return Duel.GetAttacker()==e:GetHandler():GetEquipTarget() 
		or Duel.GetAttackTarget()==e:GetHandler():GetEquipTarget()
end
function c60151329.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end