-- 红英的灾虫 伊格纳维尔德
local s,id=GetID()
function s.initial_effect(c)
    c:SetUniqueOnField(1,0,47320365)
	c:EnableReviveLimit()
	aux.AddCodeList(c,47320352,47320364)
    aux.AddFusionProcCode2(c,47320352,47320364,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_ONFIELD,LOCATION_ONFIELD,Duel.SendtoGrave,REASON_COST)

	s.zone_lock(c)
	s.leave_effect(c)
end
function s.zone_lock(c)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CUSTOM+47320352)
    e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(s.zonop)
	c:RegisterEffect(e5)
end
function s.zonop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    if not tc then return end
    local ploc=tc:GetPreviousLocation()
    if ploc&LOCATION_ONFIELD==0 then return end
    local pc=tc:GetPreviousControler()
    if pc==tp then return end
    local seq=tc:GetPreviousSequence()
    local zone=1<<seq
    if tp==1 then
		zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
	end

    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DISABLE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(zone)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1)
end

function s.leave_effect(c)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,id)
	e6:SetCondition(s.spcon2)
	e6:SetTarget(s.sptg2)
	e6:SetOperation(s.spop2)
	c:RegisterEffect(e6)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function s.spfilter(c,e,tp,p)
    return c:IsCode(47320352) and c:IsCanBeSpecialSummoned(e,0,tp,false,true,POS_FACEUP_DEFENSE,p)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local ck1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,tp)
    local ck2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,1-tp)
    local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
    if chk==0 then return #g>0 and (ck1 or ck2) end
    local flag=0
    for tc in aux.Next(g) do
        local seq=tc:GetSequence()
        local lm=0
        if seq<5 then
            if tc:IsControler(1-tp) then
                lm=lm+16
            end
            flag=flag|(1<<(lm+seq))
        end
    end
    if not ck1 then
        flag=flag&0xffff0000
    end
    if not ck2 then
        flag=flag&0xffff
    end
    local zone=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0xffffffff-flag,47320352)
    e:SetLabel(zone)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local zone=e:GetLabel()
    local p=tp
    if zone>=(1<<16) then
		p=1-tp
		zone=zone>>16
	end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,p)
    if #g>0 then
        local seq=math.log(zone,2)
        local pc=Duel.GetFieldCard(p,LOCATION_MZONE,seq)
        if pc then
            Duel.Destroy(pc,REASON_RULE)
        end
        Duel.SpecialSummon(g,0,tp,p,false,true,POS_FACEUP_DEFENSE,zone)
    end
end
