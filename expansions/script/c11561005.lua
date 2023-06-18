--打工战士
function c11561005.initial_effect(c)
	--xx
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DICE) 
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,11561005) 
	e1:SetCondition(function(e) 
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity() end) 
	e1:SetTarget(c11561005.xxtg) 
	e1:SetOperation(c11561005.xxop) 
	c:RegisterEffect(e1) 
	--dice 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_DICE+CATEGORY_REMOVE+CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetTarget(c11561005.ditg) 
	e2:SetOperation(c11561005.diop)  
	c:RegisterEffect(e2) 
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
end
c11561005.toss_dice=true
function c11561005.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end 
function c11561005.xxop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local x=Duel.TossDice(tp,1)   
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(x)
	e1:SetCondition(c11561005.spcon) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	c:RegisterEffect(e1)	 
end 
function c11561005.spcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler() 
	local x=e:GetLabel() 
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>x 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c11561005.ditg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end 
function c11561005.thfil(c) 
	return c.toss_dice and not c:IsCode(11561005) and c:IsAbleToHand() 
end 
function c11561005.xspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c.toss_dice and c:IsType(TYPE_MONSTER)   
end 
function c11561005.diop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==2 then 
		if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) then 
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil) 
			Duel.SendtoGrave(sg,REASON_EFFECT) 
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
		if Duel.Remove(c,0,REASON_EFFECT)~=0 then 
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
			Duel.Hint(HINT_CARD,0,11561005)
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) end) 
			c:RegisterEffect(e1) 
			if Duel.IsExistingMatchingCard(c11561005.xspfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(11561005,0)) then 
				Duel.BreakEffect() 
				local sg=Duel.SelectMatchingCard(tp,c11561005.xspfil,tp,LOCATION_HAND,0,1,1,nil,e,tp) 
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
			end 
		end  
	end 
end 
