--天使的交易
function c98920769.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98920769+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetOperation(c98920769.activate)
	c:RegisterEffect(e1)
	if c98920769.counter==nil then
		c98920769.counter=true
		c98920769[0]=0
		c98920769[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c98920769.resetcount)
		Duel.RegisterEffect(e2,0)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_DISCARD)
		e4:SetOperation(c98920769.addcount)
		Duel.RegisterEffect(e4,0)
	end	
end
function c98920769.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c98920769[0]=0
	c98920769[1]=0
end
function c98920769.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_MZONE) and tc:GetPreviousRaceOnField()==RACE_DRAGON
			or tc:IsPreviousLocation(LOCATION_HAND) and tc:IsType(TYPE_MONSTER) then
			local p=tc:GetPreviousControler()
			c98920769[p]=c98920769[p]+1
		end
		tc=eg:GetNext()
	end
end
function c98920769.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c98920769.droperation)
	Duel.RegisterEffect(e1,tp)
end
function c98920769.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,98920769)
	local ct=3
	if c98920769[tp]+1<3 then ct=c98920769[tp]+1 end
	Duel.Draw(tp,ct,REASON_EFFECT)
end