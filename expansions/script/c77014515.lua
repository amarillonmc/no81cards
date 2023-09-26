--反转体 梦魇-狂狂帝
function c77014515.initial_effect(c)  
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77014515.splimit)
	c:RegisterEffect(e1)	
	--confirm and SpecialSummon 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(77014515,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1) 
	e2:SetTarget(c77014515.castg) 
	e2:SetOperation(c77014515.casop) 
	c:RegisterEffect(e2) 
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c77014515.recon)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3) 
	--to deck and remove 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TOEXTRA+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_REMOVED) 
	e4:SetCondition(c77014515.tdrcon)
	e4:SetTarget(c77014515.tdrtg)
	e4:SetOperation(c77014515.tdrop)
	c:RegisterEffect(e4)
end
function c77014515.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(77000528)
end
function c77014515.castg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():GetFlagEffect(77014515)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_HAND)
end 
function c77014515.cspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp) 
end 
function c77014515.casop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND) 
	if g:GetCount()>0 then 
	Duel.ConfirmCards(tp,g) 
	if g:IsExists(c77014515.cspfil,1,nil,e,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	if tc and Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP_ATTACK) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2) 
	end
	Duel.SpecialSummonComplete()
	end 
	end 
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(77014515,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end 
function c77014515.recon(e)
	return e:GetHandler():IsFaceup()
end
function c77014515.ckfil(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_BATTLE+REASON_EFFECT) 
end
function c77014515.tdrcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c77014515.ckfil,1,nil)   
end 
function c77014515.trmfil(c) 
	return c:IsSetCard(0xee2) and c:IsAbleToRemove()  
end 
function c77014515.tdrtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(c77014515.trmfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK) 
end 
function c77014515.tdrop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c77014515.trmfil,tp,LOCATION_DECK,0,nil)
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and g:GetCount()>0 then 
	Duel.BreakEffect() 
	local rg=g:Select(tp,1,1,nil) 
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) 
	end  
end 



