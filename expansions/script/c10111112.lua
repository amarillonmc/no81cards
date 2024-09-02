function c10111112.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111112,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10111112)
	e1:SetCondition(c10111112.thcon)
	e1:SetTarget(c10111112.thtg)
	e1:SetOperation(c10111112.thop)
	c:RegisterEffect(e1)
	local e6=e1:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	e7:SetCondition(c10111112.thcon2)
	c:RegisterEffect(e7)
	--redirect
	aux.AddBanishRedirect(c)
	--to hand(self)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10111112,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,101111120)
	e3:SetCondition(c10111112.thcon1)
	e3:SetCost(c10111112.cost)
	e3:SetTarget(c10111112.thtg2)
	e3:SetOperation(c10111112.thop2)
	c:RegisterEffect(e3)
    	--summon 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_SUMMON+CATEGORY_DRAW) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END) 
	e4:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP) 
	e4:SetRange(LOCATION_HAND)   
	e4:SetCountLimit(1,101111121) 
    e4:SetCost(c10111112.cost)
	e4:SetCondition(c10111112.spcon)
	e4:SetTarget(c10111112.sumtg) 
	e4:SetOperation(c10111112.sumop) 
	c:RegisterEffect(e4)
end
function c10111112.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c10111112.cfilter(c,sp)
	return c:IsSummonPlayer(sp)
end
function c10111112.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10111112.cfilter,1,nil,1-tp)
end
function c10111112.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c10111112.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function c10111112.thfilter(c)
	return c:IsSetCard(0x16d) and c:IsSSetable()
end
function c10111112.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsRace(RACE_WINDBEAST)
end
function c10111112.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.Remove(c,POS_FACEUP,REASON_EFFECT) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local seg=Duel.SelectMatchingCard(tp,c10111112.thfilter,tp,0x11,0,1,1,nil)
		if seg:GetCount()>0 and Duel.SSet(tp,seg) then
			if Duel.IsExistingMatchingCard(c10111112.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(10111112,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local sg=Duel.SelectMatchingCard(tp,c10111112.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
				if sg:GetCount()>0 then
					Duel.Summon(tp,sg:GetFirst(),true,nil)
				end
			end
		end
	end
end
function c10111112.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsControler(tp) and ec:IsRace(RACE_WINDBEAST)
end
function c10111112.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10111112.thop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
function c10111112.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c10111112.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonable(true,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0) 
end 
function c10111112.sckfil(c) 
	return c:GetSequence()<5   
end 
function c10111112.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.Summon(tp,c,true,nil)  
	end 
end