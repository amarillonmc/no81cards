--隐匿虫 蟑螂
local m=11626300
local cm=_G["c"..m]
function c11626300.initial_effect(c)
	--to deck 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,11626300) 
	e1:SetCondition(c11626300.htdcon)
	e1:SetCost(c11626300.htdcost)
	e1:SetTarget(c11626300.htdtg) 
	e1:SetOperation(c11626300.htdop) 
	c:RegisterEffect(e1) 
	--buff
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_DECK)
	e4:SetCondition(c11626300.hxspecon)
	e4:SetOperation(c11626300.hxspeop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetRange(LOCATION_DECK)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetValue(c11626300.damval)
	c:RegisterEffect(e5)
	--Destroy
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_TO_HAND) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCondition(c11626300.descon)
	e2:SetTarget(c11626300.destg) 
	e2:SetOperation(c11626300.desop) 
	c:RegisterEffect(e2) 
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11626300,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND) 
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c11626300.indtg)
	e3:SetOperation(c11626300.indop)
	c:RegisterEffect(e3)
	if not c11626300.global_check then
		c11626300.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c11626300.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
	if not cm.gchk then
		cm.gchk=true
		cm[0]=3
		cm[1]=3
	end
	Duel.AddCustomActivityCounter(11626300,ACTIVITY_SPSUMMON,c11626300.counterfilter)
end
function c11626300.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	if rc:IsType(TYPE_MONSTER) and not rc:IsRace(RACE_INSECT) then 
		Duel.RegisterFlagEffect(rp,11626300,RESET_PHASE+PHASE_END,0,1) 
	end 
end
function c11626300.counterfilter(c)
	return c:IsRace(RACE_INSECT) 
end
--01
function c11626300.htdcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetOwner()
	return tp==p  
end 
function c11626300.htdcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return  Duel.GetCustomActivityCount(11626300,tp,ACTIVITY_SPSUMMON)==0 end  
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c11626300.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp) 
end
function c11626300.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_INSECT) 
end
function c11626300.htdfil(c) 
	return c:IsAbleToDeck() and c:IsSetCard(0x3220) and c:IsType(TYPE_MONSTER) 
end 
function c11626300.htdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(c11626300.hsrfil,tp,LOCATION_DECK,0,1,nil)  end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end 
function c11626300.hsrfil(c) 
	return c:IsSetCard(0x3220) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() 
end 
function c11626300.htdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	if (not c:IsRelateToEffect(e)) or (not c:IsLocation(LOCATION_HAND)) then return end  
	Duel.SendtoDeck(c,1-tp,1,REASON_EFFECT)  
	if not c:IsLocation(LOCATION_DECK)  then return end 
	Duel.ShuffleDeck(1-tp) 
	c:ReverseInDeck()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local dg=Duel.SelectMatchingCard(tp,c11626300.hsrfil,tp,LOCATION_DECK,0,1,1,nil) 
	Duel.SendtoHand(dg,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,dg)   
end 
function c11626300.hxspecon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(Card.IsSummonPlayer,1,nil,tp) and e:GetHandler():IsFaceup()
end 
function c11626300.pbfil(c) 
	return not c:IsPublic() and c:IsAbleToDeck() and not c:IsSetCard(0x3220)
end 
function c11626300.hxspeop(e,tp,eg,ep,ev,re,r,rp)
	if cm[rp]<=1 then
		cm[rp]=3
		local c=e:GetHandler() 
		if eg:IsExists(Card.IsSummonPlayer,1,nil,tp) then 
			Duel.Hint(HINT_CARD,0,11626300) 
			Duel.Draw(tp,1,REASON_EFFECT) 
		end 
	else cm[rp]=cm[rp]-1 end
end 
function c11626300.damval(e,re,val,r,rp)
	if r&REASON_EFFECT~=0 and re and e:GetHandler():IsFaceup() then
		local rc=re:GetHandler()
		if not rc:IsSetCard(0x3220) then
			return 100
			end
	end
	return val
end
--02
function c11626300.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) and e:GetHandler():IsPreviousPosition(POS_FACEUP) 
end 
function c11626300.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11626300.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then
		Duel.Draw(tp,1,REASON_EFFECT)
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(c,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
--03
--mxph
function cm.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) 
end
function cm.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and cm.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.thfil(c) 
	return c:IsSetCard(0x3220) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end 
function cm.indop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,cm.desfilter,1-tp,LOCATION_ONFIELD,0,1,2,nil) 
	if Duel.Destroy(dg,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfil,tp,LOCATION_GRAVE,0,1,1,nil) 
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end 
	end
end 