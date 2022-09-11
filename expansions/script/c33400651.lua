--天使-封解主
local m=33400651
local cm=_G["c"..m]
function cm.initial_effect(c)
	 c:SetUniqueOnField(1,0,m)
  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
 --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,5))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
 --change code
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,4))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,m+10000)
	e4:SetCondition(cm.changecon)
	e4:SetTarget(cm.changetg)
	e4:SetOperation(cm.changeop) 
	c:RegisterEffect(e4)
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
function cm.activate(e,tp,eg,ep,ev,re,r,rp)   
local c=e:GetHandler()  
	local op={}
	local i=1
	op[i]=1 
	i=i+1
	if  Duel.IsExistingMatchingCard(aux.disfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) then 
	op[i]=2
	i=i+1
	end
	if  Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) then 
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
			  Duel.RegisterFlagEffect(tp,m+60000,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)  
		  end
		  if op[op1]==2  then 
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			 local disg=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
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
		  end
		  if op[op1]==3  then			
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
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

function cm.filter4(c)
	return c:IsFaceup() and c:IsSetCard(0x9342) and c:IsType(TYPE_XYZ)
end
function cm.changecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter4,tp,LOCATION_MZONE,0,1,nil)
end
function cm.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return m+1 and m==c:GetOriginalCode() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	c:SetEntityCode(m+1,true)
	c:ReplaceEffect(m+1,0,0)
end