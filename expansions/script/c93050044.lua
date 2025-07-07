--猫耳特工
local s,id,o=GetID()
function s.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.drcost)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.dract)
	c:RegisterEffect(e1)
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCurrentChain()
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,ct,tp,LOCATION_HAND)
end
function s.dract(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dc=Duel.Draw(p,ct,REASON_EFFECT)
	if dc>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local rg=Duel.GetFieldGroup(p,LOCATION_HAND,0):Select(p,dc,dc,nil)
		Duel.ShuffleHand(p)
		aux.PlaceCardsOnDeckBottom(p,rg)
	end
end
