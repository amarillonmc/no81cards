--Nowhere 鹿乃
function c75646401.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646401,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(0x100)
	e1:SetCode(1002)
	e1:SetRange(0x2)
	e1:SetCountLimit(1,75646401)
	e1:SetCost(c75646401.cost)
	e1:SetOperation(c75646401.operation)
	c:RegisterEffect(e1)
	--up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c75646401.costs)
	e4:SetTarget(c75646401.tg)
	e4:SetOperation(c75646401.op)
	c:RegisterEffect(e4)
end
function c75646401.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),0x80)
end
function c75646401.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(0x802)
	e1:SetProperty(0x10000)
	e1:SetCode(1012)
	e1:SetCondition(c75646401.drcon1)
	e1:SetOperation(c75646401.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(0x802)
	e2:SetCode(1012)
	e2:SetCondition(c75646401.regcon)
	e2:SetOperation(c75646401.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(0x802)
	e3:SetCode(1022)
	e3:SetCondition(c75646401.drcon2)
	e3:SetOperation(c75646401.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c75646401.cfilter(c,tp)
	return c:IsControler(1-tp)
end
function c75646401.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=0x1 and eg:IsExists(c75646401.cfilter,1,nil,tp) 
		and (not re:IsHasType(0x8) or re:IsHasType(0x800))
end
function c75646401.drop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,2) then
		Duel.DiscardDeck(tp,2,0x40)
	end
end
function c75646401.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c75646401.cfilter,1,nil,tp) and Duel.GetFlagEffect(tp,75646401)==0 
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c75646401.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,75646401,RESET_CHAIN,0,1)
end
function c75646401.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,75646401)>0
end
function c75646401.drop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,75646401)   
	if Duel.IsPlayerCanDiscardDeck(tp,2) then
		Duel.DiscardDeck(tp,2,0x40)
	end
end
function c75646401.costs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c75646401.filter(c)
	return c:IsSetCard(0x32c4) and not c:IsCode(75646401)
end
function c75646401.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646401.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c75646401.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75646402,0))
	local g=Duel.SelectMatchingCard(tp,c75646401.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end