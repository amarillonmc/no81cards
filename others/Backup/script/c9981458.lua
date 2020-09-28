--导弹齐射
function c9981458.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c9981458.target)
	e1:SetOperation(c9981458.activate)
	c:RegisterEffect(e1)
 --draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981458,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9981458)
	e2:SetCost(c9981458.drcost)
	e2:SetTarget(c9981458.drtg)
	e2:SetOperation(c9981458.drop)
	c:RegisterEffect(e2)
end
function c9981458.filter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup())  and c:IsSetCard(0x9bd1)
end
function c9981458.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9981458.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c) end
	local sg=Duel.GetMatchingGroup(c9981458.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,sg:GetCount()*500)
end
function c9981458.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c9981458.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,e:GetHandler())
	local ct=Duel.Destroy(sg,REASON_EFFECT)  
	Duel.BreakEffect()
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end
function c9981458.drfilter(c)
	return  c:IsSetCard(0x9bd1) and c:IsType(TYPE_FUSION) and c:IsAbleToRemoveAsCost()
end
function c9981458.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c9981458.drfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9981458.drfilter,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9981458.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9981458.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
