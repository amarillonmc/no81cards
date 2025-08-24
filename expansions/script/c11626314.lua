--隐匿虫 木卫二画皮
local m=11626314
local cm=_G["c"..m]
function c11626314.initial_effect(c)
	--to deck 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,m) 
	e1:SetCondition(cm.htdcon) 
	e1:SetCost(cm.htdcost)
	e1:SetTarget(cm.htdtg) 
	e1:SetOperation(cm.htdop) 
	c:RegisterEffect(e1) 
	--buff
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_DECK)
	e4:SetCondition(cm.decon)
	e4:SetTarget(cm.detg)
	e4:SetOperation(cm.deop)
	c:RegisterEffect(e4)
	--Destroy
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_TO_HAND) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCost(cm.discost)
	e2:SetCondition(cm.descon)  
	e2:SetTarget(cm.destg) 
	e2:SetOperation(cm.desop) 
	c:RegisterEffect(e2) 
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end 
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	if rc:IsType(TYPE_MONSTER) and not rc:IsRace(RACE_INSECT) then 
		Duel.RegisterFlagEffect(rp,m,RESET_PHASE+PHASE_END,0,1) 
	end 
end
function cm.counterfilter(c)
	return c:IsRace(RACE_INSECT)
end
--01
function cm.htdcon(e,tp,eg,ep,ev,re,r,rp) 
	local p=e:GetHandler():GetOwner()
	return  tp==p  
end 
function cm.htdcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return  Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end  
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp) 
end 
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_INSECT) 
end


function cm.htdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and  Duel.IsExistingMatchingCard(cm.hsrfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND)
end 
function cm.hsrfil(c) 
	return c:IsSetCard(0x3220) and c:IsAbleToHand() 
end 
function cm.htdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	if (not c:IsRelateToEffect(e)) or (not c:IsLocation(LOCATION_HAND)) then return end  
	Duel.SendtoDeck(c,1-tp,1,REASON_EFFECT)  
	if not c:IsLocation(LOCATION_DECK) then return end 
	Duel.ShuffleDeck(1-tp) 
	c:ReverseInDeck()
	--Debug.Message('如果觉得手牌太多了，就呼唤卡组中的脑寄生虫吧')
	--Debug.Message('点击卡组发动卡组中脑寄生虫的效果回收手牌')
	local dg=Duel.SelectMatchingCard(tp,cm.hsrfil,tp,LOCATION_DECK,0,1,1,nil) 
	Duel.SendtoHand(dg,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,dg)  
end 
function cm.decon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_DECK) and e:GetHandler():IsPosition(POS_FACEUP) 
end 
function cm.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function cm.htdfil(c) 
	return c:IsAbleToDeck() and not c:IsSetCard(0x3220)
end 
function cm.deop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.htdfil,tp,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if g:GetCount()>0 then
		Duel.Damage(tp,g:GetCount()*200,REASON_EFFECT)
	end
	Duel.ShuffleDeck(tp)
end
--02
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_DECK) 
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and mg:GetCount()>0 end
	--Duel.ConfirmCards(tp,e:GetHandler())
	Duel.SendtoDeck(c,tp,1,REASON_COST) 
	if not c:IsLocation(LOCATION_DECK) then return end 
	Duel.ShuffleDeck(tp) 
	c:ReverseInDeck()
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) and e:GetHandler():IsPreviousPosition(POS_FACEUP) 
end 
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp) 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
