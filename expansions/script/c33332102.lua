--澄炎造物 熔火灵
function c33332102.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c) 
	--search
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,33332102)
	e1:SetTarget(c33332102.thtg)
	e1:SetOperation(c33332102.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33332102,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED) 
	e3:SetCondition(c33332102.tgcon)
	e3:SetTarget(c33332102.tgtg)
	e3:SetOperation(c33332102.tgop)
	c:RegisterEffect(e3) 
	--scale up 
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_IGNITION) 
	e4:SetRange(LOCATION_PZONE) 
	e4:SetCountLimit(1) 
	e4:SetTarget(c33332102.sctg) 
	e4:SetOperation(c33332102.scop)   
	c:RegisterEffect(e4) 
	--indes 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD) 
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(LOCATION_PZONE,0) 
	e5:SetTarget(function(e,c) 
	return c~=e:GetHandler() end) 
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c33332102.thfilter(c)
	return c:IsSetCard(0x6567) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c33332102.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33332102.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33332102.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33332102.thfilter,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg) 
		if c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.SelectYesNo(tp,aux.Stringid(33332102,0)) then
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)	
		end 
	end
end
function c33332102.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c33332102.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6567) and c:IsAbleToGrave()
end
function c33332102.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33332102.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c33332102.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33332102.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end 
function c33332102.pbfil(c) 
	return c:IsLevelAbove(1) and c:IsSetCard(0x6567) and not c:IsPublic()  
end 
function c33332102.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33332102.pbfil,tp,LOCATION_HAND,0,1,nil) end 
	local tc=Duel.SelectMatchingCard(tp,c33332102.pbfil,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,tc) 
	e:SetLabelObject(tc) 
end 
function c33332102.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=e:GetLabelObject() 
	local lv=tc:GetLevel()
	if c:IsRelateToEffect(e) and c:IsFaceup() and lv>0 then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_LSCALE) 
		e1:SetRange(LOCATION_PZONE) 
		e1:SetValue(lv)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_RSCALE) 
		e1:SetRange(LOCATION_PZONE) 
		e1:SetValue(lv)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)  
	end  
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33332102.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33332102.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x6567) and sumtype&SUMMON_TYPE_PENDULUM==SUMMON_TYPE_PENDULUM 
end



