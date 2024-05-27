local m=15005336
local cm=_G["c"..m]
cm.name="『巡猎』的飞星-波提欧"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,15005336)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15005336+EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(cm.atkcon)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	--ind
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE_STEP
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.BreakEffect()
		local c1=c
		local c2=tc
		if c1:IsControler(tp) and c1:IsPosition(POS_FACEUP_ATTACK) and not c2:IsImmuneToEffect(e)
			and c2:IsControler(1-tp) then
			Duel.CalculateDamage(c1,c2,true)
		end
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ng=Group.FromCards(c,tc)
	if ng:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	if ng:FilterCount(Card.IsImmuneToEffect,nil,e)>=1 then return end
	c:SetCardTarget(tc)
	local tc1=ng:GetFirst()
	while tc1 do
		--imm
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCondition(cm.econ)
		e1:SetValue(cm.efilter)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1)
		--atk
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCondition(cm.econ)
		e2:SetLabelObject(tc)
		e2:SetValue(1000)
		tc1:RegisterEffect(e2)
		--untargetable
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCondition(cm.econ)
		e3:SetTarget(cm.atglimit)
		e3:SetValue(cm.atlimit)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e3)
		tc1=ng:GetNext()
	end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(1,0)
	e4:SetValue(cm.aclimit)
	e4:SetCondition(cm.econ)
	e4:SetLabelObject(tc)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	Duel.RegisterEffect(e4,tp)
end
function cm.econ(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local tc=e:GetLabelObject()
	return c:IsLocation(LOCATION_MZONE) and tc:IsLocation(LOCATION_MZONE) and c:GetCardTarget():IsContains(tc)
end
function cm.efilter(e,re)
	local c=e:GetOwner()
	local tc=e:GetLabelObject()
	local ng=Group.FromCards(c,tc)
	return ng and ng:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)==2 and not ng:IsContains(re:GetOwner())
end
function cm.atglimit(e,c)
	local sc=e:GetOwner()
	local tc=e:GetLabelObject()
	local ng=Group.FromCards(sc,tc)
	return ng:IsContains(c)
end
function cm.atlimit(e,c)
	local sc=e:GetOwner()
	local tc=e:GetLabelObject()
	local ng=Group.FromCards(sc,tc)
	return not ng:IsContains(c)
end
function cm.aclimit(e,re,tp)
	return re:GetOwner():IsCode(15005336)
end