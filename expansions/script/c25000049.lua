--狂野
function c25000049.initial_effect(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c25000049.cost)
	e1:SetTarget(c25000049.target)
	e1:SetOperation(c25000049.operation)
	c:RegisterEffect(e1)
end
function c25000049.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c25000049.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return true
	end
	e:SetLabel(0)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,TYPE_SPELL,OPCODE_ISTYPE,TYPE_TRAP,OPCODE_ISTYPE,OPCODE_OR)
	c:SetHint(CHINT_CARD,ac)
	local token=Duel.CreateToken(tp,ac)
	if token:CheckActivateEffect(false,true,false)==nil then
		Debug.Message("abcdef")
		e:SetLabelObject(nil)
	else
		local te,ceg,cep,cev,cre,cr,crp=token:CheckActivateEffect(false,true,true)
		e:SetProperty(te:GetProperty())
		local tg=te:GetTarget()
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
		te:SetLabelObject(e:GetLabelObject())
		e:SetLabelObject(te)
		Duel.ClearOperationInfo(0)
	end
end
function c25000049.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end