--黄金女仆 黄金国小蓝
function c10105665.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(10105665,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,10105665)
	e1:SetTarget(c10105665.thtg)
	e1:SetOperation(c10105665.thop)
	c:RegisterEffect(e1)	
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--to hand and sp 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,20105665)
	e2:SetTarget(c10105665.tsptg)
	e2:SetOperation(c10105665.tspop)
	c:RegisterEffect(e2)
end
function c10105665.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c10105665.thfilter(c)
	return c:IsSetCard(0x143,0x2142) and c:IsAbleToHand()
end
function c10105665.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c10105665.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(10105665,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c10105665.thfilter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end
function c10105665.spfilter(c,e,tp,check)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (check or c:IsSetCard(0x1142))
end
function c10105665.tsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local chk1=Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0x1142) and c:IsFaceup() end,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.IsExistingMatchingCard(c10105665.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,chk1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE) 
end 
function c10105665.tspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then 
		 local chk1=Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0x1142) and c:IsFaceup() end,tp,LOCATION_MZONE,0,1,nil) 
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		 local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10105665.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,chk1):GetFirst()
		 if tc then
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then 
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(1000)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e2)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
				e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetRange(LOCATION_MZONE)
				e3:SetValue(1)
				tc:RegisterEffect(e3)
			end 
			Duel.SpecialSummonComplete()
		end 
	end 
end 








