--绯红勇者传说·剧场版 EX
function c77096010.initial_effect(c)
	aux.AddCodeList(c,77096005) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,77096010)
	e2:SetCondition(c77096010.coincon)
	e2:SetTarget(c77096010.cointg)
	e2:SetOperation(c77096010.coinop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(77096010)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,77032549))
	e3:SetCondition(function(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(77096010)==0 or c:IsHasEffect(EFFECT_CANNOT_DISABLE) end)
	c:RegisterEffect(e3)
end
c77096010.toss_coin=true
function c77096010.coincon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c77096010.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c77096010.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=Duel.TossCoin(tp,1)
	if res==0 then
		c:RegisterFlagEffect(77096010,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2) 
	else  
		local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsCode(77096008,77096009) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,1,1,nil) 
		if sg:GetCount()>0 then 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg) 
		end 
	end
end



