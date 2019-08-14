--超音速的老婆婆 圣白莲
function c60151305.initial_effect(c)
	--special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c60151305.spcon)
    e2:SetOperation(c60151305.spop2)
    c:RegisterEffect(e2)
	--special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151301,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,60151305)
    e1:SetTarget(c60151305.sptg)
    e1:SetOperation(c60151305.spop)
    c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Special Summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151301,1))
    e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
    e3:SetCategory(CATEGORY_EQUIP)
    e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,6011305)
    e3:SetCondition(c60151305.sumcon)
    e3:SetTarget(c60151305.sumtg)
    e3:SetOperation(c60151305.sumop)
    c:RegisterEffect(e3)
end
function c60151305.spfilter(c)
    return c:IsSetCard(0xcb23) and c:IsAbleToDeckOrExtraAsCost()
end
function c60151305.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60151305.spfilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
end
function c60151305.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c60151305.spfilter,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c60151305.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():GetLocation()~=LOCATION_DECK 
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and not e:GetHandler():IsReason(REASON_BATTLE)
end
function c60151305.filter2(c,e,tp)
    return c:GetCode()~=60151305 and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151305.filter3(c,e,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEUP) and c:GetControler()==tp
        and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151305.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151305.filter2,tp,LOCATION_DECK,0,1,nil,e,tp)
        and Duel.IsExistingMatchingCard(c60151305.filter3,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
    local g=Duel.GetMatchingGroup(c60151305.filter2,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c60151305.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,3))
    local g=Duel.SelectMatchingCard(tp,c60151305.filter3,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc:IsImmuneToEffect(e) then return end
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,2))
		local g1=Duel.SelectMatchingCard(tp,c60151305.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			local tc2=g1:GetFirst()
			Duel.Equip(tp,tc2,tc,true,true)
			Duel.EquipComplete()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c60151305.eqlimit)
			e1:SetLabelObject(tc)
			tc2:RegisterEffect(e1)
		end
    end
end
function c60151305.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151305.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.IsExistingMatchingCard(c60151305.filter3,tp,LOCATION_ONFIELD,0,1,nil,e,tp) 
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    local g=Duel.GetMatchingGroup(c60151305.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c60151305.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,3))
    local g=Duel.SelectMatchingCard(tp,c60151305.filter3,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc:IsImmuneToEffect(e) then return end
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,2))
		local g1=Duel.SelectMatchingCard(tp,c60151305.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			Duel.HintSelection(g1)
			local tc2=g1:GetFirst()
			Duel.Equip(tp,tc2,tc,true,true)
			Duel.EquipComplete()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c60151305.eqlimit)
			e1:SetLabelObject(tc)
			tc2:RegisterEffect(e1)
		end
    end
end
function c60151305.eqlimit(e,c)
    return c==e:GetLabelObject()
end