--启灵元神·冬雪感召
function c16372017.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,16372010,16372011,16372012,true,true)
	aux.AddContactFusionProcedure(c,c16372017.ffilter2,LOCATION_ONFIELD,LOCATION_ONFIELD,Duel.SendtoGrave,REASON_COST)
	--loselp
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c16372017.op)
	c:RegisterEffect(e1)
	local e10=e1:Clone()
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e10)
	--damage
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_CHAINING)
	e11:SetRange(LOCATION_MZONE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetOperation(c16372017.op2)
	c:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_CHAIN_SOLVED)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCondition(c16372017.con22)
	e12:SetOperation(c16372017.op22)
	c:RegisterEffect(e12)
	--setself
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,16372017+100)
	e2:SetCondition(c16372017.setscon)
	e2:SetTarget(c16372017.setstg)
	e2:SetOperation(c16372017.setsop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c16372017.spellcon)
	e3:SetTarget(c16372017.target)
	e3:SetOperation(c16372017.activate)
	c:RegisterEffect(e3)
end
function c16372017.ffilter2(c,fc)
	return c:IsAbleToGraveAsCost() and (c:IsControler(fc:GetControler()) or c:IsFaceup())
end
function c16372017.lpfilter(c,tp)
	return c:IsControler(tp) and not c:IsRace(RACE_PLANT)
end
function c16372017.op(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c16372017.lpfilter,1,nil,tp) then
		Duel.Hint(HINT_CARD,0,16372017)
		Duel.SetLP(tp,Duel.GetLP(tp)-500)
	end
	if eg:IsExists(c16372017.lpfilter,1,nil,1-tp) then
		Duel.Hint(HINT_CARD,0,16372017)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-500)
	end
end
function c16372017.op2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(16372017,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c16372017.con22(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(16372017)~=0
		and re:GetHandler():IsType(TYPE_MONSTER) and not re:GetHandler():IsRace(RACE_PLANT)
end
function c16372017.op22(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,16372017)
	Duel.SetLP(re:GetHandlerPlayer(),Duel.GetLP(re:GetHandlerPlayer())-500)
end
function c16372017.setscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c16372017.setstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c16372017.setsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function c16372017.spellcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c16372017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil,tp,0)
end
function c16372017.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e)
		and Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(16372017)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(e2)
	end
end