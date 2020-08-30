function c82228517.initial_effect(c)  
	--summon with no tribute  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228517,0))  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_SUMMON_PROC)  
	e2:SetCondition(c82228517.ntcon)  
	e2:SetOperation(c82228517.ntop)  
	c:RegisterEffect(e2)
	--destroy  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228517,2))  
	e2:SetCategory(CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,82228517)  
	e2:SetTarget(c82228517.target)  
	e2:SetOperation(c82228517.operation)  
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)  
	c:RegisterEffect(e2)  
end  
function c82228517.ntcon(e,c,minc)  
	if c==nil then return true end  
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  
end  
function c82228517.ntop(e,tp,eg,ep,ev,re,r,rp,c)  
	--to grave  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228517,1))  
	e2:SetCategory(CATEGORY_TOGRAVE)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1)  
	e2:SetCode(EVENT_PHASE+PHASE_END)  
	e2:SetTarget(c82228517.tgtg)  
	e2:SetOperation(c82228517.tgop)  
	e2:SetReset(RESET_EVENT+0xc6e0000)  
	c:RegisterEffect(e2)  
end  
function c82228517.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)  
end  
function c82228517.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsFaceup() then  
		Duel.SendtoGrave(c,REASON_EFFECT)  
	end  
end  
function c82228517.filter(c)  
	return c:IsPosition(POS_FACEUP) and not c:IsAttack(c:GetBaseAttack())  
end  
function c82228517.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c82228517.filter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c82228517.filter,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,c82228517.filter,tp,0,LOCATION_MZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)	
end  
function c82228517.operation(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT)
	end  
end  