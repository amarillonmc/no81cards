--雷姆必拓·据点-重工基地
function c79029223.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--place
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(2521011,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetTarget(c79029223.target)
	e5:SetOperation(c79029223.operation)
	c:RegisterEffect(e5)	
	--back to deck
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c79029223.mtcon)
	e6:SetOperation(c79029223.mtop)
	c:RegisterEffect(e6)
	--self destroy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c79029223.sdcon)
	c:RegisterEffect(e7) 
	--toss
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(79029223,0))
	e2:SetCategory(CATEGORY_DICE+CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c79029223.totg)
	e2:SetOperation(c79029223.toop)
	e2:SetCountLimit(1,79029223)
	c:RegisterEffect(e2)
end
function c79029223.xfilter(c)
	return c:IsSetCard(0xa90f) and not c:IsForbidden() and not c:IsCode(79029223) and c:IsType(TYPE_EQUIP)
end
function c79029223.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029223.xfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c79029223.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c79029223.xfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
   Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
function c79029223.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c79029223.qfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function c79029223.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 then return end
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g=Duel.GetMatchingGroup(c79029223.qfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()~=0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(tg,nil,2,REASON_COST)
end
end
function c79029223.sdcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_END and ph<=PHASE_END
	and not Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c79029223.totg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,PLAYER_ALL,2)
end
function c79029223.toop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d1=Duel.TossDice(tp,1)
	if d1==1 then return end
	Duel.ConfirmDecktop(tp,d1)
	local g=Duel.GetDecktopGroup(tp,d1)
	Duel.ConfirmCards(0,g)
	local tc=g:Select(1-tp,1,1,nil)
	local tc1=g:Select(tp,1,1,tc)
	Duel.SendtoGrave(tc,REASON_EFFECT)
	Duel.SendtoHand(tc1,nil,REASON_EFFECT)
	Duel.ConfirmCards(tp,tc1)	
end




