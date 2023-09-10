--在某处邂逅的地雷
function c11579807.initial_effect(c)
	--sb 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,11579807) 
	e1:SetCost(c11579807.sbcost) 
	e1:SetTarget(c11579807.sbtg) 
	e1:SetOperation(c11579807.sbop) 
	c:RegisterEffect(e1) 
end
function c11579807.sbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end 
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT) 
end 
function c11579807.sbfil(c,e,tp) 
	return c:IsControler(1-tp) and c:IsCanBeEffectTarget(e) and c:GetSequence()<5
end 
function c11579807.sbtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=eg:Filter(c11579807.sbfil,nil,e,tp)
	if chk==0 then return g:GetCount()>0 end  
	local sg=g:Select(tp,1,1,nil) 
	Duel.SetTargetCard(sg) 
end 
function c11579807.sbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and tc:GetSequence()<5 then 
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil) 
		local sc=g:GetFirst() 
		while sc do 
		sc:RegisterFlagEffect(11579807,RESET_EVENT+RESETS_STANDARD,0,1) 
		sc=g:GetNext()
		end 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
		e1:SetCode(EVENT_ADJUST)  
		e1:SetLabel(tc:GetSequence()) 
		e1:SetCondition(c11579807.sdescon) 
		e1:SetOperation(c11579807.sdesop)  
		e1:SetReset(RESET_PHASE+PHASE_END) 
		Duel.RegisterEffect(e1,tp) 
	end 
end 
function c11579807.xsbckfil(c,seq) 
	if c:GetFlagEffect(11579807)~=0 then return false end 
	if c:IsLocation(LOCATION_MZONE) then 
		if c:GetSequence()<5 then 
			return math.abs(seq-c:GetSequence())<=1  
		elseif c:GetSequence()==5 then  
			return seq==1 
		elseif c:GetSequence()==6 then 
			return seq==3
		end 
	elseif c:IsLocation(LOCATION_SZONE) then 
		return c:GetSequence()==seq and c:GetSequence()<5 
	end 
end 
function c11579807.sdescon(e,tp,eg,ep,ev,re,r,rp) 
	local seq=e:GetLabel() 
	return Duel.IsExistingMatchingCard(c11579807.xsbckfil,tp,0,LOCATION_MZONE,1,nil,seq) 
end  
function c11579807.sdesop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset() 
	Duel.Hint(HINT_CARD,0,11579807) 
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD) 
	Duel.Destroy(g,REASON_EFFECT) 
end 



