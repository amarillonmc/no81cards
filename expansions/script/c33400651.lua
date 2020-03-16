--天使-封解主
local m=33400651
local cm=_G["c"..m]
function cm.initial_effect(c)
	 c:SetUniqueOnField(1,0,m)
cm.dfc_front_side=m
cm.dfc_back_side=m+1
  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
 --
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  not c:IsStatus(STATUS_CHAINING) and (Duel.GetFlagEffect(tp,m+70001)==0 or Duel.GetFlagEffect(tp,m+70002)==0 or  Duel.GetFlagEffect(tp,m+70003)==0 or Duel.GetFlagEffect(tp,m+70004)==0 or Duel.GetFlagEffect(tp,m+70005)==0 ) and Duel.GetFlagEffect(tp,m+70006)<3
end
function cm.cfilter(c)
	return  c:IsSetCard(0x9342) and c:IsAbleToRemoveAsCost() 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()   
	Duel.Remove(tc,POS_FACEUP,REASON_COST)   
end
function cm.tdfilter(c)
	return  c:IsSetCard(0x9342) and c:IsAbleToDeck() 
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x341)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)   
local c=e:GetHandler()  
	local op={}
	local i=1
	if Duel.GetFlagEffect(tp,m+70001)==0  then 
	op[i]=1 
	i=i+1
	end
	if Duel.GetFlagEffect(tp,m+70002)==0 and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_REMOVED,0,2,nil) and Duel.IsExistingMatchingCard(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then 
	op[i]=2
	i=i+1
	end
	if Duel.GetFlagEffect(tp,m+70003)==0 and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_REMOVED,0,4,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then 
	op[i]=3
	i=i+1
	end
	if Duel.GetFlagEffect(tp,m+70004)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) then 
	op[i]=4
	i=i+1
	end 
	if Duel.GetFlagEffect(tp,m+70005)==0  and c.dfc_back_side and c.dfc_front_side==c:GetOriginalCode() then 
	op[i]=5
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
		 if i==5 then 
		 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		   op1=Duel.SelectOption(tp,aux.Stringid(m,op[1]),aux.Stringid(m,op[2]),aux.Stringid(m,op[3]),aux.Stringid(m,op[4]))+1
		 end
		 if i==6 then 
		 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		   op1=Duel.SelectOption(tp,aux.Stringid(m,op[1]),aux.Stringid(m,op[2]),aux.Stringid(m,op[3]),aux.Stringid(m,op[4]),aux.Stringid(m,op[5]))+1
		 end
		  if op[op1]==1 then
			  Duel.RegisterFlagEffect(tp,m+60000,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)  
			  Duel.RegisterFlagEffect(tp,m+70001,RESET_EVENT+RESET_PHASE+PHASE_END,0,0) 
			  Duel.RegisterFlagEffect(tp,m+70006,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)   
		  end
		  if op[op1]==2  then 
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			 local tdc=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,2,2,nil)
			 Duel.SendtoDeck(tdc,tp,2,REASON_EFFECT)
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			 local disg=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			 local disc=disg:GetFirst()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				e1:SetTarget(cm.distg)
				e1:SetLabelObject(disc)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_CHAIN_SOLVING)
				e2:SetCondition(cm.discon)
				e2:SetOperation(cm.disop)
				e2:SetLabelObject(disc)
				e2:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e2,tp)
Duel.RegisterFlagEffect(tp,m+70002,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
Duel.RegisterFlagEffect(tp,m+70006,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)	
		  end
		  if op[op1]==3  then 
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			 local tdc=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,4,4,nil)
			 Duel.SendtoDeck(tdc,tp,2,REASON_EFFECT)
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			 local disg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			 local tc=disg:GetFirst()
			  local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(tc:GetBaseAttack()*2)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			 local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
				e2:SetValue(tc:GetBaseDefense()*2)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
Duel.RegisterFlagEffect(tp,m+70003,RESET_EVENT+RESET_PHASE+PHASE_END,0,0) 
Duel.RegisterFlagEffect(tp,m+70006,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)   
		  end
		  if op[op1]==4  then 
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			 local tg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
			 Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
			 local tc=tg:GetFirst()
			 local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
Duel.RegisterFlagEffect(tp,m+70004,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
Duel.RegisterFlagEffect(tp,m+70006,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)	
		  end
		  if op[op1]==5  then 
			  local tcode=c.dfc_back_side
				c:SetEntityCode(tcode,true)
				c:ReplaceEffect(tcode,0,0)
Duel.RegisterFlagEffect(tp,m+70005,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)   
Duel.RegisterFlagEffect(tp,m+70006,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)  
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