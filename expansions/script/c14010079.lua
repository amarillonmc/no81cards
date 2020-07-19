--先人的召还
local m=14010079
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.disfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.disfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) or Duel.IsPlayerCanDraw(1-tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,0,3)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel=0
	local b1=Duel.IsPlayerCanDraw(tp,3)
	local b2=Duel.IsPlayerCanDraw(1-tp,3)
	if not b1 and not b2 then return end
	if b1 and not b2 then
		Duel.Draw(tp,3,REASON_EFFECT)
	elseif not b1 and b2 then
		Duel.Draw(1-tp,3,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
		sel=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))+1
		if sel==1 then
			p=tp
		elseif sel==2 then
			p=1-tp
		end
		Duel.Draw(p,3,REASON_EFFECT)
	end
end