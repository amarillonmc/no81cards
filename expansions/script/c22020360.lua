--人理之基 斯忒诺
function c22020360.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c22020360.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	--summon success
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e100:SetCode(EVENT_SPSUMMON_SUCCESS)
	e100:SetOperation(c22020360.sumsuc)
	e100:SetCountLimit(1,22020360+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e100)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--damage reduce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetCondition(c22020360.rdcon)
	e2:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22020360,0))
	e3:SetCategory(CATEGORY_SSET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22020360)
	e3:SetTarget(c22020360.target)
	e3:SetOperation(c22020360.operation)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22020360,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,22020360)
	e4:SetCondition(c22020360.ntcon)
	e4:SetTarget(c22020360.target1)
	e4:SetOperation(c22020360.operation1)
	c:RegisterEffect(e4)
	--set Ereshkigal
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22020360,5))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,22020360)
	e5:SetCost(c22020360.erecost)
	e5:SetCondition(c22020360.erescon)
	e5:SetTarget(c22020360.target)
	e5:SetOperation(c22020360.operation)
	c:RegisterEffect(e5)
	--tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22020360,6))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,22020360)
	e6:SetCost(c22020360.erecost)
	e6:SetCondition(c22020360.ntcon1)
	e6:SetTarget(c22020360.target1)
	e6:SetOperation(c22020360.operation1)
	c:RegisterEffect(e6)
end
function c22020360.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	Duel.SelectOption(tp,aux.Stringid(22020360,2))
	Duel.RegisterEffect(e1,tp)
end
function c22020360.rdcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c22020360.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsSynchroType(TYPE_MONSTER) and c:IsSetCard(0x6ff1))
end
function c22020360.filter(c)
	return c:IsSetCard(0x6ff1) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c22020360.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020360.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil)
		and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
end
function c22020360.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22020360.filter),tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SelectOption(tp,aux.Stringid(22020360,3))
		Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL)
		tc:RegisterEffect(e1)
	end
end
function c22020360.rcfilter(c)
	return c:IsFacedown()
end
function c22020360.ntcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22020360.rcfilter,tp,0,LOCATION_ONFIELD,1,nil)
end
function c22020360.filter1(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c22020360.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020360.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22020360.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	Duel.SelectOption(tp,aux.Stringid(22020360,4))
	local g=Duel.SelectMatchingCard(tp,c22020360.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22020360.erescon(e,tp,eg,ep,ev,re,r,rp)
	return aux.dscon() and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22020360.ntcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980) and Duel.IsExistingMatchingCard(c22020360.rcfilter,tp,0,LOCATION_ONFIELD,1,nil)
end
function c22020360.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22020360,7))
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end