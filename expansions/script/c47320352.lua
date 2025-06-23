-- 新昼地的灾虫
local s,id=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,47320301)
    c:EnableReviveLimit()
	s.sprule(c)
    s.tograve(c)
    s.spsummon(c)
end
function s.sprule(c)
    local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
end
function s.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc
end
function s.tograve(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(s.tgcon)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_MZONE) or c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsLocation(LOCATION_SZONE)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:RegisterFlagEffect(47320352,RESET_EVENT+RESETS_STANDARD,0,1)
    if c:GetFlagEffect(47320352)>=3 then
        local ct=Duel.SendtoGrave(c,REASON_EFFECT)
        if ct~=0 then
            Duel.RaiseEvent(c,EVENT_CUSTOM+47320352,e,REASON_EFFECT,tp,tp,0)
        end
    end
end
function s.spsummon(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetCondition(s.spcon)
    c:RegisterEffect(e2)
    
    Duel.AddCustomActivityCounter(47320352,ACTIVITY_SUMMON,s.counterfilter)
    Duel.AddCustomActivityCounter(47320352,ACTIVITY_SPSUMMON,s.counterfilter2)
end
function s.counterfilter(c)
	return c:IsSetCard(0x5c17) or aux.IsCodeListed(c,47320301)
end
function s.counterfilter2(c)
	return not c:IsSummonLocation(LOCATION_EXTRA)  or c:IsSetCard(0x5c17) or aux.IsCodeListed(c,47320301)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return re:GetActivateLocation()&LOCATION_ONFIELD~=0
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(47320352,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(47320352,tp,ACTIVITY_SPSUMMON)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetTarget(s.splimit3)
	Duel.RegisterEffect(e2,tp)
end
function s.splimit2(e,c)
	return not (c:IsSetCard(0x5c17) or aux.IsCodeListed(c,47320301))
end
function s.splimit3(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsSetCard(0x5c17) or aux.IsCodeListed(c,47320301))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
    local ck1=c:IsCanBeSpecialSummoned(e,0,tp,false,true,POS_FACEUP_DEFENSE,tp)
    local ck2=c:IsCanBeSpecialSummoned(e,0,tp,false,true,POS_FACEUP_DEFENSE,1-tp) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT)
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
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local zone=e:GetLabel()
    local p=tp
    if zone>=(1<<16) then
		p=1-tp
		zone=zone>>16
	end
	local seq=math.log(zone,2)
	local pc=Duel.GetFieldCard(p,LOCATION_MZONE,seq)
	if pc then
		Duel.Destroy(pc,REASON_RULE)
	end
	local ct=Duel.SpecialSummon(c,0,tp,p,false,true,POS_FACEUP_DEFENSE,zone)
    if ct~=0 and c:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp) then
        Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
    end
end