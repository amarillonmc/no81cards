--游星钢战-星辰擎天柱
function c82557919.initial_effect(c)
	--summon with no tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82557919,0))
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c82557919.ntcon)
	c:RegisterEffect(e2)
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82557928,2))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,82557928)
	e4:SetTarget(c82557919.target)
	e4:SetOperation(c82557919.activate)
	c:RegisterEffect(e4)
end
function c82557919.ntfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x829)
end
function c82557919.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82557919.ntfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c82557919.ctfilter(c,e)
	return c:IsControlerCanBeChanged() and c:IsAttackBelow(e:GetHandler():GetAttack()) and c:IsFaceup()
end
function c82557919.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() 
				and chkc:IsAttackBelow(e:GetHandler():GetAttack()) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82557919.ctfilter,tp,0,LOCATION_MZONE,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c82557919.ctfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c82557919.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end
