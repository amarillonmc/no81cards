--仗剑走天涯 达达
function c50099151.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,50099151) 
	e1:SetCondition(c50099151.spcon)
	e1:SetTarget(c50099151.sptg)
	e1:SetOperation(c50099151.spop)
	c:RegisterEffect(e1)	  
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,10099151)
	e2:SetCondition(c50099151.discon)
	e2:SetCost(c50099151.discost)
	e2:SetTarget(c50099151.distg)
	e2:SetOperation(c50099151.disop)
	c:RegisterEffect(e2)
end
function c50099151.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return ((c:IsReason(REASON_COST) and re:IsActivated()) or c:IsReason(REASON_EFFECT)) and rc:IsSetCard(0x998)  
end 
function c50099151.spfil(c,e,sp)
	return c:IsSetCard(0x998) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c50099151.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c50099151.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND) 
end
function c50099151.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50099151.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c50099151.discon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_SYNCHRO+TYPE_LINK) end,tp,LOCATION_MZONE,0,1,nil) then return false end 
	return rp==1-tp and re:IsActiveType(TYPE_TRAP)  
end
function c50099151.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end 
end
function c50099151.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0) 
end
function c50099151.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then 
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)  
		if g:GetCount()>0 then 
			local tc=g:GetFirst() 
			while tc do 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_SET_ATTACK) 
			e1:SetValue(tc:GetAttack()*2) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_SET_DEFENSE) 
			e1:SetValue(tc:GetDefense()*2) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1)
			tc=g:GetNext() 
			end 
		end   
	end 
end








