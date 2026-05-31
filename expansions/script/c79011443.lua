--佩恩 「漂泊浪客」 - 饿鬼道
function c79011443.initial_effect(c) 
	c:SetUniqueOnField(1,0,79011443)
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
	e1:SetCountLimit(1,79011443) 
	e1:SetTarget(c79011443.cgtg)
	e1:SetOperation(c79011443.cgop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetTarget(c79011443.thtg)
	e2:SetOperation(c79011443.thop)
	c:RegisterEffect(e2)  
	--dun 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE) 
	e1:SetCountLimit(1,19011443)
	e1:SetCondition(function(e) 
	return e:GetHandler():GetSequence()==0 end) 
	e1:SetTarget(c79011443.duntg) 
	e1:SetOperation(c79011443.dunop)  
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
c79011443.SetCard_Pain_PBLK=true   
function c79011443.cspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetMZoneCount(tp,e:GetHandler())>0 and c.SetCard_Pain_PBLK and Duel.IsExistingMatchingCard(c79011443.spsetfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and c:GetSequence()==4 
end 
function c79011443.spsetfil(c,e,tp,sc) 
	local lv=sc:GetOriginalLevel() 
	local pc=Duel.GetFieldCard(tp,LOCATION_PZONE,0) 
	if pc and pc.SetCard_Pain_PBLK and pc:GetOriginalLevel()==lv-1 then 
		lv=lv-1 
	end 
	if lv==1 then lv=7 end 
	return c.SetCard_Pain_PBLK and c:GetOriginalLevel()==lv-1  
end 
function c79011443.cgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(c79011443.cspfil,tp,LOCATION_PZONE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end 
function c79011443.cgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local sc=Duel.GetFirstMatchingCard(c79011443.cspfil,tp,LOCATION_PZONE,0,nil,e,tp)
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and sc and Duel.SpecialSummon(sc,0,tp,tp,true,true,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c79011443.spsetfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,sc) then 
		Duel.BreakEffect()
		local tc=Duel.SelectMatchingCard(tp,c79011443.spsetfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sc):GetFirst() 
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)   
		Duel.MoveSequence(tc,4)
	end 
end 
function c79011443.thfilter(c)
	return aux.IsCodeListed(c,79011443) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c79011443.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79011443.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c79011443.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79011443.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c79011443.dunfilter(c)
	return c:IsFaceup() and c.SetCard_Pain_PBLK 
end
function c79011443.duntg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c79011443.dunfilter,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.SelectTarget(tp,c79011443.dunfilter,tp,LOCATION_MZONE,0,1,1,nil) 
	e:SetCategory(0)
	local ch=Duel.GetCurrentChain()
	if ch>1 and Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER)==1-tp then
		e:SetCategory(CATEGORY_DRAW) 
	end  
end
function c79011443.dunop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		--immuse
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_IMMUNE_EFFECT) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetOwnerPlayer(tp)  
		e1:SetValue(function(e,te) 
		return te:IsActivated() and te:GetOwnerPlayer()~=e:GetOwnerPlayer() end) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN) 
		tc:RegisterEffect(e1)   
		local ch=Duel.GetCurrentChain()
		if ch>1 then
			local p=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER)  
			if p==1-tp then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end 
	end 
end 



