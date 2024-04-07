--异虫共鸣
function c49811314.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e0) 
	--search
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(49811314,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE) 
	e1:SetCondition(c49811314.thcon)
	e1:SetTarget(c49811314.thtg)
	e1:SetOperation(c49811314.thop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,49811314)
	e2:SetTarget(c49811314.srtg)
	e2:SetOperation(c49811314.srop)
	c:RegisterEffect(e2)
end
function c49811314.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp  
end 
function c49811314.thfilter(c,tp)
	return c:IsSetCard(0x3e) and c:IsRace(RACE_REPTILE) and Duel.GetFlagEffect(tp,49811314+c:GetOriginalCodeRule())==0 and c:IsAbleToHand()
end
function c49811314.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811314.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c49811314.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and c:IsSetCard(0x3e)  
end
function c49811314.sumfil(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0x3e) 
end
function c49811314.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c49811314.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc) 
		Duel.RegisterFlagEffect(tp,49811314+tc:GetOriginalCodeRule(),RESET_PHASE+PHASE_END,0,1)
		local xtable={}
		local op=0  
		local b1=Duel.IsExistingMatchingCard(c49811314.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		local b2=Duel.IsExistingMatchingCard(function(c) return c:IsAttackPos() and c:IsCanChangePosition() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c49811314.sumfil,tp,LOCATION_HAND,0,1,nil,e,tp)
		if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(49811314,0)) then 
			if b1 then table.insert(xtable,aux.Stringid(49811314,1)) end 
			if b2 then table.insert(xtable,aux.Stringid(49811314,2)) end 
			local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
			if xtable[op]==aux.Stringid(49811314,1) then 
				local sc=Duel.SelectMatchingCard(tp,c49811314.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()  
				if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 and Duel.IsExistingMatchingCard(function(c) return c:IsDefensePos() and c:IsCanChangePosition() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then 
					local pc=Duel.SelectMatchingCard(tp,function(c) return c:IsDefensePos() and c:IsCanChangePosition() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst() 
					Duel.ChangePosition(pc,POS_FACEUP_ATTACK)
				end 
			end 
			if xtable[op]==aux.Stringid(49811314,2) then 
				local pc=Duel.SelectMatchingCard(tp,function(c) return c:IsAttackPos() and c:IsCanChangePosition() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()  
				if pc and Duel.ChangePosition(pc,POS_FACEUP_DEFENSE)~=0 and Duel.IsExistingMatchingCard(c49811314.sumfil,tp,LOCATION_HAND,0,1,nil,e,tp) then 
					local sc=Duel.SelectMatchingCard(tp,c49811314.sumfil,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst() 
					Duel.Summon(tp,sc,true,nil) 
				end 
			end 
		end 
	end 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c49811314.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c49811314.splimit(e,c)
	return not c:IsRace(RACE_REPTILE)
end
function c49811314.srfilter(c)
	return c:IsCode(90075978) and c:IsAbleToHand()
end
function c49811314.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811314.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c49811314.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c49811314.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end





