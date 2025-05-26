--隐匿虫 寄生蛹
local m=11626302
local cm=_G["c"..m]
function c11626302.initial_effect(c)
	--to deck 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,11626302) 
	e1:SetCondition(c11626302.htdcon) 
	e1:SetCost(c11626302.htdcost)
	e1:SetTarget(c11626302.htdtg) 
	e1:SetOperation(c11626302.htdop) 
	c:RegisterEffect(e1) 
	--buff
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetRange(LOCATION_DECK)
	e4:SetCondition(cm.hxthecon)
	e4:SetOperation(cm.hxtheop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetRange(LOCATION_DECK)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetValue(cm.damval)
	c:RegisterEffect(e5)
	--Destroy
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_TO_HAND) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCondition(c11626302.descon)  
	e2:SetTarget(c11626302.destg) 
	e2:SetOperation(c11626302.desop) 
	c:RegisterEffect(e2) 
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11626302,2))
	e3:SetCategory(CATEGORY_TODECK) 
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c11626302.indcon)
	e3:SetOperation(c11626302.indop)
	c:RegisterEffect(e3)
	if not c11626302.global_check then
		c11626302.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c11626302.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
	Duel.AddCustomActivityCounter(11626302,ACTIVITY_SPSUMMON,c11626302.counterfilter) 
end 
function c11626302.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	if rc:IsType(TYPE_MONSTER) and not rc:IsRace(RACE_INSECT) then 
		Duel.RegisterFlagEffect(rp,11626302,RESET_PHASE+PHASE_END,0,1) 
	end 
end
function c11626302.counterfilter(c)
	return c:IsRace(RACE_INSECT)
end
--01
function c11626302.htdcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetOwner()
	return tp==p 
end 
function c11626302.htdcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetCustomActivityCount(11626302,tp,ACTIVITY_SPSUMMON)==0 end  
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c11626302.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp) 
end 
function c11626302.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_INSECT) 
end

function c11626302.htdfil(c) 
	return c:IsAbleToDeck() and c:IsSetCard(0x3220) and c:IsType(TYPE_MONSTER) 
end 
function c11626302.htdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end  
function c11626302.htdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if (not c:IsRelateToEffect(e)) or (not c:IsLocation(LOCATION_HAND)) then return end  
	Duel.SendtoDeck(c,1-tp,1,REASON_EFFECT)  
	if not c:IsLocation(LOCATION_DECK) then return end 
	Duel.ShuffleDeck(1-tp) 
	c:ReverseInDeck()   
	if Duel.IsPlayerCanDraw(tp,1) then 
		Duel.BreakEffect() 
		Duel.Draw(tp,1,REASON_EFFECT)
	end 
end 
function c11626302.hxthckfil(c,tp) 
	return c:IsControler(tp) and not c:IsReason(REASON_DRAW) 
end 
function c11626302.hxthecon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c11626302.hxthckfil,1,nil,tp) and e:GetHandler():IsFaceup()
end 
function c11626302.pbfil(c) 
	return not c:IsPublic() and c:IsAbleToDeck() and not c:IsSetCard(0x3220) 
end 
function c11626302.hxtheop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if eg:IsExists(Card.IsControler,1,nil,tp) then 
		Duel.Hint(HINT_CARD,0,11626302) 
		Duel.Draw(tp,1,REASON_EFFECT) 
	end 
end 
function c11626302.damval(e,re,val,r,rp)
	if r&REASON_EFFECT~=0 and re and e:GetHandler():IsFaceup() then
		local rc=re:GetHandler()
		if not rc:IsSetCard(0x3220) then
			return 100
			end
	end
	return val
end
--02
function c11626302.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) and e:GetHandler():IsPreviousPosition(POS_FACEUP) 
end 
function c11626302.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11626302.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then
		Duel.Draw(tp,1,REASON_EFFECT)
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(c,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
--03
--tk
function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsAbleToEnterBP() -- and re:GetHandler():IsType(TYPE_MONSTER)
end
function cm.indop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START) 
	e1:SetCountLimit(1)
	e1:SetCondition(cm.xtdcon) 
	e1:SetOperation(cm.xtdop) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function cm.xtdcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) 
end 
function cm.xtdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil) 
		Duel.SendtoDeck(sg,nil,1,REASON_EFFECT) 
	end
end 