--机会的妖精 米勒娃
function c33700037.initial_effect(c)
   --draw  
   local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99177923,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetCode(EVENT_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c33700037.con)
	e1:SetCost(c33700037.cost)
	e1:SetTarget(c33700037.tg)
	e1:SetOperation(c33700037.op)
	c:RegisterEffect(e1)
	 --
	 local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetTarget(c33700037.sltg)
   e2:SetOperation(c33700037.slop)
	c:RegisterEffect(e2)
end
function c33700037.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  eg:IsContains(c) and Duel.GetCurrentPhase()==PHASE_DRAW 
end
function c33700037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c33700037.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33700037.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	g:RemoveCard(e:GetHandler())
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	Duel.BreakEffect()
	Duel.Draw(tp,g:GetCount(),REASON_EFFECT)
end
function c33700037.filter(c)
	return not c:IsPublic()
end
function c33700037.sltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700037.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33700037.slop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if not Duel.IsExistingMatchingCard(c33700037.filter,tp,LOCATION_HAND,0,1,nil) then return end
   Duel.ConfirmCards(1-tp,g)
     local op=Duel.SelectOption(1-tp,aux.Stringid(33700037,0),aux.Stringid(33700037,1))
	if op==0 then
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.Draw(tp,g:GetCount(),REASON_EFFECT)
	elseif op==1 and  Duel.Draw(tp,1,REASON_EFFECT)>0 and e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToEffect(e) then
		 local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_UPDATE_ATTACK)
		  	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
     		  e1:SetValue(1000)
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