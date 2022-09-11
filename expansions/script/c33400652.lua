--天使-封解主-解放-戟形态
local m=33400652
local cm=_G["c"..m]
function cm.initial_effect(c)
	 c:SetUniqueOnField(1,0,m)
 --Activate
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_ACTIVATE)
	e10:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e10)
 --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
 --change code
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,m+10000)
	e4:SetTarget(cm.changetg)
	e4:SetOperation(cm.changeop) 
	c:RegisterEffect(e4)
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
function cm.stfilter(c)
	return c:IsSetCard(0x341)  and c:IsFaceup()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)   
local c=e:GetHandler()  
	if not  (Duel.IsExistingMatchingCard(cm.stfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_REMOVED,0,6,nil)) then return end
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	 local tdc=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,6,6,nil)
	 Duel.SendtoDeck(tdc,tp,2,REASON_EFFECT)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	 local tg=Duel.SelectMatchingCard(tp,cm.stfilter,tp,LOCATION_MZONE,0,1,1,nil)
	 local tc=tg:GetFirst()
		  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		  local op1=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,5))+1	
		  if op1==1 then					
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
			 --actlimit
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e3:SetCode(EFFECT_CANNOT_ACTIVATE)
				e3:SetRange(LOCATION_MZONE)
				e3:SetTargetRange(0,1)
				e3:SetValue(1)
				e3:SetCondition(cm.actcon)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
		  end
		  if op1==2  then   
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
		  end  
		  if op1==3  then	
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(cm.efilter)
			e1:SetOwnerPlayer(tp)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DIRECT_ATTACK)
			e2:SetCondition(cm.dircon)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		  end   
end
function cm.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() 
end
function cm.dircon(e)
	return e:GetHandler():GetControler()==e:GetOwnerPlayer()
end

function cm.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return m-1 and m==c:GetOriginalCode() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	c:SetEntityCode(m-1,true)
	c:ReplaceEffect(m-1,0,0)
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