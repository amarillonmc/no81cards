--幸运的女士
function c60151763.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151763,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60151763)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c60151763.condition)
	e1:SetTarget(c60151763.target)
	e1:SetOperation(c60151763.operation)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60151763,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60151763)
	e2:SetCost(c60151763.thcost)
	e2:SetTarget(c60151763.thtg)
	e2:SetOperation(c60151763.thop)
	c:RegisterEffect(e2)
	if not c60151763.global_check then
		c60151763.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c60151763.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c60151763.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsPreviousLocation(LOCATION_MZONE) and tc:IsSetCard(0x3b26) and rp==1-tp then
			if tc:GetPreviousControler()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,60151763,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,60151763,RESET_PHASE+PHASE_END,0,1) end
end
function c60151763.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,60151763)~=0
end
function c60151763.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c60151763.filter(c,e,tp)
	return c:IsSetCard(0x3b26) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151763.gfilter(c)
	return c:IsSetCard(0x3b26) and c:IsLocation(LOCATION_GRAVE)
end
function c60151763.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,5)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local a=Duel.GetDecktopGroup(tp,5)
	local g=a:Filter(c60151763.filter,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151763,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		a:Sub(sg)
		if Duel.SendtoGrave(a,REASON_EFFECT)~=0 then
			local ct=a:FilterCount(c60151763.gfilter,nil)
			if ct>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,ct,nil)
				if g:GetCount()>0 then
					Duel.HintSelection(g)
					Duel.Destroy(g,REASON_EFFECT)
				end
			end
		end
	end
end
function c60151763.cfilter(c)
	return c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c60151763.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c60151763.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60151763.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c60151763.thfilter(c)
	return c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60151763.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151763.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60151763.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60151763.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
