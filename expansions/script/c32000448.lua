--武色最终兵器

local id=32000448
local zd=0x3c5
function c32000448.initial_effect(c)
			
    --activeToDeckAndNeg
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(c32000448.e1con)
	e1:SetTarget(c32000448.e1tg)
	e1:SetOperation(c32000448.e1op)
	c:RegisterEffect(e1)
	
	--SetSelfByRemove2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(c32000448.e2cost)
	e2:SetTarget(c32000448.e2tg)
	e2:SetOperation(c32000448.e2op)
	c:RegisterEffect(e2)
end



--e1

function c32000448.e1confilter(c)
    return c:IsSetCard(zd) and c:IsFaceup() and c:IsType(TYPE_FUSION)
end

function c32000448.e1con(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if ep==tp then return false end
	return Duel.IsExistingMatchingCard(c32000448.e1confilter,tp,LOCATION_MZONE,0,1,nil)
end

function c32000448.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=re:GetHandler()
    if chk==0 then return c:IsAbleToDeck() end 
   
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0)
end

function c32000448.e1op(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(eg,nil,3,REASON_EFFECT)
	end
end


--e2

function c32000448.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,2,c) end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,2,2,c)
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_COST)
end

function c32000448.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0.then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsLocation(LOCATION_GRAVE) or c:IsFaceup() end
end

function c32000448.e2op(e,tp,eg,ep,ev,re,r,rp)    
    local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then 
         Duel.SSet(tp,c,REASON_EFFECT)
    end
end







