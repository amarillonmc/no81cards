function c10105581.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105581,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10105581)
	e1:SetCost(c10105581.spcost)
	e1:SetTarget(c10105581.sptg)
	e1:SetOperation(c10105581.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(c10105581.spreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105581,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1,10105581)
	e3:SetCondition(c10105581.spcon)
	e3:SetTarget(c10105581.sptg2)
	e3:SetOperation(c10105581.spop2)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10105581,1))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,c10105581)
	e4:SetCost(c10105581.discost)
	e4:SetTarget(c10105581.distg)
	e4:SetOperation(c10105581.disop)
	c:RegisterEffect(e4)
end
function c10105581.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(10) and c:IsAbleToRemoveAsCost()
end
function c10105581.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c10105581.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,c) end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c10105581.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10105581.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10105581.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c10105581.spreg(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(Duel.GetTurnCount())
	e:GetHandler():RegisterFlagEffect(10105581,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
end
function c10105581.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and c:GetFlagEffect(10105581)>0
end
function c10105581.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:ResetFlagEffect(10105581)
end
function c10105581.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function c10105581.costfilter(c)
	return c:IsSetCard(0x7cca) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c10105581.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105581.costfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10105581.costfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10105581.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.NegateEffectMonsterFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateEffectMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,aux.NegateEffectMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c10105581.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end