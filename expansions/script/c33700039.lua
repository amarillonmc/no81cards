--意义的妖精 卡珊德拉
function c33700039.initial_effect(c) 
--lp
   local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99177923,0))
	e1:SetCode(EVENT_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c33700039.con)
	e1:SetCost(c33700039.cost)
	e1:SetOperation(c33700039.op)
	c:RegisterEffect(e1)
	 --
	 local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetOperation(c33700039.slop)
	c:RegisterEffect(e2)
end
function c33700039.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  eg:IsContains(c) and Duel.GetCurrentPhase()==PHASE_DRAW  and Duel.GetLP(1-tp)-Duel.GetLP(tp)>=2000
end
function c33700039.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c33700039.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,4000)
	Duel.SetLP(1-tp,4000)
end
function c33700039.slop(e,tp,eg,ep,ev,re,r,rp)
	 local op=Duel.SelectOption(1-tp,aux.Stringid(33700039,0),aux.Stringid(33700039,1),aux.Stringid(33700039,2))
	if op==0 then
	 local a=Duel.GetLP(1-tp)
	 local b=Duel.GetLP(tp)
	  Duel.SetLP(tp,(a+b)/2)
	Duel.SetLP(1-tp,(a+b)/2)  
   elseif op==1 then
	local p1=Duel.GetLP(tp)
	local p2=Duel.GetLP(1-tp)
	local s=p2-p1
	if s>0 then
	local d=math.floor(s/1000)
	Duel.Draw(tp,d,REASON_EFFECT)
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