--千夜 赤炎之剑
function c60150606.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60150606,3))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c60150606.e2atktg)
	e2:SetOperation(c60150606.e2atkop)
	c:RegisterEffect(e2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c60150606.spcon)
	c:RegisterEffect(e1)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60150606,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCountLimit(1,60150606)
	e4:SetCondition(c60150606.descon)
	e4:SetTarget(c60150606.destg)
	e4:SetOperation(c60150606.desop)
	c:RegisterEffect(e4)

	--Duel.AddCustomActivityCounter(60150606,ACTIVITY_SPSUMMON,c60150606.counterfilter)
end
function c60150606.e2f(c)
	return c:IsFaceup() and c:IsSetCard(0x3b21)
end
function c60150606.e2atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60150606.e2f(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60150606.e2f,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c60150606.e2f,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150606.e2atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c60150606.counterfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c60150606.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(60150606,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60150606.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c60150606.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_SPELLCASTER)
end
function c60150606.rpfilter(c,e,tp)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_PENDULUM) and (not c:IsForbidden()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))) and not c:IsCode(60150606)
end
function c60150606.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150606.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c60150606.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150601,6))
		local g=Duel.SelectMatchingCard(tp,c60150606.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		local op=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			op=Duel.SelectOption(tp,aux.Stringid(60150601,1),aux.Stringid(60150601,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(60150601,1))
		end
		if op==0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c60150606.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b21)
end
function c60150606.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60150606.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60150606.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c60150606.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c60150606.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
function c60150606.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x5b21)
end
function c60150606.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c60150606.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:GetAttack()~=0
end
function c60150606.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150606.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c60150606.filter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150606.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c60150606.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c60150606.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end