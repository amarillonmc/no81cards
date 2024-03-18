--月光与幼枭
local cm,m=GetID()
function cm.initial_effect(c)
	--search limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.drcfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.drcfilter,1,nil,tp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_GRAVE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(cm.rmlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_DISCARD_DECK)
	e2:SetTargetRange(1,1)
	e2:SetTarget(cm.rmlimit)
	e2:SetValue(cm.rmlimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	--Duel.RegisterEffect(e2,tp)
	local ct=Duel.GetTurnCount()
	local fset={"IsAbleToGrave","IsPlayerCanDiscardDeck","SendtoGrave","DiscardDeck"}
	for i,fname in pairs(fset) do
		local tab=Duel
		if i==1 then tab=Card end
		local temp_f=tab[fname]
		tab[fname]=function(...)
						local params={...}
						if Duel.GetTurnCount()==ct then
							if i<=2 then return false else if params[i-1]&REASON_EFFECT>0 then return 0 end end
						end
						return temp_f(...)
					end
	end
end
function cm.rmlimit(e,c,tp,r)
	return r==REASON_EFFECT
end