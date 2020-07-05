--替身-天堂制造
local m=33333333
local cm=_G["c"..m]
function cm.initial_effect(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DICE+CATEGORY_DAMAGE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_RECOVER+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.toss_dice=true
function cm.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,3)
	local tc=Duel.GetTurnCount()
		  if   Duel.GetTurnPlayer()==tp then tc=tc+5
		  else tc=tc+6
		  end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,tc*800)
	 local g1=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	 local g2=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
   Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)
   Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)
Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local j=0
	local p
	local dc=Duel.TossDice(tp,1)  
	 if dc==1 and  Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,m) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,m)
	local tc=g:GetFirst()
		Duel.SSet(tp,tc)
	end 
	if dc==2  and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	 Duel.Damage(1-tp,1000,REASON_EFFECT)
	end 
	 if dc==3  then  
	   if Duel.IsPlayerCanDraw(tp,3) and  Duel.SelectYesNo(tp,aux.Stringid(m,2)) and Duel.Draw(tp,3,REASON_EFFECT)==3  then
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
			if tg:GetCount()<3  then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local dg=tg:Select(tp,3,3,nil)
			Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)  
		end
	end 
   if dc==4 and  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local c=e:GetHandler()
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(1000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc=sg:GetNext()
		end
	end 
	if dc==5  then
		local tc=Duel.GetTurnCount()
		  if   Duel.GetTurnPlayer()==tp then tc=tc+5
		  else tc=tc+6
		  end
		Duel.Recover(tp,tc*800,REASON_EFFECT)
	end 
	if dc==6  and ((Duel.IsPlayerCanRemove(1-tp) and  Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)) or (Duel.IsPlayerCanRemove(tp) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,nil))) and   Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		local g1=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		local g2=Duel.GetFieldGroup(1-tp,0,LOCATION_ONFIELD)
		if g2:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local sg2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,1-tp,LOCATION_ONFIELD,0,1,1,nil,1-tp,POS_FACEDOWN,REASON_RULE)
			Duel.Remove(sg2,POS_FACEDOWN,REASON_RULE)
		end
		if g1:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local sg1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,1,nil,tp,POS_FACEDOWN,REASON_RULE)
			Duel.Remove(sg1,POS_FACEDOWN,REASON_RULE)
		end
	end 
	if   Duel.GetTurnPlayer()==tp then 
		Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)	 
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
	end 
   if dc>1 then 
	if dc>3 then dc=3 end 
	   if   Duel.GetTurnPlayer()==tp then  
			dc=dc-1   
			Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(1-tp,PHASE_END,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,dc+1)
			Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,dc+1)  
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,dc+1)
			Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,dc+1)
			Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,dc+1)
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,dc+1)  
		else
			Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(1-tp,PHASE_END,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,dc)   
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,dc)
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,dc)
		end 
	end
end
