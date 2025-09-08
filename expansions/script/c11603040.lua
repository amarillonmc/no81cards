--四象封灵阵
local s,id=GetID()
function s.initial_effect(c)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(function(e) return Duel.IsTurnPlayer(1-e:GetHandlerPlayer()) end)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsAllTypes(TYPE_RITUAL+TYPE_MONSTER) and c:IsSetCard(0x6224)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.cfilter2(c)
	return c:IsFaceup() --and c:IsSetCard(0x6224)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroup(s.cfilter2,tp,LOCATION_ONFIELD,0,nil):GetClassCount(Card.GetCode)
	if chk==0 then return ct>=1 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=ct end
end
function s.plfilter(c,tp)
	return c:CheckUniqueOnField(tp,LOCATION_SZONE) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.seqfilter(c,dis)
	return 1<<c:GetSequence()==dis
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroup(s.cfilter2,tp,LOCATION_ONFIELD,0,e:GetHandler()):GetClassCount(Card.GetCode)
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)==0 or ct<=0 then return end
	local zone=0
	Duel.ConfirmDecktop(1-tp,ct)
	local g=Duel.GetDecktopGroup(1-tp,ct):Filter(s.plfilter,nil,1-tp)
	ct=math.min(ct,5)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tg=g:Select(tp,1,ct,nil)
	for tc in aux.Next(tg) do
		if tc then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local dis=Duel.SelectField(tp,1,0,LOCATION_SZONE,0x20002000|zone)
			zone=dis|zone
			dis=((dis&0xffff)<<24)|((dis>>24)&0xffff)

			local dg=Duel.GetMatchingGroup(s.seqfilter,tp,0,LOCATION_SZONE,nil,dis)
			if #dg>0 then
				Duel.Destroy(dg,REASON_RULE)
			end
			if Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,dis) then
				--Treated as a Continuous Spell
				local c=e:GetHandler()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				e1:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TURN_SET)
				tc:RegisterEffect(e1)
				--Add this card to the deck
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(aux.Stringid(id,2))
				e2:SetCategory(CATEGORY_TODECK)
				e2:SetType(EFFECT_TYPE_IGNITION)
				e2:SetRange(LOCATION_SZONE)
				if tc:IsOriginalSetCard(0x6224) then
					e2:SetCondition(aux.NOT(s.effcon))
				end
				e2:SetCost(s.tdcost)
				e2:SetTarget(s.tdtg)
				e2:SetOperation(s.tdop)
				e2:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TURN_SET)
				tc:RegisterEffect(e2)
				if tc:IsOriginalSetCard(0x6224) then
					local e3=e2:Clone()
					e3:SetType(EFFECT_TYPE_QUICK_O)
					e3:SetCode(EVENT_FREE_CHAIN)
					e3:SetCondition(s.effcon)
					c:RegisterEffect(e3)
				end
			end
		end
	end
end
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	c:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAllTypes(TYPE_CONTINUOUS+TYPE_TRAP) and Duel.IsPlayerAffectedByEffect(tp,11603037)
end