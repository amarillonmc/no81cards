--黑化之炼金术
function c51926017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c51926017.condition)
	e1:SetTarget(c51926017.target)
	e1:SetOperation(c51926017.activate)
	c:RegisterEffect(e1)
end
function c51926017.cfilter(c)
	return c:IsCode(51926001) and c:IsFaceup()
end
function c51926017.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c51926017.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c51926017.rfilter(c,e,tp)
	return c:IsSetCard(0x3257) and c:IsFaceup() and c:IsAbleToRemove()
end
function c51926017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51926017.rfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
end
function c51926017.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c51926017.rfilter,tp,LOCATION_MZONE,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local rg=g:Select(tp,1,#g,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
