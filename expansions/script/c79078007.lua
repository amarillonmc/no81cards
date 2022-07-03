--回归大群
function c79078007.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,79078007) 
	e1:SetCost(c79078007.accost)
	e1:SetTarget(c79078007.actg) 
	e1:SetOperation(c79078007.acop) 
	c:RegisterEffect(e1)
end
function c79078007.ctfil(c) 
	return c:IsFaceup() and c:IsRace(RACE_FISH) and c:IsAbleToRemove()  
end 
function c79078007.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79078007.ctfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c79078007.ctfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end  
function c79078007.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c79078007.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.RegisterFlagEffect(tp,79078007,RESET_PHASE+PHASE_END,0,1) 
	--
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_REMOVE) 
	e1:SetRange(LOCATION_GRAVE) 
	e1:SetCondition(c79078007.cpcon) 
	e1:SetOperation(c79078007.cpop) 
	c:RegisterEffect(e1)
end 
function c79078007.cpfil(c)
	local te=c.remove_effect 
	return c:IsReason(REASON_COST) and c.named_with_Massacre and te 
end  
function c79078007.cpcon(e,tp,eg,ep,ev,re,r,rp) 
	local g=Duel.GetMatchingGroup(c79078007.xcpfil,tp,0xff,0xff,nil,e,tp)
	return eg:IsExists(c79078007.cpfil,1,nil) and g:GetCount()>0
end 
function c79078007.xcpfil(c,e,tp) 
	return c:GetOwner()==tp and c:IsCode(79078000) 
end 
function c79078007.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,79078007) 
	local g=Duel.GetMatchingGroup(c79078007.xcpfil,tp,0xff,0xff,nil,e,tp)
	local sc=g:GetFirst() 
	while sc do 
	local cg=eg:Filter(c79078007.cpfil,nil) 
	local tc=cg:GetFirst() 
	while tc do
	local te=tc.remove_effect 
	if te and sc:GetFlagEffect(tc:GetCode())==0 then 
	local e1=te:Clone()   
	e1:SetDescription(aux.Stringid(tc:GetCode(),2))
	sc:RegisterEffect(e1)
	sc:RegisterFlagEffect(tc:GetCode(),0,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(tc:GetCode(),2))
	end 
	tc=cg:GetNext()
	end 
	sc=g:GetNext()
	end 
end 








