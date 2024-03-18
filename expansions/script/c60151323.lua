--法界的华莲 圣白莲
function c60151323.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),9,2,c60151323.ovfilter,aux.Stringid(60151323,0),3,c60151323.xyzop)
    c:EnableReviveLimit()
	--special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151301,1))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60151323.regcon)
    e1:SetTarget(c60151323.sptg)
    e1:SetOperation(c60151323.spop)
    c:RegisterEffect(e1)
	--destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151323,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e2:SetCondition(c60151323.setcon)
    e2:SetCost(c60151323.descost)
    e2:SetTarget(c60151323.destg)
    e2:SetOperation(c60151323.desop)
    c:RegisterEffect(e2)
    local e13=e2:Clone()
    e13:SetDescription(aux.Stringid(60151323,4))
    e13:SetType(EFFECT_TYPE_QUICK_O)
    e13:SetCode(EVENT_FREE_CHAIN)
    e13:SetHintTiming(0,0x1e0)
    e13:SetCondition(c60151323.setcon2)
    c:RegisterEffect(e13)
	--equip effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_LEVEL)
	e3:SetValue(3)
	e3:SetCondition(c60151323.con)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_RANK)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(c60151323.atkup)
	e5:SetCondition(c60151323.con)
	c:RegisterEffect(e5)
	--actlimit
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CANNOT_ACTIVATE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(1,1)
	e6:SetCondition(c60151323.con2)
    e6:SetValue(c60151323.actlimit)
    c:RegisterEffect(e6)
end
function c60151323.ovfilter(c)
    return c:IsFaceup() and c:GetCode()~=60151323 and (c:GetLevel()==9 or c:GetRank()==9) and c:IsSetCard(0xcb23)
end
function c60151323.xyzop(e,tp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60151323.regcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c60151323.filter2(c,e,tp)
    return not c:IsType(TYPE_XYZ) and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151323.filter3(c,e,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEUP) and c:GetControler()==tp
        and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151323.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151323.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.IsExistingMatchingCard(c60151323.filter3,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
    local g=Duel.GetMatchingGroup(c60151323.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c60151323.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,3))
    local g=Duel.SelectMatchingCard(tp,c60151323.filter3,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc:IsImmuneToEffect(e) then return end
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,2))
		local g1=Duel.SelectMatchingCard(tp,c60151323.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			local tc2=g1:GetFirst()
			if tc2:IsLocation(LOCATION_GRAVE) then Duel.HintSelection(g1) end
			Duel.Equip(tp,tc2,tc,true,true)
			Duel.EquipComplete()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c60151323.eqlimit)
			e1:SetLabelObject(tc)
			tc2:RegisterEffect(e1)
		end
    end
end
function c60151323.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c60151323.cfilter(c)
    return c:IsSetCard(0xcb23)
end
function c60151323.setcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(c60151323.cfilter,1,nil)
end
function c60151323.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60151323.dfilter(c)
    return c:IsType(TYPE_EQUIP) and c:IsAbleToGrave()
end
function c60151323.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151323.dfilter,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c60151323.filter(c)
    return true
end
function c60151323.desop(e,tp,eg,ep,ev,re,r,rp)
    local ct1=Duel.GetMatchingGroupCount(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local rg=Duel.SelectMatchingCard(tp,c60151323.dfilter,tp,LOCATION_ONFIELD,0,1,ct1,nil)
    local ct2=Duel.SendtoGrave(rg,REASON_EFFECT)
    if ct2==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct2,nil)
    Duel.HintSelection(dg)
    local g=Duel.Destroy(dg,REASON_EFFECT)
	if g>0 then 
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and Duel.SelectYesNo(tp,aux.Stringid(60151323,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151323,3))
			local sg=Duel.SelectMatchingCard(tp,c60151323.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,2,nil)
			local tc=sg:GetFirst()
			while tc do
				Duel.Equip(tp,tc,e:GetHandler(),false,true)
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_EQUIP_LIMIT)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				e3:SetLabelObject(tc)
				e3:SetValue(c60151323.eqlimit2)
				tc:RegisterEffect(e3)
				tc=sg:GetNext()
			end
			Duel.EquipComplete()
		end
	end
end
function c60151323.eqlimit2(e,c)
    return e:GetOwner()==c
end
function c60151323.cfilter2(c)
    return c:IsSetCard(0xcb23) and c:IsType(TYPE_XYZ)
end
function c60151323.setcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(c60151323.cfilter2,1,nil)
end
function c60151323.con(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetHandler():GetEquipTarget()
	return tg:IsSetCard(0xcb23) and tg:IsType(TYPE_MONSTER)
end
function c60151323.atkup(e,c)
    if e:GetHandler():GetEquipTarget():IsType(TYPE_XYZ) then
		return e:GetHandler():GetEquipTarget():GetRank()*100
	else
		return e:GetHandler():GetEquipTarget():GetLevel()*100
	end
end
function c60151323.con2(e)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c60151323.actlimit(e,te,tp)
    return te:IsActiveType(TYPE_TRAP)
end