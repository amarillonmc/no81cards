--动物朋友 灰狼
function c33700091.initial_effect(c)
	c33700091[c]={}
	local effect_list=c33700091[c]
	  --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3841833,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33700091.cost)
	e1:SetTarget(c33700091.target)
	e1:SetOperation(c33700091.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e2:SetDescription(aux.Stringid(25165047,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	effect_list[3]=e2
	e2:SetCondition(c33700091.con)
	e2:SetTarget(c33700091.tg)
	e2:SetOperation(c33700091.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c33700091.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c33700091.thfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(33700091)
end
function c33700091.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700091.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33700091.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700091.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c33700091.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c33700091.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return  re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c33700091.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c33700091.con(e,tp,eg,ep,ev,re,r,rp)
	  local g=Duel.GetMatchingGroup(c33700091.confilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=3  or e:GetLabel()==33700090
end
function c33700091.tg(e,tp,eg,ep,ev,re,r,rp,chk)
   local g=Duel.GetMatchingGroup(c33700091.confilter,tp,LOCATION_GRAVE,0,nil) 
   if chk==0 then return Duel.IsExistingMatchingCard(c33700091.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	if g:GetClassCount(Card.GetCode)>=7 and e:GetHandler():IsRelateToEffect(e) then 
 Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
end
function c33700091.filter(c)
	return aux.IsCodeListed(c,33700056) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c33700091.cfilter(c)
   return  c:IsPublic()
end
function c33700091.jfilter(c)
	return c:GetCode()==33700090 and c:IsFaceup() and not c:IsDisabled()
end
function c33700091.sgfilter(c,tp)
	return  c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c33700091.hfilter,tp,LOCATION_DECK,0,1,nil)
end
function c33700091.hfilter(c)
	return  c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33700091.op(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c33700091.confilter,tp,LOCATION_GRAVE,0,nil) 
   if g:GetClassCount(Card.GetCode)>=3  or e:GetLabel()==33700090 then
	local tg=Duel.SelectMatchingCard(tp,c33700091.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
end
end
   if g:GetClassCount(Card.GetCode)>=7  or  e:GetLabel()==33700090 and Duel.IsExistingMatchingCard(c33700091.sgfilter,tp,LOCATION_HAND,0,1,nil,tp) and not Duel.IsExistingMatchingCard(c33700091.cfilter,tp,LOCATION_HAND,0,1,nil) 
   then 
	local fg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.ConfirmCards(1-tp,fg)
	local cg=Duel.GetMatchingGroupCount(c33700091.hfilter,tp,LOCATION_DECK,0,nil)
	 local tg=Duel.SelectMatchingCard(tp,c33700091.sgfilter,tp,LOCATION_HAND,0,1,cg,nil,tp)
	 local dg=Duel.SendtoGrave(tg,REASON_EFFECT)
	Duel.BreakEffect()
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=Duel.SelectMatchingCard(tp,c33700091.hfilter,tp,LOCATION_DECK,0,dg,dg,nil)
	if hg:GetCount()>0 then
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)
	end
end
   if g:GetClassCount(Card.GetCode)>=21 and e:GetHandler():IsRelateToEffect(e) then
   local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c33700091.chainop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e1)
end
end
function c33700091.chainop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		Duel.SetChainLimit(c33700091.chainlm)
	end
end
function c33700091.chainlm(e,rp,tp)
	return tp==rp
end