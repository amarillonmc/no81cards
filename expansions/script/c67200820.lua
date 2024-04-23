--星渡之先导者
function c67200820.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c67200820.lcheck)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200820,0))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_EXTRA)
	--e1:SetCountLimit(1,67200820)
	e1:SetCondition(c67200820.discon)
	e1:SetOperation(c67200820.disop)
	c:RegisterEffect(e1)	
end
function c67200820.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x367b)
end
--
function c67200820.discon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200820.spcfilter,1,nil,tp) and eg:IsExists(c67200820.filter1,2,nil,tp)
end
function c67200820.filter1(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) 
end
function c67200820.spcfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0x367b)
end
function c67200820.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,67200820)==0 and Duel.SelectYesNo(tp,aux.Stringid(67200820,1)) then
		Duel.RegisterFlagEffect(tp,67200820,RESET_PHASE+PHASE_END,0,1)
		if Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,true)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(67200820,2))
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_TO_DECK)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_ONFIELD))
		e1:SetTargetRange(1,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		end
	end
end
