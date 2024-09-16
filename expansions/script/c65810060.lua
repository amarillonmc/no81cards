--盛夏回忆·虫呼
function c65810060.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c65810060.cost)
	e1:SetTarget(c65810060.target)
	e1:SetOperation(c65810060.activate)
	c:RegisterEffect(e1)
end


function c65810060.cfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAbleToGraveAsCost()
end
function c65810060.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true 
	end
end
function c65810060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false 
		end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c65810060.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and dg:GetCount()>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c65810060.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,99,e:GetHandler())
	e:SetLabel(0,cg:GetCount())
	Duel.SendtoGrave(cg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,cg:GetCount(),0,0)
end
function c65810060.activate(e,tp,eg,ep,ev,re,r,rp)
	local label,count=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c65810060.filter,tp,0,LOCATION_ONFIELD,1,count,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
