--半魔的幼芽
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon1)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2=e1:Clone()
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCondition(s.spcon2)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.atkcon)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)

	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN) 
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(s.atkcon_quick)
	c:RegisterEffect(e4)
end

function s.spfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3f50) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end

function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spfilter,1,nil,tp)
end

function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at and at:IsFaceup() and at:IsControler(tp) and at:IsSetCard(0x3f50)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end

	if Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_MZONE,0,1,c,RACE_SPELLCASTER) then
		local g=Group.CreateGroup()
		if e:GetCode()==EVENT_BECOME_TARGET then
			local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
			if tg then g=tg:Filter(s.spfilter,nil,tp) end
		else
			local bt=Duel.GetAttackTarget()
			if bt then g:AddCard(bt) end
		end
		
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc and tc:IsCanChangePosition() then
				Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
			end
		end
	end
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local res=not Duel.IsExistingMatchingCard(s.quick_check_filter,tp,LOCATION_MZONE,0,1,nil,id)
	return Duel.GetTurnPlayer()==tp and res
end

function s.atkcon_quick(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.quick_check_filter,tp,LOCATION_MZONE,0,1,nil,id)
end

function s.quick_check_filter(c,id)
	return c:IsFaceup() and c:IsSetCard(0x3f50) and not c:IsCode(id)
end

function s.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f50)
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end