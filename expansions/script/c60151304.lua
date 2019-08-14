--超越灵长 圣白莲
function c60151304.initial_effect(c)
	--special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c60151304.spcon)
    e2:SetOperation(c60151304.spop2)
    c:RegisterEffect(e2)
	--special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151301,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,60151304)
    e1:SetTarget(c60151304.sptg)
    e1:SetOperation(c60151304.spop)
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
	e3:SetCountLimit(1,6011304)
    e3:SetCondition(c60151304.sumcon)
    e3:SetTarget(c60151304.sumtg)
    e3:SetOperation(c60151304.sumop)
    c:RegisterEffect(e3)
end
function c60151304.spfilter(c)
    return c:IsSetCard(0xcb23) and c:IsAbleToDeckOrExtraAsCost()
end
function c60151304.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60151304.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c60151304.spop2(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c60151304.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c60151304.tgfilter(c,e,tp)
    return c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151304.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60151304.tgfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c60151304.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60151304.tgfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		--xyz limit
            local e4=Effect.CreateEffect(e:GetHandler())
            e4:SetType(EFFECT_TYPE_SINGLE)
            e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
            e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
            e4:SetValue(c60151304.xyzlimit)
            e4:SetReset(RESET_EVENT+0xfe0000)
            tc:RegisterEffect(e4)
            Duel.SpecialSummonComplete()
    end
end
function c60151304.xyzlimit(e,c)
    if not c then return false end
    return not c:IsSetCard(0xcb23)
end
function c60151304.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():GetLocation()~=LOCATION_DECK 
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and not e:GetHandler():IsReason(REASON_BATTLE)
end
function c60151304.filter2(c,e,tp)
    return c:GetCode()~=60151304 and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151304.filter3(c,e,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEUP) and c:GetControler()==tp
        and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151304.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151304.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.IsExistingMatchingCard(c60151304.filter3,tp,LOCATION_ONFIELD,0,1,nil,e,tp) 
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    local g=Duel.GetMatchingGroup(c60151304.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c60151304.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,3))
    local g=Duel.SelectMatchingCard(tp,c60151304.filter3,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc:IsImmuneToEffect(e) then return end
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,2))
		local g1=Duel.SelectMatchingCard(tp,c60151304.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			Duel.HintSelection(g1)
			local tc2=g1:GetFirst()
			Duel.Equip(tp,tc2,tc,true,true)
			Duel.EquipComplete()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c60151304.eqlimit)
			e1:SetLabelObject(tc)
			tc2:RegisterEffect(e1)
		end
    end
end
function c60151304.eqlimit(e,c)
    return c==e:GetLabelObject()
end