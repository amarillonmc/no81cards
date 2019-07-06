--感受！妖精的编年史！
local m=33700779
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	 
end
cm.card_code_list={33700760}
function cm.ctfilter(c)
	return c:IsSetCard(0x344a) and c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS 
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(33700771)
end
function cm.thfilter(c)
	return c:IsSetCard(0x344a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.rmfilter(c)
	return c:IsSetCard(0x344a) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(cm.ctfilter,tp,LOCATION_SZONE,0,nil)
	if chk==0 then 
	   if ct<=3 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,ct+1,nil) 
	   else return
		  Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_GRAVE,0,1,nil) 
	   end
	end
	if ct<=3 then
	   e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct+1,tp,LOCATION_GRAVE+LOCATION_DECK)
	else
	   e:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER+CATEGORY_DRAW)
	   Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	end
	if Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then
	   e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	else
	   e:SetProperty(0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.ctfilter,tp,LOCATION_SZONE,0,nil)
	if ct<=3 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	   if tg:GetCount()>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
		  Duel.ConfirmCards(1-tp,tg)
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  local tg2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,ct,ct,nil)
		  if tg2:GetCount()>0 then
			 Duel.SendtoHand(tg2,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,tg2)
		  end
	   end
	elseif ct==4 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	   local rg=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,1,5,nil)
	   if rg:GetCount()<=0 then return end
	   Duel.HintSelection(rg)
	   local ct=Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	   if ct<=0 then return end
	   local og=Duel.GetOperatedGroup()
	   local rec=og:Filter(Card.IsLevelAbove,nil,1):GetSum(Card.GetLevel)*300
	   if Duel.Recover(tp,rec,REASON_EFFECT)~=0 and ct==5 then
		  Duel.BreakEffect()
		  Duel.Draw(tp,3,REASON_EFFECT)
	   end
	end
end