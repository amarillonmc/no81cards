function c10105691.initial_effect(c)
    	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105691,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCountLimit(1,10105691+EFFECT_COUNT_CODE_DUEL)
	e2:SetTarget(c10105691.sptg)
	e2:SetOperation(c10105691.spop)
	c:RegisterEffect(e2)
end
function c10105691.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=0
	for i,code in ipairs({10105691}) do
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_EXTRA,0,1,nil,code) then
			ct=ct+1
		end
	end
	if chk==0 then return ct==1 end
	Duel.SetChainLimit(aux.FALSE)
end
function c10105691.spop(e,tp,eg,ep,ev,re,r,rp)
	local token1=Duel.CreateToken(tp,50091196)
	Duel.SendtoDeck(token1,nil,2,REASON_RULE)
	local token2=Duel.CreateToken(tp,9024198)
	Duel.SendtoDeck(token2,nil,2,REASON_RULE)
	local token3=Duel.CreateToken(tp,79559912)
	Duel.SendtoDeck(token3,nil,2,REASON_RULE)
	local c=e:GetHandler()
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
end