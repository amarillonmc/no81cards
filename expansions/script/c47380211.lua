-- SymBIOSis实域突击
local s,id=GetID()
function s.initial_effect(c)
	s.negate(c)
    s.remove(c)
end
function s.negate(c)
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
    e1:SetCost(s.cost)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function s.tgfilter(c)
    return c:IsSetCard(0xcc16) and c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,aux.NULL)
    if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsLocation(LOCATION_ONFIELD) then
        Duel.SendtoGrave(re:GetHandler(),REASON_RULE)
    end
end
function s.remove(c)
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_TOGRAVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
function s.tdfilter(c)
    return c:IsSetCard(0xcc16) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
    local maxct=Duel.GetMatchingGroupCount(s.tdfilter,tp,LOCATION_GRAVE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local tg=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,maxct,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
end
function s.rmfilter(c)
    return c:IsFaceupEx() and c:IsAbleToRemove()
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if #tg>0 then
        local ct=Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        if ct>0 and Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_EXTRA,1,nil) then
            local max_ct=math.min(ct,Duel.GetMatchingGroupCount(s.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_EXTRA,nil))
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
            local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_EXTRA,1,max_ct,nil)
            Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        end
    end
end