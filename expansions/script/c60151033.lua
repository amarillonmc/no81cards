--蜕变的愿望
function c60151033.initial_effect(c)
	c:EnableCounterPermit(0x101b)
	--Activate
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_ACTIVATE)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetHintTiming(0,TIMING_DRAW_PHASE)
	e11:SetCountLimit(1,60151033+EFFECT_COUNT_CODE_OATH)
	e11:SetCost(c60151033.cost)
	c:RegisterEffect(e11)
	
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60151033,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c60151033.rectg1)
	e2:SetOperation(c60151033.recop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60151033,0))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c60151033.rectg2)
	e4:SetOperation(c60151033.recop2)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(60151033,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c60151033.target)
	e5:SetOperation(c60151033.operation2)
	c:RegisterEffect(e5)
end
function c60151033.rectg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return rp==tp end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c60151033.recop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local rec=math.ceil(tc:GetAttack()/2)
		Duel.Hint(HINT_CARD,0,60151033)
		Duel.Recover(tp,rec,REASON_EFFECT)
		e:GetHandler():AddCounter(0x101b,1)
	end
end
function c60151033.filter(c,e,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSummonPlayer(1-tp)
		and (not e or c:IsRelateToEffect(e))
end
function c60151033.rectg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c60151033.filter,1,nil,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c60151033.recop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c60151033.filter,nil,e,tp)
	if g:GetCount()>0 then
		local atk=g:GetSum(Card.GetAttack)
		Duel.Hint(HINT_CARD,0,60151033)
		Duel.Recover(tp,math.ceil(atk/2),REASON_EFFECT)
		e:GetHandler():AddCounter(0x101b,1)
	end
end
function c60151033.costfilter2(c,e,tp)
	return c:IsSetCard(0x5b23) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER)
end
function c60151033.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151033.costfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c60151033.costfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c60151033.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	--
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetTarget(c60151033.splimit)
	e:GetHandler():RegisterEffect(e3,tp)
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetLabel(0)
	e1:SetCondition(c60151033.drcon)
	e1:SetOperation(c60151033.drop)
	e:GetHandler():RegisterEffect(e1,tp)
end
function c60151033.splimit(e,c,tp,sumtp,sumpos)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_LINK) or c:IsType(TYPE_XYZ))
end
function c60151033.cfilter(c,tp)
	return c:IsControler(1-tp) and (c:GetSummonType()==SUMMON_TYPE_XYZ or c:GetSummonType()==SUMMON_TYPE_LINK)
end
function c60151033.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60151033.cfilter,1,nil,tp)
end
function c60151033.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		Duel.Hint(HINT_CARD,0,60151033)
		Duel.Recover(tp,1000,REASON_EFFECT)
		e:GetHandler():AddCounter(0x101b,1)
	end
end
function c60151033.op2f(c,e,tp,atk)
	return c:IsSetCard(0x5b23) and c:IsRace(RACE_FIEND) 
		and c:GetAttack()<=atk and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c60151033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60151033.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetHandler():GetCounter(0x101b)
	local val=ct*300
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCountFromEx(tp)<=0 
		or not Duel.IsExistingMatchingCard(c60151033.op2f,tp,LOCATION_EXTRA,0,1,nil,e,tp,val) 
		or c:GetCounter(0x101b)==0 then 
		Duel.Destroy(c,REASON_EFFECT)
	end
	e:GetHandler():RemoveCounter(tp,0x101b,ct,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60151033.op2f,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,val)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_XYZ) then
		if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0 then
			c:CancelToGrave()
			Duel.Overlay(tc,Group.FromCards(c))
		end
	elseif tc:IsType(TYPE_LINK) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc2=g2:GetFirst()
	while tc2 do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc2:RegisterEffect(e1)
		tc2=g2:GetNext()
	end
	if c:IsLocation(LOCATION_SZONE) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end