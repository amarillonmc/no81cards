--废都巡礼者
function c67200929.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pzone spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67200929,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,67200929)
	e0:SetCondition(c67200929.pspcon)
	e0:SetTarget(c67200929.psptg)
	e0:SetOperation(c67200929.pspop)
	c:RegisterEffect(e0)
	--hand to pzone 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200929,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c67200929.pspcon)
	e1:SetTarget(c67200929.pstg)
	e1:SetOperation(c67200929.psop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	--e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c67200929.cost)
	e2:SetCountLimit(1,67200934)
	e2:SetCondition(c67200929.stcon)
	e2:SetTarget(c67200929.target)
	e2:SetOperation(c67200929.activate)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c67200929.atkval)
	c:RegisterEffect(e3)
end
function c67200929.pspcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x67a) and rc:IsControler(tp)
end
function c67200929.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200929.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp)))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
--
function c67200929.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200929.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--
function c67200929.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c67200929.stcon(e)
	return Duel.GetFlagEffect(tp,67200929)==0
end
function c67200929.thfilter(c)
	return c:IsSetCard(0x567a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c67200929.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		--e:SetLabel(0)
		local cost=Duel.GetLP(tp)
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_LPCOST_CHANGE)}
		for _,te in ipairs(ce) do
			local con=te:GetCondition()
			local val=te:GetValue()
			if (not con or con(te)) then
				cost=val(te,e,tp,Duel.GetLP(tp))
			end
		end
		local count=math.floor(math.floor(Duel.GetLP(tp))/2000)
		return Duel.IsExistingMatchingCard(c67200929.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,math.floor(math.floor(Duel.GetLP(tp))/2000),nil) 
	end
	e:SetLabel(Duel.GetLP(tp))
	Duel.RegisterFlagEffect(tp,67200929,RESET_PHASE+PHASE_END,0,2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,count,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c67200929.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=math.floor(math.floor(e:GetLabel())/2000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200929.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,count,count,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	--if c:IsRelateToEffect(e) then
		--Duel.RegisterFlagEffect(tp,67200929,RESET_PHASE+PHASE_END,0,2)
	--end
end
--
function c67200929.atkval(e,c)
	local tp=c:GetControler()
	return math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
end