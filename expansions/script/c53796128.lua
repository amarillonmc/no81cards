local m=53796128
local cm=_G["c"..m]
cm.name="理解偏差"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local rg1=Duel.GetDecktopGroup(tp,3)
		local rg2=Duel.GetDecktopGroup(1-tp,3)
		return rg1:FilterCount(Card.IsAbleToRemove,nil)==3 and rg2:FilterCount(Card.IsAbleToRemove,nil)==3
	end
	local rg=Group.__add(Duel.GetDecktopGroup(tp,3),Duel.GetDecktopGroup(1-tp,3))
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,0,PLAYER_ALL,3)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,3)
	local g2=Duel.GetDecktopGroup(1-tp,3)
	if #g1<=0 or #g2<=0 then return end
	Duel.DisableShuffleCheck()
	Duel.Remove(Group.__add(g1,g2),POS_FACEUP,REASON_EFFECT)
end
