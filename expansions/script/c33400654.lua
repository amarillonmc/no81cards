--救赎的决意
local m=33400654
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,m)
	e0:SetOperation(cm.operation)
	c:RegisterEffect(e0) 
 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,m+10000)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.spcon2)
	c:RegisterEffect(e2)

end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local s1=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	if s1==0 then 
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,0))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCondition(cm.xdcon)
		e1:SetOperation(cm.xdop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		--sp_summon effect
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetCondition(cm.xdregcon)
		e2:SetOperation(cm.xdregop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetCondition(cm.xdcon2)
		e3:SetOperation(cm.xdop2)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end 
	if s1==1 then 
Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCondition(cm.mucon1)
		e1:SetOperation(cm.muop1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		--sp_summon effect
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetCondition(cm.muregcon)
		e2:SetOperation(cm.muregop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetCondition(cm.mucon2)
		e3:SetOperation(cm.muop2)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function cm.filter(c,sp)
	return bit.band(c:GetSummonLocation(),LOCATION_GRAVE+LOCATION_REMOVED)~=0 and c:IsLocation(LOCATION_MZONE)
	and c:GetControler()==sp
end
function cm.xdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xc342) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,m+c:GetCode()+40000)==0 
end
function cm.xdop(e,tp,eg,ep,ev,re,r,rp)
   if  Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	  if  Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		 local tg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		 Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		 local tc=tg:GetFirst()
		  Duel.RegisterFlagEffect(tp,tc:GetCode()+40000,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)   
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		   local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
		   Duel.Destroy(dg,REASON_EFFECT)   
		end   
   end 
end
function cm.xdregcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.xdregop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.xdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.xdop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,m)
	Duel.ResetFlagEffect(tp,m)
   if  Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	  if  Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		 local tg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		 Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		 local tc=tg:GetFirst()
		  Duel.RegisterFlagEffect(tp,tc:GetCode()+40000,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)   
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		   local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
		   Duel.Destroy(dg,REASON_EFFECT)   
		end   
   end 
end

function cm.filter2(c,sp)
	return bit.band(c:GetSummonLocation(),LOCATION_HAND+LOCATION_DECK)~=0 and c:IsLocation(LOCATION_MZONE)
	and c:GetControler()==sp
end
function cm.mucon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter2,1,nil,1-tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.spfilter2(c,e,tp)
	return c:IsSetCard(0x9342) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,m+c:GetCode()+40000)==0 
end
function cm.muop1(e,tp,eg,ep,ev,re,r,rp)
   if  Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	  if  Duel.SelectYesNo(tp,aux.Stringid(m,3)) then 
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		 local tg=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp)
		 Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		 local tc=tg:GetFirst()
		  Duel.RegisterFlagEffect(tp,tc:GetCode()+40000,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)   
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		   local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
		   Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)  
		end   
   end 
end
function cm.muregcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter2,1,nil,1-tp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.muregop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.mucon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.muop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,m)
	Duel.ResetFlagEffect(tp,m)
   if  Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	  if  Duel.SelectYesNo(tp,aux.Stringid(m,3)) then 
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		 local tg=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp)
		 Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		 local tc=tg:GetFirst()
		  Duel.RegisterFlagEffect(tp,tc:GetCode()+40000,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)   
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		   local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
		   Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)  
		end   
   end 
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)==0 and e:GetHandler():GetFlagEffect(m)==0
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)>0 and e:GetHandler():GetFlagEffect(m)==0
end
function cm.refilter(c)
	return c:IsAbleToDeck()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
  if chkc then return chkc:IsLocation(LOCATION_REMOVED)  and cm.refilter(chkc) end 
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,3,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp) 
if not (Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,3,nil) and Duel.IsPlayerCanDraw(tp,1))  then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,3,3,nil)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0  then 
		Duel.Draw(tp,1,REASON_EFFECT)
	end 
end