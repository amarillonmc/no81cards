--骗术意志
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.prop)
	c:RegisterEffect(e1)
end
s.psyz = 0

function s.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,50)
	Duel.SetChainLimit(s.chlimit)
end
function s.chlimit(e,ep,tp)
	return false
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,50,REASON_EFFECT)==50 and Duel.Recover(1-tp,50,REASON_EFFECT)==50 then
		s.psyz = s.psyz+1
		if s.psyz >= 3 and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsAbleToDeck() then
			Duel.BreakEffect()
			Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
		end
	end
	
	
end