--单调原点·联动魔方
function c9310000.initial_effect(c)
	aux.AddCodeList(c,9310000,9310027,9310050)
	c:EnableReviveLimit()
	--ritual summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9310000)
	e1:SetCost(c9310000.rscost)
	e1:SetTarget(c9310000.thtg)
	e1:SetOperation(c9310000.thop)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(c9310000.tnval)
	c:RegisterEffect(e2)
	--field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CHANGE_ENVIRONMENT)
	e3:SetValue(9310027)
	c:RegisterEffect(e3)
	--predraw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9310000,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PREDRAW)
	e4:SetRange(LOCATION_GRAVE+LOCATION_ONFIELD)
	e4:SetCountLimit(1,9311000)
	e4:SetCondition(c9310000.condition)
	e4:SetTarget(c9310000.target)
	e4:SetOperation(c9310000.operation)
	c:RegisterEffect(e4)
end
function c9310000.thfilter(c)
	return c:IsSetCard(0x3f91) and not c:IsCode(9310000) and c:IsAbleToHand()
end
function c9310000.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() 
		or (Duel.IsPlayerAffectedByEffect(tp,9310027) and not c:IsPublic()) end
	if Duel.IsPlayerAffectedByEffect(tp,9310027) and not c:IsPublic() 
	   and (not c:IsDiscardable() or Duel.SelectOption(tp,aux.Stringid(9310027,0),aux.Stringid(9310027,1))==0) then
	   Duel.ConfirmCards(1-tp,c)
	else
	   Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	end
end
function c9310000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9310000.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9310000.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9310000.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c9310000.actlimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c9310000.cfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x3f91) and not c:IsCode(9310000)
end
function c9310000.actlimit(e,re,rp)
	return not re:GetHandler():IsSetCard(0x3f91) 
		   and not Duel.IsExistingMatchingCard(c9310000.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function c9310000.tnval(e,c)
	return e:GetHandler():IsDefensePos()
end
function c9310000.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function c9310000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		aux.DrawReplaceCount=0
		aux.DrawReplaceMax=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9310000.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	aux.DrawReplaceCount=aux.DrawReplaceCount+1
	if aux.DrawReplaceCount<=aux.DrawReplaceMax and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end