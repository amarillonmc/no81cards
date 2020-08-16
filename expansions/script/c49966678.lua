--薛定谔的恶作剧猫
function c49966678.initial_effect(c)
	  --destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49966678,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,49966678)
	e4:SetCost(c49966678.cost)
	e4:SetTarget(c49966678.thtg)
	e4:SetOperation(c49966678.thop)
	c:RegisterEffect(e4)
end
function c49966678.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
		 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c49966678.thfilter(c,tp)
	return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS  and c:IsType(TYPE_SPELL)
		and c:GetActivateEffect():IsActivatable(tp)
end
function c49966678.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49966678.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c49966678.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c49966678.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b2=tc:GetActivateEffect():IsActivatable(tp)
		if b2 then
			Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end
