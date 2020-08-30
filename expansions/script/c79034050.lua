--ULTRAMAN 奈克斯特-幼年形态
function c79034050.initial_effect(c)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c79034050.mtop)
	c:RegisterEffect(e4) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,79034050)
	e1:SetCost(c79034050.thcost)
	e1:SetTarget(c79034050.thtg)
	e1:SetOperation(c79034050.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,7903405099999)
	e3:SetCost(c79034050.secost)
	e3:SetTarget(c79034050.setg)
	e3:SetOperation(c79034050.seop)
	c:RegisterEffect(e3)
end
function c79034050.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,500) then
		Duel.PayLPCost(tp,500)
	else
		Duel.SendtoHand(e:GetHandler(),tp,REASON_COST)
	end
end
function c79034050.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c79034050.thfilter(c)
	return c:IsCode(79034048) and c:GetActivateEffect():IsActivatable(tp)
end
function c79034050.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79034050.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c79034050.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c79034050.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end
function c79034050.cofil(c)
	return c:IsAbleToGraveAsCost()
end
function c79034050.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79034050.cofil,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79034050.cofil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79034050.thfilter2(c)
	return c:IsSetCard(0xa007) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c79034050.thfilter3(c)
	return c:IsSetCard(0xa007) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsType(TYPE_CONTINUOUS)
end
function c79034050.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b2=Duel.IsExistingMatchingCard(c79034050.thfilter2,tp,LOCATION_DECK,0,1,nil)
	local b1=Duel.IsExistingMatchingCard(c79034050.thfilter3,tp,LOCATION_DECK,0,1,nil)   
	if chk==0 then return (b1 or b2) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local op=0
	if b1 and b2 then
	op=Duel.SelectOption(tp,aux.Stringid(79034050,0),aux.Stringid(79034050,1))
	elseif b1 then
	op=Duel.SelectOption(tp,aux.Stringid(79034050,0))
	else
	op=Duel.SelectOption(tp,aux.Stringid(79034050,1))+1
	end
	e:SetLabel(op)
end
function c79034050.seop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local g2=Duel.GetMatchingGroup(c79034050.thfilter2,tp,LOCATION_DECK,0,nil)
	local tc=0
	if op==0 then
	tc=Duel.SelectMatchingCard(tp,c79034050.thfilter3,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	else
	tc=g2:Select(tp,1,1,nil):GetFirst()  
	end 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c79034050.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		if op==0 then
		local op1=0
		local op1=Duel.SelectOption(tp,aux.Stringid(79034050,2),aux.Stringid(79034050,3))
		if op1==0 then
		Duel.SSet(tp,tc,true)
		else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
		else
		Duel.SSet(tp,tc,true)
		end
end
function c79034050.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end






