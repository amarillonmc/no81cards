--逆元构造 邦比娜塔
function c79029837.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c79029837.mfilter,1,99,c79029837.lcheck)
	c:EnableReviveLimit() 
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c79029837.lmlimit)
	c:RegisterEffect(e1) 
	--forget 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c79029837.fgcon1) 
	e2:SetOperation(c79029837.fgop1)	
	c:RegisterEffect(e2) 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c79029837.fgcon2) 
	e2:SetOperation(c79029837.fgop2)	
	c:RegisterEffect(e2) 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c79029837.fgcon3) 
	e2:SetOperation(c79029837.fgop3)	
	c:RegisterEffect(e2)  
	--neg 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e3:SetCode(EVENT_CHAINING) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCondition(c79029837.ngcon) 
	e3:SetOperation(c79029837.ngop) 
	c:RegisterEffect(e3)  
end
function c79029837.mfilter(c)
	return c:IsLevel(3) or c:IsRank(3) or c:IsLink(3) 
end
function c79029837.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xa991)
end
function c79029837.lmlimit(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c79029837.fgcon1(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetFlagEffect(tp,71029837)==0 and rp==tp and re:IsActiveType(TYPE_MONSTER)	
end 
function c79029837.fgop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetFlagEffect(tp,71029837)==0 and c:IsFaceup() and c:IsOnField() and Duel.SelectYesNo(tp,aux.Stringid(79029837,1)) then 
	Duel.RegisterFlagEffect(tp,71029837,RESET_PHASE+PHASE_END,0,1) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(c:GetAttack()*2)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e1:SetTargetRange(1,0) 
	e1:SetValue(c79029837.actlimit1) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	end 
end 
function c79029837.actlimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c79029837.fgcon2(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetFlagEffect(tp,72029837)==0 and rp==tp and re:IsActiveType(TYPE_SPELL) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)	 
end 
function c79029837.fgop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetFlagEffect(tp,72029837)==0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79029837,2)) then 
	Duel.RegisterFlagEffect(tp,72029837,RESET_PHASE+PHASE_END,0,1)  
	local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil) 
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) 
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e1:SetTargetRange(1,0) 
	e1:SetValue(c79029837.actlimit2) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	end 
end 
function c79029837.actlimit2(e,re,tp)
	return re:IsActiveType(TYPE_SPELL)
end
function c79029837.fgcon3(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetFlagEffect(tp,73029837)==0 and rp==tp and re:IsActiveType(TYPE_TRAP) and Duel.IsPlayerCanDraw(tp,1)	
end 
function c79029837.fgop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetFlagEffect(tp,73029837)==0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(79029837,3)) then 
	Duel.RegisterFlagEffect(tp,73029837,RESET_PHASE+PHASE_END,0,1) 
	Duel.Draw(tp,1,REASON_EFFECT)  
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e1:SetTargetRange(1,0) 
	e1:SetValue(c79029837.actlimit3) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	end 
end 
function c79029837.actlimit3(e,re,tp)
	return re:IsActiveType(TYPE_TRAP)
end
function c79029837.ngcon(e,tp,eg,ep,ev,re,r,rp) 
	local flag=0 
	if Duel.GetFlagEffect(tp,71029837)~=0 then flag=bit.bor(flag,TYPE_MONSTER) end 
	if Duel.GetFlagEffect(tp,72029837)~=0 then flag=bit.bor(flag,TYPE_SPELL) end 
	if Duel.GetFlagEffect(tp,73029837)~=0 then flag=bit.bor(flag,TYPE_TRAP) end 
	if flag==0 then return false end 
	return Duel.GetFlagEffect(tp,79029837)==0 and rp==1-tp and re:IsActiveType(flag) and Duel.IsChainDisablable(ev) 
end 
function c79029837.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetFlagEffect(tp,79029837)==0 and Duel.SelectYesNo(tp,aux.Stringid(79029837,4)) then 
	Duel.RegisterFlagEffect(tp,79029837,RESET_PHASE+PHASE_END,0,1) 
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT) 
	end   
	end 
end 






