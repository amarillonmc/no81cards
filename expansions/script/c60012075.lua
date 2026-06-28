local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2=e1:Clone()
	e2:SetCountLimit(1,id)
	e2:SetRange(LOCATION_DECK)
	e2:SetCost(s.deckcost)
	e2:SetTarget(s.decktarget)
	c:RegisterEffect(e2)

	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetOperation(s.checkop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAINING)
		ge3:SetOperation(s.checkop3)
		Duel.RegisterEffect(ge3,0)
	end
end
s.listed_series={0x5624}
function s.checkop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,id+1,RESET_PHASE+PHASE_END,0,1)
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,id+2,RESET_PHASE+PHASE_END,0,1)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_EXTRA) then
			Duel.RegisterFlagEffect(ep,id+3,RESET_PHASE+PHASE_END,0,1)
			break
		end
		tc=eg:GetNext()
	end
end
function s.checkop3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc and rc:IsType(TYPE_MONSTER) then
		Duel.RegisterFlagEffect(ep,id+4,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x5624) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.deckcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end

	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	e:GetHandler():CreateEffectRelation(e)
end
function s.decktarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local cond1=(Duel.GetFlagEffect(tp,id+1)==0) and (Duel.GetFlagEffect(tp,id+3)==0)
	local cond2=(Duel.GetFlagEffect(tp,id+2)==0)
	local cond3=(Duel.GetFlagEffect(tp,id+4)==0)
	if chk==0 then return (cond1 or cond2 or cond3) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetCurrentPhase()==PHASE_END and Duel.GetTurnPlayer()==tp end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end