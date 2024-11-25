--居合斩！蓄势待发
function c65830045.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--act qp in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65830045,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa33))
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	--发动
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c65830045.atkcon)
	e3:SetCost(c65830045.atkcost)
	e3:SetTarget(c65830045.atktg)
	e3:SetOperation(c65830045.atkop)
	c:RegisterEffect(e3)
	--特招
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,65830045+EFFECT_COUNT_CODE_OATH)
	e5:SetTarget(c65830045.target)
	e5:SetOperation(c65830045.operation)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_FZONE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetOperation(aux.chainreg)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAIN_SOLVED)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCondition(c65830045.damcon)
	e7:SetOperation(c65830045.damop)
	c:RegisterEffect(e7)
end


function c65830045.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c65830045.cfilter(c)
	return c:IsSetCard(0xa33) and c:IsDiscardable()
end
function c65830045.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65830045.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c65830045.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c65830045.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function c65830045.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,65830045,RESET_CHAIN,0,1)
	end
	Duel.ResetFlagEffect(tp,65830045)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	if c:GetLocation()==LOCATION_HAND then
	Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	local te=c:GetActivateEffect()
	te:UseCountLimit(tp,1,true)
	local tep=c:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1)
	end
	Duel.RaiseEvent(c,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end

function c65830045.spfilter(c,e,tp)
	return c:IsSetCard(0xa33) and c:IsAbleToHand() and aux.NecroValleyFilter()
end
function c65830045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65830045.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c65830045.filter(c)
	return c:IsAbleToDeck()
end
function c65830045.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65830045.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tg=Duel.GetMatchingGroup(c65830045.filter,tp,LOCATION_HAND,0,nil,e,tp)
		if tg:GetCount()>1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=tg:Select(tp,1,1,nil)
			if sg:GetCount()>0 then
				Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
			end
		end
	end
end


function c65830045.damcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsSetCard(0xa33) and re:GetHandler():IsType(TYPE_QUICKPLAY) and rp==tp and e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0
end
function c65830045.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65830045)
	Duel.Damage(1-tp,400,REASON_EFFECT)
end