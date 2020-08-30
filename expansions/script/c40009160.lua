--狂风标枪
function c40009160.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009160,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,40009160)
	e1:SetTarget(c40009160.target)
	e1:SetOperation(c40009160.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009160,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,40009161)
	e3:SetCost(c40009160.spcost)
	e3:SetTarget(c40009160.settg)
	e3:SetOperation(c40009160.setop)
	c:RegisterEffect(e3)	  
end
function c40009160.filter(c)
	return c:IsSetCard(0xbf1d) and c:IsDiscardable(REASON_EFFECT)
end
function c40009160.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(c40009160.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c40009160.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c40009160.filter,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function c40009160.cfilter(c)
	return c:IsCode(40009154) and c:IsAbleToDeckAsCost()
end
function c40009160.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(c40009160.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c40009160.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Release(e:GetHandler(),REASON_COST)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c40009160.setfilter(c)
	return c:IsCode(40009166) and c:IsSSetable()
end
function c40009160.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009160.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c40009160.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c40009160.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
