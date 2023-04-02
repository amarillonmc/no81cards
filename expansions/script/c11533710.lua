--斩裂云梦之人
function c11533710.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11533710.matfilter,2)	
	--dis 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_CHAIN_SOLVING) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(c11533710.discon) 
	e1:SetOperation(c11533710.disop) 
	c:RegisterEffect(e1)  
end
function c11533710.matfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end 
function c11533710.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,11533710)~=0 or Duel.GetCurrentChain()>=4   
end 
function c11533710.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,11533710)
	local rc=re:GetHandler()
	if Duel.GetCurrentChain()>=4 then 
		Duel.RegisterFlagEffect(tp,11533710,RESET_CHAIN,0,1)  
	end 
	if Duel.NegateEffect(ev,true) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT) 
	end 
end 








