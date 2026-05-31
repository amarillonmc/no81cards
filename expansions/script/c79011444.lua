--佩恩 「漂泊浪客」 - 地狱道
function c79011444.initial_effect(c) 
	c:SetUniqueOnField(1,0,79011444)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false) 
	c:EnableReviveLimit()  
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--change 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCountLimit(1,79011444) 
	e1:SetTarget(c79011444.cgtg)
	e1:SetOperation(c79011444.cgop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetTarget(c79011444.thtg)
	e2:SetOperation(c79011444.thop)
	c:RegisterEffect(e2)  
	--dun 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE) 
	e1:SetCountLimit(1,19011444)
	e1:SetCondition(function(e) 
	return e:GetHandler():GetSequence()==0 end) 
	e1:SetTarget(c79011444.postg) 
	e1:SetOperation(c79011444.posop)  
	c:RegisterEffect(e1) 
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetValue(function(e,te) 
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer() end)
	c:RegisterEffect(e3) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(function(e) 
	local tp=e:GetHandlerPlayer()
	return Duel.GetCurrentPhase()==PHASE_END and not Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c.SetCard_Pain_PBLK end,tp,LOCATION_MZONE,0,1,nil) end)
	c:RegisterEffect(e3) 
end
c79011444.SetCard_Pain_PBLK=true   
function c79011444.cspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetMZoneCount(tp,e:GetHandler())>0 and c.SetCard_Pain_PBLK and Duel.IsExistingMatchingCard(c79011444.spsetfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and c:GetSequence()==4 
end 
function c79011444.spsetfil(c,e,tp,sc) 
	local lv=sc:GetOriginalLevel()
	local pc=Duel.GetFieldCard(tp,LOCATION_PZONE,0) 
	if pc and pc.SetCard_Pain_PBLK and pc:GetOriginalLevel()==lv-1 then 
		lv=lv-1 
	end 
	if lv==1 then lv=7 end 
	return c.SetCard_Pain_PBLK and c:GetOriginalLevel()==lv-1  
end 
function c79011444.cgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(c79011444.cspfil,tp,LOCATION_PZONE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end 
function c79011444.cgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local sc=Duel.GetFirstMatchingCard(c79011444.cspfil,tp,LOCATION_PZONE,0,nil,e,tp)
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and sc and Duel.SpecialSummon(sc,0,tp,tp,true,true,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c79011444.spsetfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,sc) then 
		Duel.BreakEffect()
		local tc=Duel.SelectMatchingCard(tp,c79011444.spsetfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sc):GetFirst() 
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)   
		Duel.MoveSequence(tc,4)
	end 
end 
function c79011444.thfilter(c)
	return aux.IsCodeListed(c,79011444) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c79011444.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79011444.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c79011444.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79011444.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c79011444.dunfilter(c)
	return c:IsFaceup() and c.SetCard_Pain_PBLK and c:IsCanTurnSet()
end
function c79011444.postg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c79011444.dunfilter,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c79011444.dunfilter,tp,LOCATION_MZONE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c79011444.posop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEDOWN)~=0 then 
		--immuse
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_IMMUNE_EFFECT) 
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetRange(LOCATION_MZONE) 
		e1:SetOwnerPlayer(tp)  
		e1:SetValue(function(e,te) 
		return te:IsActivated() and te:GetOwnerPlayer()~=e:GetOwnerPlayer() end) 
		e1:SetCondition(function(e) 
		return e:GetHandlerPlayer():IsFacedown() end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)   
		Duel.Recover(tp,1000,REASON_EFFECT)  
	end 
end 



