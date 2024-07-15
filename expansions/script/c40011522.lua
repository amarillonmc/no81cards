--昔日之黑暗骑士 影潜者 奥布斯克迪特
function c40011522.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)   
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,40011522) 
	e2:SetTarget(c40011522.thxtg)
	e2:SetOperation(c40011522.thxop)
	c:RegisterEffect(e2)   
	--trap effect 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE) 
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,40011522+1)
	e3:SetCondition(c40011522.discon) 
	e3:SetTarget(c40011522.distg)
	e3:SetOperation(c40011522.disop)
	c:RegisterEffect(e3) 
end
function c40011522.thxfilter(c)
	return c:IsSetCard(0xaf1b) and not c:IsCode(40011522) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c40011522.thxtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40011522.thxfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40011522.thxfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c40011522.thxfilter,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c40011522.thxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) then 
		--extra attack
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)
		if tc:IsRelateToEffect(e) then 
			Duel.SendtoHand(tc,nil,REASON_EFFECT) 
		end 
	end 
end
function c40011522.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if not (c:IsFacedown()) then return false end 
	return ep==1-tp and Duel.GetCurrentChain()==0  
	and (e:GetHandler():GetTurnID()~=Duel.GetTurnCount() or e:GetHandler():IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN)) 
end 
function c40011522.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c40011522.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.NegateSummon(eg)
	if Duel.Destroy(eg,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		c:CancelToGrave() 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 

