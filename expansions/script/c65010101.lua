--『星光歌剧』台本-轮回Revue
function c65010101.initial_effect(c)
	--summon with 1 tribute
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(65010101,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c65010101.otcon)
	e0:SetOperation(c65010101.otop)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c65010101.spcon)
	e2:SetOperation(c65010101.spop)
	c:RegisterEffect(e2)
	--attack up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,9910001)
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e3:SetTarget(c65010101.atktg)
	e3:SetOperation(c65010101.atkop)
	c:RegisterEffect(e3)
end
function c65010101.otfilter(c)
	return c:IsSetCard(0x9da0)
end
function c65010101.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c65010101.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c65010101.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c65010101.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c65010101.spfilter(c)
	return c:IsSetCard(0x9da0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c65010101.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c65010101.spfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
end
function c65010101.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c65010101.spfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c65010101.atkfilter(c)
	return c:IsSetCard(0x9da0) and c:GetAttack()>0
end
function c65010101.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c65010101.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65010101.atkfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c65010101.atkfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_ATKCHANGE)
		e:SetLabel(0)
	end
end
function c65010101.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(math.ceil(atk/2))
		c:RegisterEffect(e1)
		if e:GetLabel()==1 and tc:IsRelateToEffect(e)
			and Duel.SelectYesNo(tp,aux.Stringid(65010101,1)) then
			Duel.BreakEffect()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
