--占卜之夜
function c10173006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,10173006+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10173006.cost)
	e1:SetTarget(c10173006.target)
	e1:SetOperation(c10173006.activate)
	c:RegisterEffect(e1)	   
end
function c10173006.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c10173006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10173006.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10173006.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10173006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsOnField() and chkc~=e:GetHandler() and (chkc:IsControler(tp) or aux.disfilter1(chkc)) end
	if chk==0 then return true end
	local ct1,ct2,op=Duel.GetTargetCount(Card.IsFaceup,tp,LOCATION_ONFIELD,0,e:GetHandler()),Duel.GetTargetCount(aux.disfilter1,tp,0,LOCATION_ONFIELD,e:GetHandler()),0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if ct1>0 and ct2>0 then
	  op=Duel.SelectOption(tp,aux.Stringid(10173006,0),aux.Stringid(10173006,1),aux.Stringid(10173006,2))
	elseif ct1<=0 then
	  op=Duel.SelectOption(tp,aux.Stringid(10173006,1),aux.Stringid(10173006,2))+1
	elseif ct2<=0 then
	  op=Duel.SelectOption(tp,aux.Stringid(10173006,0),aux.Stringid(10173006,2))
	else
	  Duel.SelectOption(tp,aux.Stringid(10173006,2))
	  op=2
	end
	  e:SetLabel(op)
	  local g=nil
	  if op==0 then
		 e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		 g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	  elseif op==1 then
		 e:SetCategory(CATEGORY_DISABLE)
		 e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		 g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
		 Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	  else
		 e:SetProperty(0)
	  end
end
function c10173006.activate(e,tp,eg,ep,ev,re,r,rp)
   local op,c=e:GetLabel(),e:GetHandler()
   local tc=Duel.GetFirstTarget()
   if op==0 then
	 if tc and tc:IsRelateToEffect(e) then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e0:SetRange(LOCATION_MZONE)
		e0:SetCode(EFFECT_IMMUNE_EFFECT)
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e0:SetValue(c10173006.efilter)
		tc:RegisterEffect(e0)
	  end
   elseif op==1 then
	 if tc and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		else
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		end
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
   else 
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
		e5:SetCountLimit(1)
		e5:SetCondition(c10173006.damcon)
		e5:SetOperation(c10173006.damop)
		e5:SetLabel(Duel.GetTurnCount())
		e5:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e5,tp)
   end
end
function c10173006.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c10173006.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10173006)
	Duel.Damage(1-tp,1200,REASON_EFFECT)
end
function c10173006.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end