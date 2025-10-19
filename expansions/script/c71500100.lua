--伟大先贤 安
function c71500100.initial_effect(c)
	aux.AddSetNameMonsterList(c,0x78f1)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--search
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,71500100)
	e1:SetCost(c71500100.srcost)
	e1:SetTarget(c71500100.srtg)
	e1:SetOperation(c71500100.srop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11500100)
	e2:SetCost(c71500100.cost)
	e2:SetTarget(c71500100.thtg)
	e2:SetOperation(c71500100.thop)
	c:RegisterEffect(e2)
	--xx
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e3:SetCode(EVENT_LEAVE_FIELD) 
	e3:SetCountLimit(1,21500100)
	e3:SetCost(c71500100.cost)
	e3:SetTarget(c71500100.xxtg)
	e3:SetOperation(c71500100.xxop)
	c:RegisterEffect(e3)
	--return
	aux.EnableSpiritReturn(c,EVENT_SPSUMMON_SUCCESS)
	Duel.AddCustomActivityCounter(71500100,ACTIVITY_SPSUMMON,c71500100.counterfilter)
end
function c71500100.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) 
end
function c71500100.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71500100,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c) 
	return c:IsLocation(LOCATION_EXTRA) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c71500100.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and c71500100.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	c71500100.cost(e,tp,eg,ep,ev,re,r,rp,1) 
end
function c71500100.srfilter(c)
	return c:IsCode(71500109) and c:IsAbleToHand()
end
function c71500100.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71500100.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c71500100.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71500100.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	end
end
function c71500100.thfilter(c) 
	return aux.IsSetNameMonsterListed(c,0x78f1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c71500100.plfil(c) 
	return not c:IsForbidden()  
end 
function c71500100.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71500100.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE) and Duel.IsExistingMatchingCard(c71500100.plfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71500100.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71500100.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)  
		if Duel.GetLocationCount(tp,LOCATION_SZONE) and Duel.IsExistingMatchingCard(c71500100.plfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) then 
		local tc=Duel.SelectMatchingCard(tp,c71500100.plfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil):GetFirst() 
			Duel.BreakEffect()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE) 
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1) 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_COUNTER_PERMIT|0x78f1) 
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetRange(LOCATION_SZONE)  
			tc:RegisterEffect(e1) 
			tc:AddCounter(0x78f1,9)   
		end 
	end 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetCountLimit(1) 
	e1:SetCondition(c71500100.xtdcon) 
	e1:SetOperation(c71500100.xtdop) 
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)  
	Duel.RegisterEffect(e1,tp)
end
function c71500100.xtdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp  
end 
function c71500100.xtdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,nil) 
	Duel.Hint(HINT_CARD,0,71500100)
	if g:GetCount()>0 then  
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end   
	e:Reset()
end
function c71500100.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c71500100.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_TOSS_COIN_NEGATE) 
	e1:SetCondition(c71500100.coincon)
	e1:SetOperation(c71500100.coinop) 
	e1:SetReset(RESET_PHASE+PHASE_END,2)  
	Duel.RegisterEffect(e1,tp)  
end 
function c71500100.coincon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetFlagEffectLabel(tp,71500100)<3 
end
function c71500100.coinop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffectLabel(tp,71500100)>=3 then return end 
	if Duel.SelectYesNo(tp,aux.Stringid(71500100,0)) then
		Duel.Hint(HINT_CARD,0,71500100) 
		local flag=Duel.GetFlagEffectLabel(tp,71500100)
		if flag==nil then 
			Duel.RegisterFlagEffect(tp,71500100,RESET_PHASE+PHASE_END,0,1,1) 
		else 
			Duel.SetFlagEffectLabel(tp,71500100,flag+1)
		end  
		Duel.TossCoin(tp,ev)
	end
end






 