--正义的妖精 法尔西昂
function c33700038.initial_effect(c)
   -- 
 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99177923,0))
	e1:SetCode(EVENT_DRAW)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c33700038.con)
	e1:SetCost(c33700038.cost)
	e1:SetTarget(c33700038.tg)
	e1:SetOperation(c33700038.op)
	c:RegisterEffect(e1)
	 --
	 local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetOperation(c33700038.slop)
	c:RegisterEffect(e2)
end
function c33700038.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	return ev==ct and eg:IsContains(c) and Duel.GetCurrentPhase()==PHASE_DRAW 
end
function c33700038.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c33700038.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local cg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local c=e:GetHandler()
	if chk==0 then return tg>cg
		and Duel.IsPlayerCanDraw(tg-cg) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,tg-cg)
end
function c33700038.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local cg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.Draw(tp,tg-cg,REASON_EFFECT)
end
function c33700038.slop(e,tp,eg,ep,ev,re,r,rp)
	 local op=Duel.SelectOption(1-tp,aux.Stringid(33700038,0),aux.Stringid(33700038,1),aux.Stringid(33700038,2))
	if op==0 then
   local tg=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local cg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if tg==cg then return end
	 if tg>cg then
	 Duel.Draw(tp,tg-cg,REASON_EFFECT)
	elseif tg<cg then
	  Duel.DiscardHand(tp,Card.IsDiscardable,cg-tg,cg-tg,REASON_EFFECT+REASON_DISCARD,nil)
end
elseif op==1 then
 local tg=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local cg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if tg==cg then return end
	 if tg<cg then
	 Duel.Draw(1-tp,cg-tg,REASON_EFFECT)
	elseif tg>cg then
	  Duel.DiscardHand(1-tp,Card.IsDiscardable,tg-cg,tg-cg,REASON_EFFECT+REASON_DISCARD,nil)
end
	elseif op==2 and  Duel.Draw(tp,1,REASON_EFFECT)>0 and e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToEffect(e) then
		 local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_UPDATE_ATTACK)
		   e1:SetValue(1000)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			 e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		  e:GetHandler():RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e2)
end
end