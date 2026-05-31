--轮回六道 封术吸印
function c79011450.initial_effect(c)
	aux.AddCodeList(c,79011443)
	--Activate 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79011450,1)) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)   
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(79011443) end,tp,LOCATION_MZONE,0,1,nil) end)
	e1:SetTarget(c79011450.actg)
	e1:SetOperation(c79011450.acop)
	c:RegisterEffect(e1) 
end
c79011450.SetCard_Pain_PBLK_Skill=true 
function c79011450.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end  
	e:SetCategory(0)
	local ch=Duel.GetCurrentChain()
	if ch>1 and Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER)==1-tp then
		e:SetCategory(CATEGORY_DRAW) 
	end  
end
function c79011450.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)  
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do  
		--immuse
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_IMMUNE_EFFECT) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetOwnerPlayer(tp)  
		e1:SetValue(function(e,te) 
		return te:IsActivated() and te:GetOwnerPlayer()~=e:GetOwnerPlayer() end) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN) 
		tc:RegisterEffect(e1)   
		tc=g:GetNext() 
		end 
		local ch=Duel.GetCurrentChain()
		if ch>1 then
			local p=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER)  
			if p==1-tp then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end 
	end 
end 










