--朔望皓明
local s,id=GetID()
function s.todeck(c)
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.tdfilter(c,e)
	return (c:IsRace(RACE_WYRM) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x5ca0))) and c:IsCanBeEffectTarget(e) and c:IsAbleToDeck()
end
function s.thfilter(c,g)
    return g:IsExists(Card.IsCode,1,nil,c:GetCode()) and c:IsAbleToHand()
end
function s.slcheck(sg,tp)
    return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,sg)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	if chk==0 then return #g>3 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,g) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local tg=g:SelectSubGroup(tp,s.slcheck,false,3,3,tp)
    Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if #tg>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tg)
        if #g>0 then
            Duel.SendtoHand(g,tp,REASON_EFFECT)
        end
        Duel.SendtoDeck(tg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
    end
end
function s.dualsummon(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id-1000)
	e1:SetCondition(s.spcon2)
	e1:SetTarget(s.sptg2)
	e1:SetOperation(s.spop2)
	c:RegisterEffect(e1)
end
function s.lffilter(c,tp)
	return c:IsRace(RACE_WYRM) and c:IsPreviousControler(tp)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.lffilter,1,nil,tp)
end
function s.dualfilter(c)
	return c:IsDualState() and c:IsFaceup()
end
function s.dfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsType(TYPE_DUAL) and not c:IsDualState() and c:IsFaceup()
end
function s.spfilter(c,e,tp)
    return c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local check=Duel.IsExistingMatchingCard(s.dualfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_MZONE,0,1,nil)
        or (check and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp))
     end
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
     and (not Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_MZONE,0,1,nil) or (Duel.IsExistingMatchingCard(s.dualfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,3)))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
        local g=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_MZONE,0,1,2,nil)
        for tc in aux.Next(g) do
            tc:EnableDualState()
        end
	end
end
function s.tofield(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id-2000)
	e1:SetCondition(s.setcon)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.setfilter(c,tp)
	return c:IsCode(47310208) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc,exc)
	if chk==0 then return e:GetHandler():IsAbleToGrave()
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,tp):GetFirst()
		if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
	end
end
s.has_text_type=TYPE_DUAL
function s.initial_effect(c)
    aux.AddCodeList(c,47310208)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

    s.todeck(c)
	s.dualsummon(c)
	s.tofield(c)
end
