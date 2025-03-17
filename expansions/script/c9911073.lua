--吸血鬼魔血 月圆悲鸣
function c9911073.initial_effect(c)
	aux.AddCodeList(c,9911056)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCondition(c9911073.condition)
	e1:SetTarget(c9911073.target)
	e1:SetOperation(c9911073.activate)
	c:RegisterEffect(e1)
end
function c9911073.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8e)
end
function c9911073.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9911073.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetCurrentChain()==0 and rp==1-tp
end
function c9911073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function c9911073.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	local dg=Duel.GetOperatedGroup()
	local tc=dg:GetFirst()
	local atk=0
	while tc do
		local tatk=tc:GetTextAttack()
		if tatk>0 then atk=atk+tatk end
		tc=dg:GetNext()
	end
	Duel.Recover(tp,atk,REASON_EFFECT)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c9911073.damcon)
		e1:SetOperation(c9911073.damop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9911073.checkfilter(c)
	return c:IsCode(9911056) and c:IsFaceup()
end
function c9911073.damcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9911073.checkfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9911073.damop(e,tp,eg,ep,ev,re,r,rp)
	local og=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local mg,matk=og:GetMaxGroup(Card.GetAttack)
	Duel.Damage(tp,matk,REASON_EFFECT)
end
