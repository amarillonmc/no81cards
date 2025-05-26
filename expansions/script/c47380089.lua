--黄金螺旋-质素“89”
local s,id=GetID()
function s.negate(c)
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function s.negfilter(c,code)
    return c:IsCode(code) and c:IsFaceupEx()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
        and not Duel.IsExistingMatchingCard(s.negfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,re:GetHandler():GetCode())
		and Duel.IsChainNegatable(ev) and rp~=tp
end
function s.tdfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcc13) and c:IsType(TYPE_LINK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re)
     and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_MZONE,0,1,nil) then
		rc:CancelToGrave()
		Duel.SendtoDeck(eg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
function s.remove(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,id-1000)
	e1:SetCondition(aux.exccon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
end
function s.rmfilter(c,tp)
    return c:IsFaceupEx() and c:IsAbleToRemove()
     and Duel.IsExistingMatchingCard(s.negfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,c,c:GetCode())
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,tp) end
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
    if #g>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end
function s.initial_effect(c)
    s.negate(c)
    s.remove(c)
end
