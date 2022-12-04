function c4877066.initial_effect(c)
        c:EnableReviveLimit()
        aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c4877066.lcheck)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(4877066,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,4877066)
    e1:SetCondition(c4877066.hspcon)
    e1:SetTarget(c4877066.gytg)
    e1:SetOperation(c4877066.rmop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4877066,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,4877067)
	e2:SetCondition(c4877066.seqcon)
	e2:SetTarget(c4877066.thtg)
	e2:SetOperation(c4877066.thop)
	c:RegisterEffect(e2)
end
function c4877066.thcfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return ec:GetLinkedGroup():IsContains(c)
	else
		return bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
	end
end
function c4877066.cfilter(c,lg)
	return c:IsType(TYPE_EFFECT) and lg:IsContains(c)
end
function c4877066.seqcon(e,tp,eg,ep,ev,re,r,rp)
    local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c4877066.cfilter,1,nil,lg)
end
function c4877066.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c4877066.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4877066.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c4877066.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c4877066.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		 Duel.Draw(tp,1,REASON_EFFECT)
	end
	     local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c4877066.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c4877066.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsSummonableCard()
end
function c4877066.hspcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c4877066.lcheck(g,lc)
    return g:IsExists(c4877066.filter1,1,nil,nil)
end
function c4877066.ovfilter(c)
    return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)
end
function c4877066.gyfilter(c,g)
	return g:IsContains(c)
end
function c4877066.filter1(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL)
end
function c4877066.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4877066.tgfilter,tp,LOCATION_PZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,1-tp,LOCATION_PZONE)
end
function c4877066.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c4877066.tgfilter,tp,LOCATION_PZONE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
		tc=g:GetFirst()
       if Duel.SendtoHand(g,tp,REASON_EFFECT)>0 and tc:IsType(TYPE_RITUAL) then
	    Duel.BreakEffect()
		 local g1=Duel.SelectMatchingCard(tp,c4877066.filter1,tp,LOCATION_DECK,0,1,1,nil)
		  local tc1=g1:GetFirst()
		  Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	   end
    end
end