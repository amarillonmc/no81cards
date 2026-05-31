--星啊，赴蹈辉途
function c71201930.initial_effect(c)
	aux.AddCodeList(c,71201916)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71201930,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c71201930.handcon)
	c:RegisterEffect(e1) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c71201930.target)
	e1:SetOperation(c71201930.activate)
	c:RegisterEffect(e1)
	if not c71201930.global_check then
		c71201930.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c71201930.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c71201930.thfil(c,e,tp) 
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL) and aux.IsCodeListed(c,71201916) and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end 
function c71201930.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	local b1=g:GetCount()>0 
	local b2=Duel.IsExistingMatchingCard(c71201930.thfil,tp,LOCATION_DECK,0,1,nil,e,tp) 
	local b3=b1 and b2 and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(71201910) end,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end   
end
function c71201930.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	local b1=g:GetCount()>0 
	local b2=Duel.IsExistingMatchingCard(c71201930.thfil,tp,LOCATION_DECK,0,1,nil,e,tp) 
	local b3=b1 and b2 and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(71201916) end,tp,LOCATION_MZONE,0,1,nil)
	if b1 or b2 or b3 then 
		local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(71201930,1)},{b2,aux.Stringid(71201930,2)},{b3,aux.Stringid(71201930,3)})
		if op==1 or op==3 then
			local tc=g:GetFirst() 
			while tc do 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_IMMUNE_EFFECT) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(function(e,te) 
			return te:GetOwner()~=e:GetHandler() end) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			tc:RegisterEffect(e1)
			tc=g:GetNext() 
			end 
		end
		if op==2 or op==3 then
			local sg=Duel.SelectMatchingCard(tp,c71201930.thfil,tp,LOCATION_DECK,0,1,1,nil,e,tp) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg) 
		end
	end 
end 
function c71201930.checkop(e,tp,eg,ep,ev,re,r,rp) 
	local rc=re:GetHandler()
	if rc and rc:GetType()==TYPE_SPELL then 
		Duel.RegisterFlagEffect(rp,71201930,RESET_PHASE+PHASE_END,0,1) 
	end 
end 
function c71201930.handcon(e) 
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,71201930)+Duel.GetFlagEffect(1-tp,71201930)~=0 
end


