--幻想的乐章 斯雷姆
function c60150545.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60150545,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c60150545.e2tg)
	e2:SetOperation(c60150545.e2op)
	c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60150545,0))
    e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCondition(c60150545.e3con)
    e3:SetTarget(c60150545.e3tg)
    e3:SetOperation(c60150545.e3op)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(60150545,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCondition(c60150545.e4con)
    e4:SetTarget(c60150545.e4tg)
    e4:SetOperation(c60150545.e4op)
    c:RegisterEffect(e4)
end
function c60150545.e2tgfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c60150545.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60150545.e2tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60150545.e2tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c60150545.e2tgfilter,tp,LOCATION_MZONE,0,1,3,nil)
end
function c60150545.e2op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local tc=g:GetFirst()
	while tc do
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(60150545,1))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_XYZ_LEVEL)
			e1:SetValue(10)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
function c60150545.e3confilter(c,tp,sumt)
    return c:IsFaceup() and c:IsSetCard(0xcb20) and c:IsType(TYPE_XYZ) and c:IsSummonType(sumt) and c:GetSummonPlayer()==tp
end
function c60150545.e3con(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c60150545.e3confilter,1,nil,tp,SUMMON_TYPE_XYZ)
end
function c60150545.e3tgfilter(c)
    return ((c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)) or (c:IsSetCard(0xcb20) and c:IsType(TYPE_CONTINUOUS))) and c:IsAbleToHand()
end
function c60150545.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60150545.e3tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60150545.e3op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60150545.e3tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c60150545.e4confilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb20) and c:IsType(TYPE_CONTINUOUS)
end
function c60150545.e4con(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60150545.e4confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)==5
end
function c60150545.e4tgfilter(c,e,tp)
    return c:IsCode(60150546) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true)
end
function c60150545.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp)>-1
        and Duel.IsExistingMatchingCard(c60150545.e4tgfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60150545.e4opfilter(c,tc)
    return c:IsCanBeXyzMaterial(nil)
end
function c60150545.e4op(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCountFromEx(tp)<=-1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60150545.e4tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if not tc then return end
    local ga=Duel.GetMatchingGroup(c60150545.e4opfilter,tp,LOCATION_MZONE,0,nil,tc)
    local sc=ga:GetFirst()
	local sg=Group.CreateGroup()
	while sc do
		local sg1=sc:GetOverlayGroup()
		sg:Merge(sg1)
		sc=ga:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	local gb=Duel.GetMatchingGroup(nil,tp,LOCATION_SZONE+LOCATION_FZONE+LOCATION_HAND+LOCATION_GRAVE,0,nil)
	ga:Merge(gb)
	tc:SetMaterial(ga)
	Duel.Overlay(tc,ga)
    if Duel.SpecialSummonStep(tc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP) then
	    local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCode(EFFECT_IMMUNE_EFFECT)
        e2:SetValue(c60150545.efilter)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
	end
    Duel.SpecialSummonComplete()
    tc:CompleteProcedure()
end
function c60150545.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end