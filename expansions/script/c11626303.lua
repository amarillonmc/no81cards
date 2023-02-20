--隐匿虫 苍蝇
function c11626303.initial_effect(c)
	--to deck 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,11626303) 
	e1:SetCondition(c11626303.htdcon) 
	e1:SetCost(c11626303.htdcost)
	e1:SetTarget(c11626303.htdtg) 
	e1:SetOperation(c11626303.htdop) 
	c:RegisterEffect(e1) 
	--Destroy
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_TO_HAND) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCondition(c11626303.descon)  
	e2:SetTarget(c11626303.destg) 
	e2:SetOperation(c11626303.desop) 
	c:RegisterEffect(e2) 
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11626303,2))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE) 
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c11626303.indtg)
	e3:SetCondition(c11626303.indcon)
	e3:SetOperation(c11626303.indop)
	c:RegisterEffect(e3)
	if not c11626303.global_check then
		c11626303.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c11626303.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	Duel.AddCustomActivityCounter(11626303,ACTIVITY_SPSUMMON,c11626303.counterfilter) 
end 
c11626303.SetCard_YM_Crypticinsect=true 
function c11626303.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	if rc:IsType(TYPE_MONSTER) and not rc:IsRace(RACE_INSECT) then 
		Duel.RegisterFlagEffect(rp,11626303,RESET_PHASE+PHASE_END,0,1) 
	end 
end
function c11626303.counterfilter(c)
	return c:IsRace(RACE_INSECT) 
end
--01
function c11626303.htdcon(e,tp,eg,ep,ev,re,r,rp) 
	local p=e:GetHandler():GetOwner()
	return tp==p and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end 
function c11626303.htdcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFlagEffect(tp,11626303)==0 and Duel.GetCustomActivityCount(11626303,tp,ACTIVITY_SPSUMMON)==0 end  
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e1:SetTargetRange(1,0) 
	e1:SetValue(c11626303.actlimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)   
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c11626303.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp) 
end 
function c11626303.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsRace(RACE_INSECT)
end
function c11626303.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_INSECT)
end

function c11626303.htdfil(c) 
	return c:IsAbleToDeck() and c.SetCard_YM_Crypticinsect and c:IsType(TYPE_MONSTER) 
end 
function c11626303.htdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND)
end 
function c11626303.hsrfil(c) 
	return c.SetCard_YM_Crypticinsect and c:IsAbleToHand() 
end 
function c11626303.htdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if (not c:IsRelateToEffect(e)) or (not c:IsLocation(LOCATION_HAND)) then return end  
	Duel.SendtoDeck(c,1-tp,1,REASON_EFFECT)  
	if not c:IsLocation(LOCATION_DECK) then return end 
		Duel.ShuffleDeck(1-tp) 
		c:ReverseInDeck() 
		if Duel.IsExistingMatchingCard(c11626303.hsrfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11626303,0)) then 
		Duel.BreakEffect() 
		local dg=Duel.SelectMatchingCard(tp,c11626303.hsrfil,tp,LOCATION_GRAVE,0,1,1,nil) 
		Duel.SendtoHand(dg,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,dg)  
		--
		if Duel.GetFlagEffect(tp,1111114)==0 then 
			Duel.RegisterFlagEffect(tp,1111114,0,0,0)
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
			e1:SetCode(EVENT_CHAINING)  
			e1:SetCondition(c11626303.hxtgecon) 
			e1:SetOperation(c11626303.hxtgeop) 
			Duel.RegisterEffect(e1,1-tp)
			local e1=Effect.CreateEffect(c) 
			e1:SetDescription(aux.Stringid(11626303,1))
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(11626303) 
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e1:SetTargetRange(1,0)
			Duel.RegisterEffect(e1,1-tp)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(c11626303.damval)
			Duel.RegisterEffect(e1,1-tp)
		end
	end 
end 
function c11626303.hxtgecon(e,tp,eg,ep,ev,re,r,rp) 
	return rp==tp 
end 
function c11626303.pbfil(c) 
	return not c:IsPublic() and c:IsAbleToDeck() and not c.SetCard_YM_Crypticinsect  
end 
function c11626303.hxtgeop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if rp==tp then 
		Duel.Hint(HINT_CARD,0,11626303) 
		Duel.Draw(tp,1,REASON_RULE+REASON_EFFECT) 
		if Duel.IsExistingMatchingCard(c11626303.pbfil,tp,LOCATION_HAND,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=7 then 
		local sg=Duel.SelectMatchingCard(tp,c11626303.pbfil,tp,LOCATION_HAND,0,1,1,nil) 
		Duel.ConfirmCards(1-tp,sg)
		Duel.SendtoDeck(sg,nil,1,REASON_EFFECT) 
		end 
	end 
end 
function c11626303.damval(e,re,val,r,rp)
	if r&REASON_EFFECT~=0 and re then
		local rc=re:GetHandler()
		if not rc.SetCard_YM_Crypticinsect then
			return 100
			end
	end
	return val
end
--02
function c11626303.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) and e:GetHandler():IsPreviousPosition(POS_FACEUP) 
end 
function c11626303.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11626303.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,1-tp,1-tp,false,false,POS_FACEUP)
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		Duel.Destroy(c,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--03
function c11626303.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DISABLE,g,1,0,0)
end
function c11626303.indcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler().SetCard_YM_Crypticinsect -- and re:GetHandler():IsType(TYPE_MONSTER)
end
function c11626303.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		local dg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
		local tc=dg:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)   
		end
	  --  if tc:IsType(TYPE_MONSTER) then
	  --	  local e0=Effect.CreateEffect(c)
	  --	  e0:SetType(EFFECT_TYPE_SINGLE)
	  --	  e0:SetCode(EFFECT_SET_ATTACK_FINAL)
	  --	  e0:SetValue(0)
	  --	  e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	  --	  tc:RegisterEffect(e0)
	  --  end
	end
end 







