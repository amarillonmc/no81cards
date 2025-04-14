--不知名的墨竹
function c29010828.initial_effect(c)
	--Inactivate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60000004,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c29010828.discon)
	e1:SetCost(c29010828.discost)
	e1:SetTarget(c29010828.distg)
	e1:SetOperation(c29010828.operation)
	c:RegisterEffect(e1)
end
function c29010828.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:GetActivateLocation()==LOCATION_GRAVE
end
function c29010828.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c29010828.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,60000004)==0 end
end
function c29010828.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c29010828.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,60000004,RESET_PHASE+PHASE_END,0,0)
end
function c29010828.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end