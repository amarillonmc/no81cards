--拉普兰德·瑟谣浮收藏-亡胧黯铠
function c79029486.initial_effect(c)
	--add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(79029026)
	c:RegisterEffect(e0) 
	--race
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetRange(0xff)
	e0:SetValue(RACE_MACHINE)
	c:RegisterEffect(e0)   
	--immuse
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029486.iccon)
	e1:SetOperation(c79029486.icop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)	
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE+LOCATION_MZONE)
	e3:SetCountLimit(1,79029486)
	e3:SetCondition(c79029486.negcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c79029486.negtg)
	e3:SetOperation(c79029486.negop)
	c:RegisterEffect(e3) 
end
function c79029486.ckfil(c,e,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0xa900,0x6a19)
end
function c79029486.iccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029486.ckfil,1,nil,e,tp) and e:GetHandler():IsAbleToGrave() and Duel.GetFlagEffect(tp,79029486)==0
end
function c79029486.icop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c) then 
	Duel.RegisterFlagEffect(tp,79029486,RESET_PHASE+PHASE_END,0,1)
	Debug.Message("哈哈，诸位，反正我记不住你们的脸......算了，出发吧？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029486,0))
	Duel.SendtoGrave(c,REASON_EFFECT)
	local g=eg:Filter(c79029486.ckfil,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	tc:RegisterEffect(e2)   
	tc=g:GetNext()
	end
		Duel.SetChainLimitTillChainEnd(c79029486.chainlm)
	end
end
function c79029486.chainlm(e,rp,tp)
	return not e:IsHasCategory(CATEGORY_DISABLE_SUMMON)
end
function c79029486.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x88)
end
function c79029486.negcon(e,tp,eg,ep,ev,re,r,rp)
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	return rp~=tp and te:GetHandler():IsSetCard(0xa900,0x6a19) and Duel.IsChainDisablable(ev)
end
function c79029486.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c79029486.negop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("再加把劲！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029486,1))
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end








