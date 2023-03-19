--澄炎龙 灼龙
function c33332105.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c) 
	--sp and sy 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,33332105) 
	e1:SetTarget(c33332105.ssytg) 
	e1:SetOperation(c33332105.ssyop) 
	c:RegisterEffect(e1) 
	--to grave
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_DESTROYED) 
	e2:SetCountLimit(1,13332105) 
	e2:SetCondition(c33332105.tgcon)
	e2:SetTarget(c33332105.tgtg)
	e2:SetOperation(c33332105.tgop)
	c:RegisterEffect(e2) 
	--to hand and des
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,23332105)
	e3:SetTarget(c33332105.thdtg) 
	e3:SetOperation(c33332105.thdop) 
	c:RegisterEffect(e3) 
end
function c33332105.syfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x6567) and c:IsType(TYPE_TUNER) 
end 
function c33332105.ssytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c33332105.syfil,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local g=Duel.SelectTarget(tp,c33332105.syfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end 
function c33332105.espfil(c,e,tp,mg) 
	return c:IsSynchroSummonable(nil,mg)  
end 
function c33332105.ssyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) then 
		local mg=Group.FromCards(c,tc) 
		if Duel.IsExistingMatchingCard(c33332105.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) and Duel.SelectYesNo(tp,aux.Stringid(33332105,0)) then 
			local sc=Duel.SelectMatchingCard(tp,c33332105.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst() 
			Duel.SynchroSummon(tp,sc,nil,mg)   
		end 
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33332105.splimit)
	Duel.RegisterEffect(e1,tp) 
end
function c33332105.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsAttribute(ATTRIBUTE_FIRE)
end
function c33332105.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end 
function c33332105.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetTargetPlayer(1-tp) 
	Duel.SetTargetParam(500) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c33332105.tgop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT) 
end 
function c33332105.tsrfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x6567) and c:IsType(TYPE_TUNER) 
end 
function c33332105.thdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33332105.tsrfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end 
function c33332105.thdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33332105.tsrfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)  
		if c:IsRelateToEffect(e) then 
			Duel.BreakEffect() 
			Duel.Destroy(c,REASON_EFFECT)   
		end   
	end  
end 
