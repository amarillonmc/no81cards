--困窘零落的死神
function c9980324.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9980324+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9980324.target)
	e1:SetOperation(c9980324.activate)
	c:RegisterEffect(e1)
end
function c9980324.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bcc) 
end
function c9980324.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9980324.filter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c9980324.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c9980324.filter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	Duel.Draw(p,ct,REASON_EFFECT)
end
