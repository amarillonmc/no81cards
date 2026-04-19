local s,id,o=GetID()
function s.initial_effect(c)
		--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.target1)
	e3:SetOperation(s.activate1)
	c:RegisterEffect(e3)
end
function s.filter1(c)
	return  c:GetFlagEffect(4879171)~=0
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,0x3f,0x3f,1,nil) end
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
end
function s.filter(c)
	return c:IsSetCard(0xae5d) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.spcfilter(c)
	return c:IsCode(4879171) and c:IsFaceup()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
   -- local e1=Effect.CreateEffect(e:GetHandler())
   -- e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
   --  e1:SetProperty(EFFECT_FLAG_DELAY)
  --  e1:SetCode(EVENT_DRAW)
  --  e1:SetOperation(s.desop)
  --  e1:SetReset(RESET_PHASE+PHASE_END,2)
  --  Duel.RegisterEffect(e1,tp)
  --	 local e2=Effect.CreateEffect(e:GetHandler())
  --  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  --  e2:SetCode(EVENT_PHASE+PHASE_END)
  --  e2:SetCountLimit(1)
  --  e2:SetOperation(s.turnop)
  --  e2:SetReset(RESET_PHASE+PHASE_END,2)
  -- Duel.RegisterEffect(e2,tp)
  --  e2:SetLabelObject(e1)
  --	  s[e:GetHandler()]=e1
 --   e:GetHandler():RegisterFlagEffect(1082946,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(id,0))
  --  e:GetHandler():RegisterFlagEffect(4879171,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(id,0))
	   local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		e1:SetLabel(0)
		e1:SetOperation(s.thop)
		Duel.RegisterEffect(e1,tp)
		 s[c]=e1
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2)
c:RegisterFlagEffect(4879171,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2)
end
function s.turnop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	e:GetHandler():SetTurnCounter(ct)
	if ct==2 then
		e:GetLabelObject():Reset()

		e:GetOwner():ResetFlagEffect(4879171)
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	 if #g>0 then
	 Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	 end

end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct+1==2 then
 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	 if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
e:Reset()
		e:GetOwner():ResetFlagEffect(1082946)
e:GetOwner():ResetFlagEffect(4879171)
	 end
	else e:SetLabel(ct+1) end
	
end