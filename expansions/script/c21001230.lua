--武装充能
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.prop)
	c:RegisterEffect(e1)
end

function s.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function s.filter2(c)
	return c:IsType(TYPE_EQUIP) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local num = Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	local num2 = Duel.GetMatchingGroupCount(s.filter2,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return num>0 and num2>0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,num,nil) and Duel.IsPlayerCanDraw(tp,num2) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,num,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,num2)
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	local num = Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	local num2 = Duel.GetMatchingGroupCount(s.filter2,tp,LOCATION_ONFIELD,0,nil)
	if num>0 and num2>0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,num,nil) and Duel.IsPlayerCanDraw(tp,num2) then
		local g = Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,num,num,nil)
		if Duel.SendtoDeck(g,nil,1,REASON_EFFECT)==num then
			Duel.Draw(tp,num2,REASON_EFFECT)
		end
	end
end