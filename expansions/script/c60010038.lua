--绚烂的时刻
local cm,m,o=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.toss_dice=true
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_DECK,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local ts=0
	local tsnum=0
	local x1=0
	local x2=0
	while ts=0 do
		if tsnum<6 then
			x1=Duel.TossDice(tp,1)
			x2=Duel.TossDice(1-tp,1)
		else
			local a1,a2,a3,a4,a5,a6=Duel.TossDice(tp,6)
			x1=a1+a2+a3+a4+a5+a6
			local b1,b2,b3,b4,b5,b6=Duel.TossDice(1-tp,6)
			x2=b1+b2+b3+b4+b5+b6
		end
		if x1==x2 then
			ts=1
		elseif x1>x2 then
			Duel.PayLPCost(tp,x1*300)
			local adg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_TRAP)
			if #adg~=0 then
				Duel.SendtoHand(adg:Select(tp,1,1,nil),nil,REASON_EFFECT)
			else
				Duel.Draw(tp,1,REASON_EFFECT)
			end
			Duel.Recover(1-tp,x1*200,REASON_EFFECT)
		else
			Duel.PayLPCost(1-tp,x1*300)
			local adg=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_DECK,0,nil,TYPE_TRAP)
			if #adg~=0 then
				Duel.SendtoHand(adg:Select(1-tp,1,1,nil),nil,REASON_EFFECT)
			else
				Duel.Draw(1-tp,1,REASON_EFFECT)
			end
			Duel.Recover(tp,x1*200,REASON_EFFECT)
		end
		tsnum=tsnum+1
	end
end