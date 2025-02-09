--绝对神速 究极骑士究极V龙兽
function c16349011.initial_effect(c)
	aux.AddCodeList(c,16340000+9011)
	c:EnableReviveLimit()
	--material
	aux.AddFusionProcMix(c,true,true,aux.FilterBoolFunction(Card.IsFusionCode,16348001),c16349011.ffilter1,c16349011.ffilter2)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16349011,1))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c16349011.target)
	e1:SetOperation(c16349011.operation)
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCountLimit(1,16349011)
	e2:SetTarget(c16349011.natg)
	e2:SetOperation(c16349011.naop)
	c:RegisterEffect(e2)
	--spsummon
	local e22=Effect.CreateEffect(c)
	e22:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e22:SetType(EFFECT_TYPE_QUICK_O)
	e22:SetRange(LOCATION_MZONE)
	e22:SetCode(EVENT_BECOME_TARGET)
	e22:SetCountLimit(1,16349011+1)
	e22:SetCondition(c16349011.discon)
	e22:SetTarget(c16349011.distg)
	e22:SetOperation(c16349011.disop)
	c:RegisterEffect(e22)
	--Pos
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(c16349011.con)
	e3:SetTarget(c16349011.tg)
	e3:SetOperation(c16349011.op)
	c:RegisterEffect(e3)
end
function c16349011.ffilter1(c)
	return c:IsLevelAbove(5) and c:IsFusionAttribute(ATTRIBUTE_LIGHT)
end
function c16349011.ffilter2(c)
	return c:IsLevelAbove(7) and c:IsFusionAttribute(ATTRIBUTE_LIGHT)
end
function c16349011.pfilter(c,tp)
	return c:IsCode(16349059) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c16349011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c16349011.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c16349011.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16349011.pfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function c16349011.natg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanChangePosition() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c16349011.naop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 then
			Duel.NegateAttack()
		end
	end
end
function c16349011.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsContains(e:GetHandler()) and Duel.IsChainDisablable(ev)
end
function c16349011.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanChangePosition() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c16349011.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 then
			Duel.NegateEffect(ev)
		end
	end
end
function c16349011.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_CONTINUOUS_POS)
end
function c16349011.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c16349011.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,16349011)==0
	local b2=Duel.IsExistingMatchingCard(c16349011.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,16349011+1)==0
	if chk==0 then return b1 or b2 end
end
function c16349011.op(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,16349011)==0
	local b2=Duel.IsExistingMatchingCard(c16349011.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,16349011+1)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(16349011,1),aux.Stringid(16349011,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(16349011,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(16349011,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
		if tc then Duel.SendtoDeck(tc,nil,2,0x40) end
		Duel.RegisterFlagEffect(tp,16349011,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,c16349011.filter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if tc then Duel.SSet(tp,tc) end
		Duel.RegisterFlagEffect(tp,16349011+1,RESET_PHASE+PHASE_END,0,1)
	end
end