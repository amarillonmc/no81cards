--被遗忘的研究 夏露奥米茄III形解放·完全燃烧
function c43480045.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c43480045.lcheck)
	c:EnableReviveLimit()  
	--equip
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,43480045) 
	e1:SetTarget(c43480045.eqtg)
	e1:SetOperation(c43480045.eqop)
	c:RegisterEffect(e1) 
	--remove 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_CHAINING) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,43480046) 
	e2:SetCondition(c43480045.rmdcon)
	e2:SetTarget(c43480045.rmdtg) 
	e2:SetOperation(c43480045.rmdop)  
	c:RegisterEffect(e2) 
	--Special Summon 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,43480047)
	e3:SetCondition(c43480045.spcon)
	e3:SetTarget(c43480045.sptg)
	e3:SetOperation(c43480045.spop) 
	c:RegisterEffect(e3)
end
function c43480045.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3f13)
end
function c43480045.eqfilter(c,tp)
	return c:IsSetCard(0x3f13) and c:IsFaceup() and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end 
function c43480045.eqtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local ct=e:GetHandler():GetMaterial():FilterCount(Card.IsType,nil,TYPE_PENDULUM) 
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE) 
	if ct>ft then ct=ft end 
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c43480045.eqfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end 
end
function c43480045.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local ct=e:GetHandler():GetMaterial():FilterCount(Card.IsType,nil,TYPE_PENDULUM) 
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE) 
	if ct>ft then ct=ft end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c43480045.eqfilter,tp,LOCATION_EXTRA,0,1,ct,nil,tp) 
	if g:GetCount()<=0 then return end 
	local tc=g:GetFirst()
	while tc do 
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(function(e,c)
		return e:GetOwner()==c end)
		tc:RegisterEffect(e1) 
	tc=g:GetNext() 
	end
end
function c43480045.rmdcon(e,tp,eg,ep,ev,re,r,rp) 
	local b1=re:IsActiveType(TYPE_MONSTER) and Duel.GetFlagEffect(tp,43480045)==0
	local b2=re:IsActiveType(TYPE_SPELL) and Duel.GetFlagEffect(tp,4348046)==0 
	local b3=re:IsActiveType(TYPE_TRAP) and Duel.GetFlagEffect(tp,4348047)==0 
	return rp==1-tp and (b1 or b2 or b3) 
end 
function c43480045.desfil(c,e) 
	return c:GetEquipTarget()==e:GetHandler()  
end 
function c43480045.rmdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and c43480045.desfil(chkc,e) end  
	if chk==0 then return Duel.IsExistingTarget(c43480045.desfil,tp,LOCATION_SZONE,0,1,nil,e) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.SelectTarget(tp,c43480045.desfil,tp,LOCATION_SZONE,0,1,1,nil,e) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD) 
	if re:IsActiveType(TYPE_MONSTER) then 
		Duel.RegisterFlagEffect(tp,43480045,RESET_PHASE+PHASE_END,0,1)
	end 
	if re:IsActiveType(TYPE_SPELL) then 
		Duel.RegisterFlagEffect(tp,4348046,RESET_PHASE+PHASE_END,0,1)
	end 
	if re:IsActiveType(TYPE_TRAP) then 
		Duel.RegisterFlagEffect(tp,4348047,RESET_PHASE+PHASE_END,0,1)
	end 
end
function c43480045.rmdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) then 
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 then  
			local etype=0 
			if re:IsActiveType(TYPE_MONSTER) then 
				etype=bit.bor(etype,TYPE_MONSTER)  
			end 
			if re:IsActiveType(TYPE_SPELL) then 
				etype=bit.bor(etype,TYPE_SPELL)  
			end 
			if re:IsActiveType(TYPE_TRAP) then 
				etype=bit.bor(etype,TYPE_TRAP)  
			end 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_IMMUNE_EFFECT) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetLabel(etype) 
			e1:SetValue(function(e,te)
			return te:IsActiveType(e:GetLabel()) end) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			c:RegisterEffect(e1) 
		end   
	end 
end 
function c43480045.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 
end
function c43480045.spfilter(c,e,tp)
	return c:IsCode(43480040) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43480045.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c43480045.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c43480045.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c43480045.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true) 
		Duel.SpecialSummonComplete() 
	end
end 



