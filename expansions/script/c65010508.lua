--URBEX-挑战者
function c65010508.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65010508)
	e1:SetCost(c65010508.cost)
	e1:SetTarget(c65010508.tg)
	e1:SetOperation(c65010508.op)
	c:RegisterEffect(e1)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,65010509)
	e1:SetCondition(c65010508.atkcon)
	e1:SetCost(c65010508.atkcost1)
	e1:SetTarget(c65010508.atktg)
	e1:SetOperation(c65010508.atkop1)
	c:RegisterEffect(e1)
end
c65010508.setname="URBEX"
function c65010508.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c65010508.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c65010508.atkfilter(c)
	return c:IsFaceup() and c.setname=="URBEX"
end
function c65010508.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c65010508.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65010508.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c65010508.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c65010508.atkop1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function c65010508.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==3
	 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c65010508.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (Duel.GetFieldGroupCount(1-tp,LOCATION_EXTRA,0)==0 or (Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,0,LOCATION_EXTRA,1,nil,e,0,1-tp,true,false) and Duel.GetLocationCountFromEx(1-tp)>0)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	if Duel.GetFieldGroupCount(1-tp,LOCATION_EXTRA,0)>0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_EXTRA)
	end
end
function c65010508.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,0,LOCATION_EXTRA,1,nil,e,0,1-tp,true,false) and Duel.GetLocationCountFromEx(1-tp)>0 then
			local g=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,0,LOCATION_EXTRA,nil,e,0,1-tp,true,false)
			local sg=g:RandomSelect(1-tp,1)
			Duel.SpecialSummon(sg,0,1-tp,1-tp,true,false,POS_FACEUP)
			local tc=sg:GetFirst()
			 local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(65010508,RESET_EVENT+RESETS_STANDARD,0,1)
			local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetLabelObject(tc)
		e3:SetCondition(c65010508.descon)
		e3:SetOperation(c65010508.desop)
		Duel.RegisterEffect(e3,tp)
		end
	end
end
function c65010508.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(65010508)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c65010508.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end