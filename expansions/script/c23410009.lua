--觉醒·琅琊子
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,23410001)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	if Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_SZONE,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,0,LOCATION_SZONE,1,1,nil,tp)
		if g and #g>0 and Duel.SendtoGrave(g,REASON_COST)~=0 then 
			e:SetLabel(100)
		end
	end
end
function cm.filter(c,tp)
	return c:GetOwner()==tp and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabel()==100 then Duel.SetChainLimit(cm.chainlm) end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(23410001)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
end