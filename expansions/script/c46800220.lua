--辉厄剑的诛杀阵
function c46800220.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(46800220)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,46800221)
	e3:SetCondition(c46800220.thcon)
	e3:SetTarget(c46800220.thtg)
	e3:SetOperation(c46800220.thop)
	c:RegisterEffect(e3)
end
function c46800220.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa12)
end
function c46800220.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c46800220.cfilter,1,nil)
end
function c46800220.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c46800220.cfilter,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and g:IsContains(chkc) end
	if chk==0 then return #g>0 end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c46800220.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.floor(Duel.GetFirstTarget():GetAttack()*0.5))
end
function c46800220.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Damage(1-tp,math.floor(tc:GetAttack()*0.5),REASON_EFFECT)
	end
end