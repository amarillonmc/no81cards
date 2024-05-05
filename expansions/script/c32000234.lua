--红锈核心

local id=32000234
local zd=0xff6
function c32000234.initial_effect(c)
    c:SetUniqueOnField(1,0,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	-- DestAndRemove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c32000234.e2cost)
	e2:SetTarget(c32000234.e2tg)
	e2:SetOperation(c32000234.e2op)
	c:RegisterEffect(e2)
	
	--GraveRemoveToField
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_DESTROY)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e4:SetCost(c32000234.e4cost)
	e4:SetCondition(c32000234.e4con)
	e4:SetTarget(c32000234.e4tg)
	e4:SetOperation(c32000234.e4op)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e7)
end


--e2
function c32000234.e2costfilter(c)
    return c:IsDestructable() and c:IsSetCard(zd)
end
function c32000234.e2tgfilter(c)
    return c:IsAbleToRemove()
end

function c32000234.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAvleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
end

function c32000234.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c32000234.e2costfilter,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c32000234.e2costfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.Destroy(g,REASON_COST)
end

function c32000234.e2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

--e4
function c32000234.e4costfilter(c,e)
	return c:IsSetCard(zd) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end

function c32000234.e4confilter(c)
	return c:IsSetCard(zd)
end

function c32000234.e4cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c32000234.e4costfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c32000234.e4costfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c32000234.e4con(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c32000234.e4confilter,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
end

function c32000234.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) end
end

function c32000234.e4op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if not c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    
    if not (Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) and Duel.SelectYesNo(tp,HINTMSG_TODECK))
	then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	Duel.SendtoDeck(g2,tp,1,REASON_EFFECT)
	
end


