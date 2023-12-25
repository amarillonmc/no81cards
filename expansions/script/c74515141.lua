--人偶·梦咲音月
function c74515141.initial_effect(c)
	aux.EnableDualAttribute(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74515141,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCondition(aux.IsDualState)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c74515141.cpcost)
	e1:SetTarget(c74515141.cptg)
	e1:SetOperation(c74515141.cpop)
	c:RegisterEffect(e1)
end
function c74515141.cpfilter(c)
	return c:IsType(TYPE_SPELL) and not c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost() and c:IsSetCard(0x745)
		and c:CheckActivateEffect(false,true,false)~=nil
end
function c74515141.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c74515141.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c74515141.cpfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c74515141.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c74515141.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
