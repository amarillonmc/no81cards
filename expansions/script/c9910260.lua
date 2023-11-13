--幽鬼不良 东云希
function c9910260.initial_effect(c)
	c:EnableCounterPermit(0x956)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9910260)
	e1:SetCondition(c9910260.spcon)
	e1:SetOperation(c9910260.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910271)
	e2:SetTarget(c9910260.cttg)
	e2:SetOperation(c9910260.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c9910260.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsCanRemoveCounter(c:GetControler(),1,0,0x956,1,REASON_COST)
end
function c9910260.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0x956,1,REASON_COST)
end
function c9910260.spfilter(c,e,tp)
	return c:IsSetCard(0xa956) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910260.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910260.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9910260.cfilter(c)
	return c:IsSetCard(0xa956) and c:IsFaceup()
end
function c9910260.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910260.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()==0 or Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local b1=c:IsRelateToEffect(e) and c:IsCanAddCounter(0x956,1)
	local b2=Duel.IsExistingTarget(c9910260.cfilter,tp,LOCATION_MZONE,0,1,nil)
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(9910260,0),aux.Stringid(9910260,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(9910260,0))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(9910260,1))+1
	else return end
	if op==0 then
		Duel.BreakEffect()
		c:AddCounter(0x956,1)
	else
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=Duel.SelectMatchingCard(tp,c9910260.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		if tc then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(tc:GetAttack()*2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
