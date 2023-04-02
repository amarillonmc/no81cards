--创刻-苏芳杏里咲『链锯驾驭』
function c67200066.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionCode,67200064),c67200066.ffilter,true)
	--change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200066,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200066)
	e1:SetCost(c67200066.sccost)
	e1:SetTarget(c67200066.sctg)
	e1:SetOperation(c67200066.scop)
	c:RegisterEffect(e1)
	--counter 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200066,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,67200067)
	e2:SetTarget(c67200066.rectg)
	e2:SetOperation(c67200066.recop)
	c:RegisterEffect(e2)
end
function c67200066.ffilter(c)
	return c:IsFusionSetCard(0x673) or c:IsFusionAttribute(ATTRIBUTE_LIGHT)
end
--
--
function c67200066.scfilter1(c)
	return c:IsReleasable() and c:IsSetCard(0x673)
end
function c67200066.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200066.scfilter1,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c67200066.scfilter1,tp,LOCATION_SZONE,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.Release(tc,REASON_COST)
end
function c67200066.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c67200066.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp)))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
end
--
function c67200066.recfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()>0 and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c67200066.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c67200066.recfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67200066.recfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c67200066.recfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetBaseAttack())
end
function c67200066.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetBaseAttack()>0 then
		Duel.Recover(tp,tc:GetBaseAttack(),REASON_EFFECT)
	end
end

