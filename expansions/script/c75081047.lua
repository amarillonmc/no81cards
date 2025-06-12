--流星的黑之牙 罗伊德
function c75081047.initial_effect(c)
	--summon with s/t
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetTarget(c75081047.sumtg)
	e0:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75081047,0))
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,75081047)
	e1:SetCondition(c75081047.thcon)
	e1:SetTarget(c75081047.sptg)
	e1:SetOperation(c75081047.spop)
	c:RegisterEffect(e1)  
	--send to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75081047,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c75081047.descon)
	e3:SetTarget(c75081047.target)
	e3:SetOperation(c75081047.operation)
	c:RegisterEffect(e3)  
end
function c75081047.sumtg(e,c)
	return c:IsType(TYPE_MONSTER) and c~=e:GetHandler() and c:IsSetCard(0xa754) and c:IsPreviousLocation(LOCATION_MZONE)
end
--
function c75081047.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75081047.cfilter1,1,nil,tp) 
end
function c75081047.cfilter1(c,tp)
	return c:IsSetCard(0xa754) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c75081047.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c75081047.sumtg(e,c)
	return c:IsType(TYPE_MONSTER) and c~=e:GetHandler() and c:IsSetCard(0xa754)
end
function c75081047.filter(c)
	return (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)) and c:IsSetCard(0xa754)
end
function c75081047.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c75081047.filter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75081047,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g1=Duel.SelectMatchingCard(tp,c75081047.filter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g1:GetFirst()
		if tc then
			local s1=tc:IsSummonable(true,nil,1)
			local s2=tc:IsMSetable(true,nil,1)
			if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
				Duel.Summon(tp,tc,true,nil,1)
			else
				Duel.MSet(tp,tc,true,nil,1)
			end
			local hg=Duel.GetMatchingGroup(Card.IsLevelAbove,tp,LOCATION_HAND,0,nil,1)
			local tc=hg:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetValue(-1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				tc=hg:GetNext()
			end
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_TO_HAND)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetOperation(c75081047.hlvop)
			Duel.RegisterEffect(e2,tp)
		end  
	end
end
function c75081047.hlvfilter(c,tp)
	return c:IsLevelAbove(1) and c:IsControler(tp)
end
function c75081047.hlvop(e,tp,eg,ep,ev,re,r,rp)
	local hg=eg:Filter(c75081047.hlvfilter,nil,tp)
	local tc=hg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=hg:GetNext()
	end
end
--
function c75081047.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c75081047.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa754) and c:IsAbleToHand()
end
function c75081047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75081047.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75081047.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75081047.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
