--浪潮庇护的海晶少女卵
local m=11634003
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+m)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
--Effect 1
function cm.th(c)
	local b1=c:IsSetCard(0x12b)
	local b2=c:IsType(TYPE_MONSTER)
	local b3=c:IsAbleToHand()
	return b1 and b2 and b3
end
function cm.ef(c)
	local b1=c:IsFaceup()
	local b2=c:GetLink()>=3
	local b3=c:IsSetCard(0x12b)
	return b1 and b2 and b3
end
function cm.tf(c)
	local b1=c:IsCode(11634004)
	local b2=c:IsAbleToHand()
	return b1 and b2
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.th,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.th,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return end	
	local tc=g:GetFirst()
	local exg=Duel.GetMatchingGroup(cm.ef,tp,LOCATION_MZONE,0,nil)
	local thg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tf),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 
		and tc:IsLocation(LOCATION_HAND) and #exg>0 and #thg>0
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		Duel.ConfirmCards(1-tp,tc) 
		thg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tf),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		local ag
		if #thg==1 then 
			ag=thg:GetFirst() 
		else 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			ag=thg:Select(tp,1,1,nil)
		end
		Duel.BreakEffect()
		Duel.SendtoHand(ag,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,ag) 
	end
end  
--Effect 2
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		aux.DrawReplaceCount=0
		aux.DrawReplaceMax=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	aux.DrawReplaceCount=aux.DrawReplaceCount+1
	if aux.DrawReplaceCount<=aux.DrawReplaceMax and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end


