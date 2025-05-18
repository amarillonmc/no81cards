--秘藏一闪 影潜者 赛伦迪斯
function c40011519.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--transform
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c40011519.transcon)
	e2:SetOperation(c40011519.transop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,40011519)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c40011519.actg)
	e3:SetOperation(c40011519.acop)
	c:RegisterEffect(e3)
end
function c40011519.acfilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c40011519.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40011519.acfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function c40011519.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
	local tc=Duel.SelectMatchingCard(tp,c40011519.acfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	Duel.ResetFlagEffect(tp,15248873)
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		if tc:IsCode(40011525) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(40011519,0)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c40011519.transcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOriginalCode()==40011519 and c:IsLocation(LOCATION_SZONE) and c:IsFacedown()
end
function c40011519.transop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(9911634,true)
	c:ReplaceEffect(9911634,0,0)
end
