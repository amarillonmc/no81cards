--轮回六道 三途返
function c79011447.initial_effect(c)
	aux.AddCodeList(c,79011440)
	--Activate 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79011447,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c79011447.accon)
	e1:SetTarget(c79011447.actg)
	e1:SetOperation(c79011447.acop)
	c:RegisterEffect(e1) 
end
c79011447.SetCard_Pain_PBLK_Skill=true 
function c79011447.accon(e,tp,eg,ep,ev,re,r,rp)   
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(79011440) end,tp,LOCATION_MZONE,0,1,nil) 
end 
function c79011447.eqfilter(c)
	return c:IsFaceup() and c:IsCode(79011440) 
end
function c79011447.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c79011447.eqfilter,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.SelectTarget(tp,c79011447.eqfilter,tp,LOCATION_MZONE,0,1,1,nil) 
end
function c79011447.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		--immuse
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_EXTRA_ATTACK) 
		e1:SetRange(LOCATION_MZONE)  
		e1:SetValue(2) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
		--actlimit
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,1)
		e2:SetValue(1)
		e2:SetCondition(function(e)
		return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() end)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e2)
		Duel.CreateToken(tp,79011441) 
		if c79011441.excon(e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(79011441,1)) then 
			c79011441.exop(e,tp,eg,ep,ev,re,r,rp)
		end 
		Duel.CreateToken(tp,79011442) 
		if c79011442.excon(e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(79011442,1)) then 
			c79011442.exop(e,tp,eg,ep,ev,re,r,rp)
		end 
	end 
end

