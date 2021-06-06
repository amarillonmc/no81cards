--天使-封解主-解放-戟形态
local m=33400652
local cm=_G["c"..m]
function cm.initial_effect(c)
	 c:SetUniqueOnField(1,0,m)
cm.dfc_front_side=33400651
cm.dfc_back_side=33400652
 --Activate
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_ACTIVATE)
	e10:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e10)
 --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
 --back
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e9:SetCondition(cm.backon)
	e9:SetOperation(cm.backop)
	c:RegisterEffect(e9)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  not c:IsStatus(STATUS_CHAINING) and (Duel.GetFlagEffect(tp,m+80001)==0 or Duel.GetFlagEffect(tp,m+80002)==0 or  Duel.GetFlagEffect(tp,m+80003)==0 )
end
function cm.cfilter(c)
	return  c:IsSetCard(0x9342) and c:IsAbleToRemoveAsCost() 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end
function cm.tdfilter(c)
	return  c:IsSetCard(0x9342) and c:IsAbleToDeck() 
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x341)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.stfilter(c)
	return c:IsSetCard(0x341)  and c:IsType(TYPE_XYZ)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)   
local c=e:GetHandler()  
	local op={}
	local i=1
	if Duel.GetFlagEffect(tp,m+80001)==0 and Duel.IsExistingMatchingCard(cm.stfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_REMOVED,0,4,nil) then 
	op[i]=1
	i=i+1
	end
	if Duel.GetFlagEffect(tp,m+80002)==0 and Duel.IsExistingMatchingCard(cm.stfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_REMOVED,0,4,nil) then 
	op[i]=2
	i=i+1
	end
	if Duel.GetFlagEffect(tp,m+80003)==0  and 33400651 and c:GetOriginalCode()==33400652 then 
	op[i]=3
	i=i+1
	end   

		 if i==2 then 
		  op1=1
		 end
		 if i==3 then 
		 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		  op1=Duel.SelectOption(tp,aux.Stringid(m,op[1]),aux.Stringid(m,op[2]))+1
		 end
		 if i==4 then 
		 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		  op1=Duel.SelectOption(tp,aux.Stringid(m,op[1]),aux.Stringid(m,op[2]),aux.Stringid(m,op[3]))+1
		 end		  
		  if op[op1]==1 then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			 local tdc=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,4,4,nil)
			 Duel.SendtoDeck(tdc,tp,2,REASON_EFFECT)
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			 local tg=Duel.SelectMatchingCard(tp,cm.stfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			 local tc=tg:GetFirst()
			  local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(tc:GetAttack()*2)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			 local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
				e2:SetValue(tc:GetDefense()*2)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
Duel.RegisterFlagEffect(tp,m+80001,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)   
		  end
		  if op[op1]==2  then   
 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			 local tdc=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,4,4,nil)
			 Duel.SendtoDeck(tdc,tp,2,REASON_EFFECT)
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			 local tg=Duel.SelectMatchingCard(tp,cm.stfilter,tp,LOCATION_MZONE,0,1,1,nil)
			 local tc=tg:GetFirst()
			   local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_ATTACK_ALL)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				 --pierce
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_PIERCE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
Duel.RegisterFlagEffect(tp,m+80002,RESET_EVENT+RESET_PHASE+PHASE_END,0,0) 
		  end  
		  if op[op1]==3  then	 
				c:SetEntityCode(33400651,true)
				c:ReplaceEffect(33400651,0,0)
Duel.RegisterFlagEffect(tp,m+80003,RESET_EVENT+RESET_PHASE+PHASE_END,0,0) 
		  end   
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

function cm.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return 33400651 and c:GetOriginalCode()==33400652
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(33400651)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(33400651,0,0)
end