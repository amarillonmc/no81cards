--夏乡追忆 灯下烟火
function c67210103.initial_effect(c)
	--setP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67210103,1))
	--e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c67210103.stcon)
	e2:SetTarget(c67210103.sttg)
	e2:SetOperation(c67210103.stop)
	c:RegisterEffect(e2)	 
end
--
function c67210103.stcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE
end
function c67210103.penfilter(c)
	return c:IsSetCard(0x67e) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and not c:IsCode(67210103)
end
function c67210103.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c67210103.penfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67210103.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c67210103.penfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end

end