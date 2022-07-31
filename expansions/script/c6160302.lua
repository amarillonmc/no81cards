--破碎世界的力量
function c6160302.initial_effect(c)
	c:EnableReviveLimit()  
	aux.AddXyzProcedure(c,c6160302.matfilter,3,2)  
	 --protection  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(6160302,0))  
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,6160302)  
	e1:SetCost(c6160302.prcost)  
	e1:SetOperation(c6160302.prop)  
	c:RegisterEffect(e1)  
	--to hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(6160302,1))  
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)   
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1)  
	e2:SetCost(c6160302.thcost)  
	e2:SetTarget(c6160302.thtg)  
	e2:SetOperation(c6160302.thop)  
	c:RegisterEffect(e2)
	--search  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(6160302,2))  
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)  
	e3:SetCode(EVENT_REMOVE)  
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e3:SetCountLimit(1,6360302)   
	e3:SetTarget(c6160302.sttg)  
	e3:SetOperation(c6160302.stop)  
	c:RegisterEffect(e3)  
end  
function c6160302.matfilter(c)  
	return c:IsRace(RACE_SPELLCASTER)
end 
function c6160302.prcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsReleasable() end  
	Duel.Release(e:GetHandler(),REASON_COST)  
end  
function c6160302.prop(e,tp,eg,ep,ev,re,r,rp)  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetOperation(c6160302.actop)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
end  
function c6160302.actop(e,tp,eg,ep,ev,re,r,rp)  
	local rc=re:GetHandler()  
	if re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and rc:IsSetCard(0x616) and ep==tp then  
		Duel.SetChainLimit(c6160302.chainlm)  
	end  
end  
function c6160302.chainlm(e,rp,tp)  
	return tp==rp  
end  
function c6160302.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function c6160302.thfilter(c)
	return c:IsSetCard(0x616) and c:IsLevelBelow(3)
end
function c6160302.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c6160302.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c6160302.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c6160302.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function c6160302.stfilter(c,tp)  
	return c:IsSetCard(0x616) and c:GetType()==0x20004  and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))  
end  
function c6160302.sttg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c6160302.stfilter,tp,LOCATION_DECK,0,1,nil,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c6160302.stop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)  
	local g=Duel.SelectMatchingCard(tp,c6160302.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp)  
	local tc=g:GetFirst()  
	if tc then  
		local b1=tc:IsAbleToHand()  
		local b2=tc:GetActivateEffect():IsActivatable(tp)  
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1150)==0) then  
			Duel.SendtoHand(tc,nil,REASON_EFFECT)  
			Duel.ConfirmCards(1-tp,tc)  
		else  
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)  
			local te=tc:GetActivateEffect()  
			local tep=tc:GetControler()  
			local cost=te:GetCost()  
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end  
		end  
	end  
end  