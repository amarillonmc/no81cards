--幻影英雄 强权人
function c13131367.initial_effect(c)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,13131367) 
	e1:SetTarget(c13131367.sptg) 
	e1:SetOperation(c13131367.spop) 
	c:RegisterEffect(e1) 
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,23131367)
	e2:SetTarget(c13131367.thtg)
	e2:SetOperation(c13131367.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3) 
	--draw 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCountLimit(1,33131367)
	e4:SetCondition(c13131367.drcon)
	e4:SetTarget(c13131367.drtg)
	e4:SetOperation(c13131367.drop)
	c:RegisterEffect(e4)
end 
function c13131367.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x5008)   
end 
function c13131367.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(c13131367.spfil,tp,LOCATION_SZONE,0,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) end 
	local g=Duel.SelectTarget(tp,c13131367.spfil,tp,LOCATION_SZONE,0,1,1,nil,e,tp) 
	g:AddCard(e:GetHandler()) 
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0) 
end  
function c13131367.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e) 
	if sg:GetCount()>=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 
function c13131367.thfilter(c)
	return c:IsCode(57425061) and c:IsAbleToHand()
end
function c13131367.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13131367.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c13131367.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c13131367.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c13131367.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_FUSION and c:GetReasonCard():IsSetCard(0x8) 
end
function c13131367.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2) 
end 
function c13131367.plfil(c) 
	return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end 
function c13131367.drop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(c13131367.plfil,tp,LOCATION_HAND,0,1,nil) then	  
		local tc=Duel.SelectMatchingCard(tp,c13131367.plfil,tp,LOCATION_HAND,0,1,1,nil):GetFirst() 
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)  
		else 
		local sg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		end 
	end
end







