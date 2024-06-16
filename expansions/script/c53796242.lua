local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(s.sfilter),1,1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.chcon)
	e2:SetTarget(s.chtg)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)
end
function s.sfilter(c)
	return c:IsAttackBelow(2000)
end
function s.efilter(e,te,c)
	local ec=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local eset={c:IsHasEffect(EFFECT_FLAG_EFFECT+id)}
	local tc=te:GetHandler()
	local res=(te:GetOwnerPlayer()~=tp and te:IsActiveType(TYPE_MONSTER) and tc:GetAttack()<ec:GetBaseAttack() and tc:IsAbleToDeck())
	local ctns=false
	if not te:IsHasType(EFFECT_TYPE_ACTIONS) then
		for _,se in pairs(eset) do
			if se:GetLabelObject()==te and c:IsRelateToCard(tc) then ctns=true end
		end
	end
	if res and not ctns then
		local flag=c:GetFlagEffect(id)
		local e1=Effect.CreateEffect(ec)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_FLAG_EFFECT+id)
		e1:SetLabelObject(te)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
		c:CreateRelation(tc,RESET_EVENT+RESETS_STANDARD)
		if Duel.GetFlagEffect(tp,id)==0 then
			Duel.RegisterFlagEffect(tp,id,0,0,0)
			local e2=Effect.CreateEffect(ec)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_ADJUST)
			e2:SetLabelObject(tc)
			e2:SetOperation(s.imcop)
			Duel.RegisterEffect(e2,tp)
		end
	end
	return res
end
function s.imcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local tc=e:GetLabelObject()
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local e1=Effect.CreateEffect(e:GetOwner())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetValue(-(math.ceil(tc:GetBaseAttack()/2)))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetOwner():RegisterEffect(e1,true)
	end
	Duel.ResetFlagEffect(tp,id)
	e:Reset()
end 
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x104)
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,rp,0,LOCATION_MZONE,1,nil) end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
