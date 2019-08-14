--空想的境界限
function c10122007.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10122007,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetTarget(c10122007.target)
	e1:SetOperation(c10122007.activate)
	c:RegisterEffect(e1)
end
function c10122007.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsActiveType(TYPE_SPELL) and te:GetHandler():IsType(TYPE_FIELD)
end
function c10122007.acfilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp) and c:IsSetCard(0xc333)
end
function c10122007.rfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToGrave()
end
function c10122007.tkfilter(c)
	return c:IsCode(10122007) and c:IsFaceup()
end
function c10122007.effilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c10122007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(c10122007.rfilter,tp,LOCATION_HAND+LOCATION_FZONE,0,1,nil) and Duel.IsExistingMatchingCard(c10122007.acfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetCurrentPhase()~=PHASE_DAMAGE then sel=sel+1 end
		if Duel.IsExistingTarget(c10122007.tkfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c10122007.effilter,tp,0,LOCATION_MZONE,1,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		sel=Duel.SelectOption(tp,aux.Stringid(10122007,0),aux.Stringid(10122007,1))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(10122007,0))
	else
		Duel.SelectOption(tp,aux.Stringid(10122007,1))
	end
	e:SetLabel(sel)
	if sel==1 then
	   e:SetCategory(CATEGORY_TOGRAVE)
	   e:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	   Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_FZONE+LOCATION_HAND)
	else
	   e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	   e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	   local g=Duel.SelectTarget(tp,c10122007.tkfilter,tp,LOCATION_MZONE,0,1,1,nil) 
	end
end
function c10122007.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local emg=Duel.GetMatchingGroup(c10122007.effilter,tp,0,LOCATION_MZONE,nil)
	if op==1 and Duel.IsExistingMatchingCard(c10122007.rfilter,tp,LOCATION_HAND+LOCATION_FZONE,0,1,nil) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE) 
	   local g=Duel.SelectMatchingCard(tp,c10122007.rfilter,tp,LOCATION_HAND+LOCATION_FZONE,0,1,1,nil)
	   if Duel.SendtoGrave(g,REASON_EFFECT)==0 or not g:GetFirst():IsLocation(LOCATION_GRAVE) then return end
	   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10122007,5))
	   local tc=Duel.SelectMatchingCard(tp,c10122007.acfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	   if tc then
		  local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		  if fc then
			 Duel.SendtoGrave(fc,REASON_RULE)
			 Duel.BreakEffect()
		  end
		  Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		  local te=tc:GetActivateEffect()
		  local tep=tc:GetControler()
		  local cost=te:GetCost()
		  if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		  Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	   end
	elseif op==2 then
	   local tc=Duel.GetFirstTarget()
	   if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or emg:GetCount()<=0 then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)   
	   local mg=emg:Select(tp,1,1,nil)
	   Duel.HintSelection(mg)  
	   local mc=mg:GetFirst() 
	   local code=mc:GetOriginalCodeRule()
	   tc:CopyEffect(code,RESET_EVENT+0x1fe0000)
	   if not tc:IsType(TYPE_EFFECT) then
		  local e0=Effect.CreateEffect(c)
		  e0:SetType(EFFECT_TYPE_SINGLE)
		  e0:SetCode(EFFECT_ADD_TYPE)
		  e0:SetValue(TYPE_EFFECT)
		  e0:SetReset(RESET_EVENT+0x1fe0000)
		  tc:RegisterEffect(e0)
	   end
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	   e1:SetRange(LOCATION_MZONE)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	   e1:SetValue(1)
	   --tc:RegisterEffect(e1)
	   local e2=e1:Clone()
	   e2:SetDescription(aux.Stringid(10122007,4))
	   e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT+EFFECT_FLAG_CLIENT_HINT)
	   tc:RegisterEffect(e2)
	   local e3=Effect.CreateEffect(c)
	   e3:SetType(EFFECT_TYPE_SINGLE)
	   e3:SetCode(EFFECT_UPDATE_ATTACK)
	   e3:SetReset(RESET_EVENT+0x1fe0000)
	   e3:SetValue(mc:GetAttack())
	   tc:RegisterEffect(e3)
	   local e4=e3:Clone()
	   e4:SetCode(EFFECT_UPDATE_DEFENSE)
	   e4:SetValue(mc:GetDefense())
	   tc:RegisterEffect(e4)	  
	end
end
