--凶导的异教审判官 
function c11634015.initial_effect(c)
	c:EnableReviveLimit()
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11634015)
	e1:SetCondition(c11634015.tgcon)
	e1:SetTarget(c11634015.tgtg)
	e1:SetOperation(c11634015.tgop)
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTargetRange(LOCATION_MZONE,0) 
	e2:SetValue(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetMatchingGroupCount(function(c) return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) end,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)*300 end) 
	c:RegisterEffect(e2) 
	--to grave and hand
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE) 
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(function(e) 
	local tp=e:GetHandlerPlayer() 
	return e:GetHandler():GetReasonPlayer()==1-tp end) 
	e3:SetTarget(c11634015.tghtg)
	e3:SetOperation(c11634015.tghop)
	c:RegisterEffect(e3) 
end 
function c11634015.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c11634015.tgck(g,tp) 
	return g:GetClassCount(Card.GetControler)==g:GetCount() 
end 
function c11634015.tgtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	if chk==0 then return g:CheckSubGroup(c11634015.tgck,1,2,tp) and Duel.IsExistingMatchingCard(nil,1-tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_EXTRA)
end
function c11634015.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #rg>0 then
		Duel.ConfirmCards(tp,rg)
	end 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil) 
	if g:CheckSubGroup(c11634015.tgck,1,2,tp) then 
		local sg=g:SelectSubGroup(tp,c11634015.tgck,false,1,2,tp) 
		local atk=0 
		if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then atk=sg:GetSum(Card.GetAttack) end 
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(math.floor(atk/2))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE) 
			c:RegisterEffect(e1)
		end
	end
end
function c11634015.tghfilter(c)
	return c:IsSetCard(0x145) and not c:IsCode(11634015) and c:IsAbleToHand()
end
function c11634015.tghtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,nil) and Duel.IsExistingMatchingCard(c11634015.tghfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c11634015.tghop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst() 
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c11634015.tghfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end 
	end  
end


