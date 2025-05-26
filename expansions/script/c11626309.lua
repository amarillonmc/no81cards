--隐匿虫 阴险蝎
local m=11626309
local cm=_G["c"..m]
function c11626309.initial_effect(c)
	--to deck 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,11626309) 
	e1:SetCondition(c11626309.htdcon) 
	e1:SetCost(c11626309.htdcost)
	e1:SetTarget(c11626309.htdtg) 
	e1:SetOperation(c11626309.htdop) 
	c:RegisterEffect(e1) 
	--Destroy
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_TO_HAND) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCondition(c11626309.descon)  
	e2:SetTarget(c11626309.destg) 
	e2:SetOperation(c11626309.desop) 
	c:RegisterEffect(e2) 
	--buff
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4:SetRange(LOCATION_DECK)
	e4:SetCountLimit(1)
	e4:SetCondition(c11626309.hxbtecon)
	e4:SetOperation(c11626309.hxbteop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetRange(LOCATION_DECK)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetValue(cm.damval)
	c:RegisterEffect(e5)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11626309,2))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK) 
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c11626309.indtg)
	e3:SetOperation(c11626309.indop)
	c:RegisterEffect(e3)
	if not c11626309.global_check then
		c11626309.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c11626309.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
	Duel.AddCustomActivityCounter(11626309,ACTIVITY_SPSUMMON,c11626309.counterfilter) 
end 
function c11626309.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	if rc:IsType(TYPE_MONSTER) and not rc:IsRace(RACE_INSECT) then 
		Duel.RegisterFlagEffect(rp,11626309,RESET_PHASE+PHASE_END,0,1) 
	end 
end
function c11626309.counterfilter(c)
	return c:IsRace(RACE_INSECT)
end
--01
function c11626309.htdcon(e,tp,eg,ep,ev,re,r,rp) 
	local p=e:GetHandler():GetOwner()
	return  tp==p
end
function c11626309.htdcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return  Duel.GetCustomActivityCount(11626309,tp,ACTIVITY_SPSUMMON)==0 end  
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c11626309.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end 
function c11626309.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_INSECT) 
end

function c11626309.htdfil(c) 
	return c:IsAbleToDeck() and c:IsSetCard(0x3220) and c:IsType(TYPE_MONSTER) 
end 
function c11626309.htdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(c11626309.htgfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND)
end 
function c11626309.htgfil(c) 
	return c:IsSetCard(0x3220) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() 
end 
function c11626309.htdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if (not c:IsRelateToEffect(e)) or (not c:IsLocation(LOCATION_HAND)) then return end  
	Duel.SendtoDeck(c,1-tp,1,REASON_EFFECT)  
	if not c:IsLocation(LOCATION_DECK) then return end 
	Duel.ShuffleDeck(1-tp) 
	c:ReverseInDeck()   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local dg=Duel.SelectMatchingCard(tp,c11626309.htgfil,tp,LOCATION_DECK,0,1,1,nil) 
	Duel.SendtoGrave(dg,REASON_EFFECT)
end 
function c11626309.hxbtecon(e,tp,eg,ep,ev,re,r,rp) 
	local x=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0) 
	return Duel.IsPlayerCanDraw(tp,x) and e:GetHandler():IsFaceup() 
end  
function c11626309.pbfil(c) 
	return not c:IsPublic() and c:IsAbleToDeck() and not c:IsSetCard(0x3220)
end 
function c11626309.hxbteop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0) 
	if Duel.IsPlayerCanDraw(tp,x) then 
		Duel.Hint(HINT_CARD,0,11626309) 
		if Duel.Draw(tp,x,REASON_EFFECT)>0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>5 then  
			local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
			local sg=Duel.GetMatchingGroup(cm.pbfil,tp,LOCATION_HAND,0,nil):RandomSelect(tp,g:GetCount()-5) 
			Duel.ConfirmCards(1-tp,sg)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) 
		end 
	end 
end 
function c11626309.damval(e,re,val,r,rp)
	if r&REASON_EFFECT~=0 and re and e:GetHandler():IsFaceup() then
		local rc=re:GetHandler()
		if not rc:IsSetCard(0x3220) then
			return 100
			end
	end
	return val
end
--02
function c11626309.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) and e:GetHandler():IsPreviousPosition(POS_FACEUP) 
end 
function c11626309.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11626309.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then
		Duel.Draw(tp,1,REASON_EFFECT)
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(c,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
--03
--st
function cm.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(1-tp,ct) end 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct)
end
function cm.pbfil(c) 
	return c:IsAbleToDeck() and not c:IsSetCard(0x3220) 
end 
function cm.indop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct==0 then return end
	if Duel.Draw(1-tp,ct,REASON_EFFECT)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>5 then
		ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(1-tp,cm.pbfil,1-tp,LOCATION_HAND,0,ct-5,ct-5,nil)
		Duel.ConfirmCards(tp,sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) 
	end   
end 

