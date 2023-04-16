--澄炎之狂徒 慈华
function c33332100.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),aux.NonTuner(c33332100.mfilter),1)
	c:EnableReviveLimit() 
	--to hand and dam 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1) 
	e1:SetTarget(c33332100.thdtg) 
	e1:SetOperation(c33332100.thdop) 
	c:RegisterEffect(e1) 
	--remove  
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c33332100.rmcon) 
	e2:SetTarget(c33332100.rmtg)
	e2:SetOperation(c33332100.rmop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_PZONE) 
	e3:SetTarget(c33332100.psptg) 
	e3:SetOperation(c33332100.pspop) 
	c:RegisterEffect(e3) 
end
function c33332100.mfilter(c) 
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_FIRE)  
end
function c33332100.thfil(c) 
	return c:IsAbleToHand() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_TUNER) 
end  
function c33332100.thdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c33332100.thfil,tp,LOCATION_GRAVE,0,1,nil) end 
	local tc=Duel.SelectTarget(tp,c33332100.thfil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst() 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0) 
end 
function c33332100.thdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(tc:GetLevel()*300) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)
	end 
end 
function c33332100.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER)-- and not re:GetHandler():IsAttribute(ATTRIBUTE_FIRE)
end 
function c33332100.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) and re:GetHandler():IsAbleToRemove() end
	local tc=eg:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetLevel()*300)
end
function c33332100.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local tc=eg:GetFirst()
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT) then 
		Duel.BreakEffect()
		if Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
			Duel.Damage(1-tp,tc:GetLevel()*300,REASON_EFFECT)
		end
	end 
end
function c33332100.sctfil(c) 
	if c:IsLocation(LOCATION_EXTRA) then 
	return c:IsAbleToGrave() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLevelAbove(1) and c:IsFaceup() 
	else return c:IsAbleToGrave() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLevelAbove(1) end 
end 
function c33332100.sctgck(g,tp) 
	return g:CheckWithSumGreater(Card.GetLevel,9) and Duel.GetMZoneCount(tp,g)>0 
end 
function c33332100.pspcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c33332100.sctfil,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_EXTRA,0,nil)
	if chk==0 then return  end 
	local sg=g:SelectSubGroup(tp,c33332100.sctgck,false,1,99,tp) 
	Duel.SendtoGrave(sg,REASON_COST) 
end 
function c33332100.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c33332100.sctfil,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_EXTRA,0,nil) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and g:CheckSubGroup(c33332100.sctgck,1,99,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c33332100.pspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33332100.sctfil,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_EXTRA,0,nil) 
	if g:CheckSubGroup(c33332100.sctgck,1,99,tp) then 
		local sg=g:SelectSubGroup(tp,c33332100.sctgck,false,1,99,tp) 
		if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
		end 
	end 
end 










