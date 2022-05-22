--方舟之骑士·幽灵鲨
c29010014.named_with_Arknight=1
function c29010014.initial_effect(c)
	--to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29010014,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29010014)   
	e1:SetTarget(c29010014.thtg)
	e1:SetOperation(c29010014.thop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c29010014.efilter)
	e2:SetTarget(c29010014.imtg)
	c:RegisterEffect(e2)
end
function c29010014.thfilter(c)
	return c:IsSetCard(0x77af) and c:IsAbleToHand() and c:IsType(TYPE_TRAP)
end
function c29010014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29010014.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29010014.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29010014.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c29010014.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
		and re:IsActiveType(TYPE_TRAP)
end
function c29010014.imtg(e,c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsRace(RACE_FISH) and c:IsType(TYPE_MONSTER)
end