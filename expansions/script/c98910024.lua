--双天的激昂
function c98910024.initial_effect(c)	
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c98910024.condition)
	e1:SetTarget(c98910024.target)
	e1:SetOperation(c98910024.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c98910024.handcon)
	c:RegisterEffect(e3)  
  --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98910024)
	e2:SetCondition(c98910024.thcon)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c98910024.thtg)
	e2:SetOperation(c98910024.thop)
	c:RegisterEffect(e2)
end
function c98910024.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x14f) and c:IsType(TYPE_FUSION)
end
function c98910024.handcon(e)
	return Duel.IsExistingMatchingCard(c98910024.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c98910024.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x14f) and c:IsType(TYPE_MONSTER)
end
function c98910024.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98910024.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c98910024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.ndcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c98910024.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x14f) and c:IsType(TYPE_MONSTER)
end
function c98910024.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
			local g=Duel.GetMatchingGroup(c98910024.desfilter,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=g:Select(tp,1,1,nil)
				Duel.Destroy(sg,REASON_EFFECT)
				local og=Duel.GetOperatedGroup()	   
				if og:IsExists(c98910024.ffilter,1,nil,tp) then
				   local b1=Duel.IsPlayerCanDraw(tp,1)
				   local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil)
				   local off=1
				   local ops={}
				   local opval={}
				   if b1 then
					  ops[off]=aux.Stringid(98910024,0)
					  opval[off-1]=1
					  off=off+1
				  end
				if b2 then
				   ops[off]=aux.Stringid(98910024,1)
				   opval[off-1]=2
				   off=off+1
				end
				ops[off]=aux.Stringid(98910024,2)
				opval[off-1]=3
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
				local op=Duel.SelectOption(tp,table.unpack(ops))
				local sel=opval[op]
				if sel==1 then
				   Duel.BreakEffect()
				   Duel.Draw(tp,1,REASON_EFFECT)
				elseif sel==2 then
				   Duel.BreakEffect()
				   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				   local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
				   if #g>0 then
					  Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
				   end
			   end
		   end
	   end
	end
end
function c98910024.ffilter(c,tp)
	return c:IsPreviousSetCard(0x14f) and c:IsPreviousControler(tp) and c:GetPreviousTypeOnField()&TYPE_FUSION~=0
		and c:IsPreviousPosition(POS_FACEUP)
end
function c98910024.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98910024.thfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c98910024.thfilter(c,tp)
	return c:IsSetCard(0x14f) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) and c:GetReasonPlayer()==1-tp
end
function c98910024.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c98910024.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end