--负荷领域的观测者
function c11561003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c11561003.spcon)
	c:RegisterEffect(e1)
	--remove 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c11561003.rmcon) 
	e2:SetOperation(c11561003.rmop) 
	c:RegisterEffect(e2) 
	--dice 
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_DICE+CATEGORY_REMOVE+CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCountLimit(1,11561003) 
	e3:SetTarget(c11561003.ditg) 
	e3:SetOperation(c11561003.diop)  
	c:RegisterEffect(e3) 
end
c11561003.toss_dice=true
function c11561003.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c11561003.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAbleToRemove() and not Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c.toss_dice end,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
end 
function c11561003.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,11561003) 
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11561003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,21561003) 
	e1:SetTarget(c11561003.sptg)
	e1:SetOperation(c11561003.spop)
	c:RegisterEffect(e1)
end  
function c11561003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11561003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11561003.ditg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end 
function c11561003.thfil(c) 
	return c.toss_dice and not c:IsCode(11561003) and c:IsAbleToHand() 
end 
function c11561003.xspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c.toss_dice and c:IsType(TYPE_MONSTER)   
end 
function c11561003.diop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==2 then 
		if Duel.IsExistingMatchingCard(c11561003.thfil,tp,LOCATION_DECK,0,1,nil) then 
			local sg=Duel.SelectMatchingCard(tp,c11561003.thfil,tp,LOCATION_DECK,0,1,1,nil) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg)   
		end 
	elseif dc==3 or dc==4 then 
		--if Duel.Draw(tp,1,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) then 
		--  local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil) 
		--  Duel.SendtoDeck(sg,nil,1,REASON_EFFECT) 
		--end 
		--if Duel.Draw(1-tp,1,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,1-tp,LOCATION_HAND,0,1,nil) then 
		--  local sg=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,1-tp,LOCATION_HAND,0,1,1,nil) 
		--  Duel.SendtoDeck(sg,nil,1,REASON_EFFECT) 
		--end 
		Duel.Draw(tp,1,REASON_EFFECT) 
	elseif dc==5 or dc==6 then 
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,nil) then 
			local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,nil):GetFirst() 
			if Duel.Remove(tc,0,REASON_EFFECT)~=0 then 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY) 
			e1:SetRange(LOCATION_REMOVED) 
			e1:SetLabel(Duel.GetTurnCount())  
			e1:SetCountLimit(1) 
			e1:SetCondition(function(e)  
			return Duel.GetTurnCount()~=e:GetLabel() end)  
			e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) 
			e:Reset() 
			Duel.Hint(HINT_CARD,0,11561003)
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) end) 
			tc:RegisterEffect(e1) 
				if Duel.IsExistingMatchingCard(c11561003.xspfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(11561003,0)) then 
					Duel.BreakEffect() 
					local sg=Duel.SelectMatchingCard(tp,c11561003.xspfil,tp,LOCATION_HAND,0,1,1,nil,e,tp) 
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
				end 
			end 
		end   
	end 
end 











