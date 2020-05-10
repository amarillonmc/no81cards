--D.A.L 美好的终点
local m=33401321
local cm=_G["c"..m]
function cm.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsSetCard(0x341,0x340)  and (c:IsAbleToHand() or c:IsSSetable() or c:IsAbleToGrave() or c:IsAbleToRemove())
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0xc342)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil)   end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)   
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp) 
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
   if g:GetCount()>0 then
		local tc=g:GetFirst()
		local t1=tc:IsAbleToHand()
		local t2=tc:IsSSetable()
		local t3=tc:IsAbleToGrave()
		local t4=tc:IsAbleToRemove() 
   local n=7
   local k=7	 
	if t1 and t2 and t3 and t4 then 
		n=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3),aux.Stringid(m,4))
		k=n
	elseif t1 and t2 and t3  then
		n=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
		k=n
	elseif t1 and t2  and t4  then
		n=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,4))
		if n==2 then k=n+1 
		else k=n
		end
	elseif t1  and  t3 and t4  then
		n=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,3),aux.Stringid(m,4))
		if n>0 then k=n+1 
		else k=n
		end
	 elseif  t2 and  t3 and t4  then
		n=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3),aux.Stringid(m,4))
		k=n+1
	 elseif t1 and t2  then
		n=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
		k=n
	  elseif t1 and t3  then
		n=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,3))
		if n==0 then  k=n
		else k=n+2
		end
	  elseif t1 and t4  then
		n=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,4))
		if n==0 then  k=n
		else k=n+3
		end
	  elseif t2 and t3  then
		n=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
		k=n+1
	  elseif t2 and t4  then
		n=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,4))
		if n==0 then  k=n+1
		else k=n+3
		end
	  elseif t3 and t4  then
		n=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))
		k=n+2
	  elseif t1 then k=0
	  elseif t2 then k=1
	  elseif t3 then k=2
	  elseif t4 then k=3
	  end
	if k==0 then 
	  Duel.SendtoHand(tc,tp,REASON_EFFECT)
	  Duel.ConfirmCards(1-tp,tc) 
	end
	if k==1 then Duel.SSet(tp,tc) end
	if k==2 then Duel.SendtoGrave(tc,REASON_EFFECT) end
	if k==3 then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
	end   
	local ct=Duel.GetFlagEffect(tp,m+10000)   
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCondition(cm.ckcon)
	e1:SetOperation(cm.checkop)
	e1:SetCountLimit(1)
	e1:SetLabel(ct)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,3)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,m+10000,0,0,0)
end
function cm.ckcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local ct=e:GetLabel()
	Duel.RegisterFlagEffect(tp,m+ct,0,0,0)
	local ct1=Duel.GetFlagEffect(tp,m+ct)
	c:SetHint(CHINT_TURN,ct1)
	if ct1==3 then
	  if Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then 
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	 local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	  Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	  local bg=Duel.GetOperatedGroup():Filter(cm.cfilter2,nil):GetCount()
		  if bg>=12 and Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,7)) then 
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g3=Duel.SelectMatchingCard(tp,cm.cfilter3,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK,0,1,1,nil,e,tp)
				if g3:GetCount()>0 then
					Duel.SpecialSummon(g3,0,tp,tp,true,true,POS_FACEUP)
					local tc=g3:GetFirst()
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetCode(EFFECT_CANNOT_ACTIVATE)
					e1:SetTargetRange(0,1)
					e1:SetValue(aux.TRUE)
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
					 local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_FIELD)
					e2:SetCode(EFFECT_DISABLE)
					e2:SetTargetRange(0,LOCATION_ONFIELD)
					e2:SetTarget(cm.disable)
					e2:SetReset(RESET_PHASE+PHASE_END)
					e2:SetLabel(c:GetFieldID())
					Duel.RegisterEffect(e2,tp)
					 local e3=Effect.CreateEffect(e:GetHandler())
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_UPDATE_ATTACK)
					e3:SetValue(bg*500)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
					local e4=Effect.CreateEffect(e:GetHandler())
				   e4:SetType(EFFECT_TYPE_SINGLE)
				   e4:SetCode(EFFECT_UPDATE_DEFENSE)
				   e4:SetValue(bg*500)
				   e4:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e4)
					local e5=Effect.CreateEffect(e:GetHandler())
					e5:SetType(EFFECT_TYPE_SINGLE)
					e5:SetCode(EFFECT_IMMUNE_EFFECT)
					e5:SetValue(cm.efilter1)
					tc:RegisterEffect(e5)
					--cannot release
					local e6=Effect.CreateEffect(e:GetHandler())
					e6:SetType(EFFECT_TYPE_SINGLE)
					e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
					e6:SetRange(LOCATION_MZONE)
					e6:SetCode(EFFECT_UNRELEASABLE_SUM)
					e6:SetValue(1)
					c:RegisterEffect(e6)
					 local e7=e6:Clone()
					e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
					c:RegisterEffect(e7)
				end
		  end
	  end
	end
end
function cm.cfilter(c)
	return c:IsAbleToDeck()
end
function cm.cfilter2(c)
	return c:IsSetCard(0x340,0x341)
end
function cm.cfilter3(c,e,tp)
	return c:IsSetCard(0x5341) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.disable(e,c)
	return c:GetFieldID()~=e:GetLabel() and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end
function cm.efilter1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end