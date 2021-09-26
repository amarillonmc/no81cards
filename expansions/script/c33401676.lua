--狂狂帝 「天蝎之弹」
local m=33401676
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

end
function cm.refilter(c)
	return ((c:IsType(TYPE_EFFECT) and c:IsDisabled()) or c:IsType(TYPE_NORMAL) or c:IsType(TYPE_TOKEN)) and c:IsReleasable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34f,2,REASON_COST) or  Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_MZONE,0,1,nil)  end
	local b1=Duel.IsCanRemoveCounter(tp,1,0,0x34f,2,REASON_COST)
	local b2=Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_MZONE,0,1,nil) 
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
	  local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_MZONE,0,1,1,nil)
	  Duel.Release(g,REASON_COST)
	  e:SetLabel(1)
	else
	  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	  Duel.RemoveCounter(tp,1,0,0x34f,2,REASON_COST)
	end   
end
function cm.filter(c,tp)
	return c:IsFaceup() and  (c:IsType(TYPE_EFFECT) and c:IsDisabled()) or c:IsType(TYPE_NORMAL) or c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or  c:IsControlerCanBeChanged())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
   end
	local sc1=1
	if e:GetLabel()==1 then sc1=2 end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,sc1,nil,tp)
end
function cm.onfilter1(c)
	return  c:GetFlagEffect(m+1)>0
end
function cm.onfilter2(c)
  return  c:GetFlagEffect(m+2)>0
end
function cm.onfilter3(c)
  return  c:GetFlagEffect(m+3)>0
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
		Duel.HintSelection(g)
		local sc=g:GetFirst()
			while sc do  
				 if sc:GetControler()~=tp then  Duel.GetControl(sc,tp)end
				 if not sc:IsLocation(LOCATION_MZONE) then return end
				 local c=e:GetHandler() 
				 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
				 local ss=Duel.SelectOption(tp,aux.Stringid(m,6),aux.Stringid(m,7),aux.Stringid(m,8))
				 if ss==0 then
					 --remove
					local e1=Effect.CreateEffect(sc)
					e1:SetDescription(aux.Stringid(m,3))
					e1:SetCategory(CATEGORY_REMOVE)
					e1:SetType(EFFECT_TYPE_IGNITION)
					e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetRange(LOCATION_MZONE)  
					e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
					e1:SetTarget(cm.rmtg)
					e1:SetOperation(cm.rmop)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					sc:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetDescription(aux.Stringid(m,9))
					e2:SetType(EFFECT_TYPE_QUICK_O)
					e2:SetCode(EVENT_FREE_CHAIN)
					e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
					e2:SetCost(cm.rmcost)
					sc:RegisterEffect(e2)  
			 sc:RegisterFlagEffect(m+1,RESET_EVENT+0x1fe0000,0,nil,0,0)
				 sc:SetUniqueOnField(1,0,cm.onfilter1,LOCATION_MZONE)
				 elseif ss==1 then 
					--
					local e1=Effect.CreateEffect(sc)
					e1:SetDescription(aux.Stringid(m,4))
					e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
					e1:SetType(EFFECT_TYPE_IGNITION)
					e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetRange(LOCATION_MZONE)
					e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
					e1:SetTarget(cm.atktg)
					e1:SetOperation(cm.atkop)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					sc:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetDescription(aux.Stringid(m,10))
					e2:SetType(EFFECT_TYPE_QUICK_O)
					e2:SetCode(EVENT_FREE_CHAIN)
					e2:SetCost(cm.rmcost)
					sc:RegisterEffect(e2)	 
  sc:RegisterFlagEffect(m+2,RESET_EVENT+0x1fe0000,0,nil,0,0)
				   sc:SetUniqueOnField(1,0,cm.onfilter2,LOCATION_MZONE) 
				 else
					 --
					local e1=Effect.CreateEffect(sc)
					e1:SetDescription(aux.Stringid(m,5))
					e1:SetCategory(CATEGORY_DISABLE)
					e1:SetType(EFFECT_TYPE_IGNITION)
					e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetRange(LOCATION_MZONE)
					e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
					e1:SetTarget(cm.distg)
					e1:SetOperation(cm.disop)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					sc:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetDescription(aux.Stringid(m,11))
					e2:SetType(EFFECT_TYPE_QUICK_O)
					e2:SetCode(EVENT_FREE_CHAIN)
					e2:SetCost(cm.rmcost)
					sc:RegisterEffect(e2)
  sc:RegisterFlagEffect(m+3,RESET_EVENT+0x1fe0000,0,nil,0,0)
				   sc:SetUniqueOnField(1,0,cm.onfilter3,LOCATION_MZONE)
				 end
					if not sc:IsType(TYPE_EFFECT) then
					local e0=Effect.CreateEffect(c)
					e0:SetType(EFFECT_TYPE_SINGLE)
					e0:SetCode(EFFECT_ADD_TYPE)
					e0:SetValue(TYPE_EFFECT)
					e0:SetReset(RESET_EVENT+RESETS_STANDARD)
					sc:RegisterEffect(e0,true)
					end
				 sc=g:GetNext()
			end
		end
end
function cm.refilter(c)
	return ((c:IsType(TYPE_EFFECT) and c:IsDisabled()) or c:IsType(TYPE_NORMAL) or c:IsType(TYPE_TOKEN)) and c:IsReleasable()
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return  Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_MZONE,0,1,nil)  end
	local b2=Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_MZONE,0,1,nil) 
	if b2 then
	  local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_MZONE,0,1,1,nil)
	  Duel.Release(g,REASON_COST)
	end   
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.nzatk(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.nzatk,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e)  then
		local atk=tc:GetAttack()
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetValue(atk)
			c:RegisterEffect(e2)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PIERCE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e2)
		end
	end
end

function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end