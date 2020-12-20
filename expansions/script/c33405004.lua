--『星光歌剧』台本-渴望Revue
local m=33405004
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.thcon2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.thtg2)
	e2:SetOperation(cm.thop2)
	c:RegisterEffect(e2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
  Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
  local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)  
end
function cm.cfilter(c,tp)
	return  c:IsReason(REASON_DESTROY) 
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>Duel.GetFlagEffect(tp,m+1) and eg:IsExists(cm.cfilter,1,nil) and  ((re and (re:GetOwner():IsSetCard(0x9da0)) or c:GetReasonCard():IsSetCard(0x9da0) ))
end
function cm.filter(c)
	return c:IsSetCard(0x9da0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE+LOCATION_DECK and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.filter2(c)
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
  if not  Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) then return end 
  if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
		if tc then
			local s1=tc:IsSummonable(true,nil,1)
			local s2=tc:IsMSetable(true,nil,1)
				if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
					Duel.Summon(tp,tc,true,nil,1)
				else
					Duel.MSet(tp,tc,true,nil,1)
				end
		 end
	 end 
	Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
end
function cm.cfilter2(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()==1-tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter2,1,nil,tp)
end
function cm.thfilter(c)
	return c:IsSetCard(0x9da0) and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end 
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
 