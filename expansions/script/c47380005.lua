--黄金螺旋-对补“5”
local s,id=GetID()
function s.sprule(c)
    aux.AddLinkProcedure(c,s.mfilter,2,2,s.lcheck)
	c:EnableReviveLimit()

    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.zonelimit)
	c:RegisterEffect(e1)
end
function s.mfilter(c)
    return c:IsLinkType(TYPE_LINK)
end
function s.lcheck(g)
	return g:IsExists(Card.IsRace,1,nil,RACE_PSYCHO)
end
function s.zonelimit(e)
	return 0x1f001f | (0x600060 & ~e:GetHandler():GetLinkedZone())
end
function s.linksummon(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.mgfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_LINK) and c:IsFaceupEx() and not c:IsImmuneToEffect(e)
	and ((c:IsAbleToGrave() and c:IsLocation(LOCATION_MZONE)) or (c:IsLocation(LOCATION_REMOVED) and c:IsAbleToExtra()))
end
function s.lfilter(c,e,tp)
	return c:IsCode(47380008) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function s.fselect(g,tp)
	return g:CheckWithSumEqual(Card.GetLinkMarker,0x1ef,2,2) and Duel.GetLocationCountFromEx(tp,tp,g)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(s.mgfilter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,nil,e)
	if chk==0 then return Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	and mg:CheckSubGroup(s.fselect,2,2,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(s.mgfilter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local g=mg:SelectSubGroup(tp,s.fselect,false,2,2,tp)
	if #g<=0 or not Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return end

	local mg3=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local rg=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	local count=0
	if #mg3>0 then count=count+Duel.SendtoGrave(mg3,REASON_EFFECT) end
	if #rg>0 then count=count+Duel.SendtoDeck(rg,nil,SEQ_DECKTOP,REASON_EFFECT) end
	if count>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,s.lfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #tg>0 then
			local tc=tg:GetFirst()
			if Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)>0 then
				tc:CompleteProcedure()
			end
		end
	end
end
function s.immune(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id-1000)
	e1:SetCondition(s.imcon)
    e1:SetCost(aux.bfgcost)
	e1:SetTarget(s.imtg)
	e1:SetOperation(s.imop)
	c:RegisterEffect(e1)
end
function s.imcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph~=PHASE_DAMAGE and ph~=PHASE_DAMAGE_CAL and e:GetHandler():IsReason(REASON_EFFECT)
end
function s.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_LINK) end
end
function s.imop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,nil,TYPE_LINK)
    if #g>0 then
        local tc=g:GetFirst()
        if tc:IsFaceup() and tc:IsControler(tp) then
			Duel.HintSelection(g)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_IMMUNE_EFFECT)
            e1:SetValue(s.efilter)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
            e1:SetOwnerPlayer(tp)
            tc:RegisterEffect(e1)
        end
    end
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function s.initial_effect(c)
	s.sprule(c)
    s.linksummon(c)
    s.immune(c)
end

