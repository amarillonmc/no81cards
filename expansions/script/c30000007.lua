--终焉邪魂 废墟虚无之魔殿
function c30000007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c30000007.tg)
	e1:SetOperation(c30000007.op)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,30000007)
	e2:SetOperation(c30000007.ctop)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,30000008)
	e3:SetTarget(c30000007.thtg)
	e3:SetOperation(c30000007.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DESTROYED)
	c:RegisterEffect(e4)
end
function c30000007.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) end
	local num=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,num,tp,LOCATION_GRAVE)
end
function c30000007.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local sg=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		local gc=sg:GetFirst()
		while gc do
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_TRIGGER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			gc:RegisterEffect(e3)
			gc=sg:GetNext()
		end
	end
end

function c30000007.ctfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end

function c30000007.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c30000007.ctfilter,nil)
	if ct>0 then
	Duel.IsPlayerCanDraw(tp,1)
	 Duel.Draw(tp,1,REASON_EFFECT) end
end
	
function c30000007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end

function c30000007.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
	if g1:GetCount()>0 and Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) then
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
		Duel.HintSelection(g2)
		Duel.SendtoHand(g2,tp,REASON_EFFECT) 
end

end