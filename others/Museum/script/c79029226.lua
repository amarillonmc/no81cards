--乌萨斯·术士干员-苦艾
function c79029226.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029226,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCountLimit(1,79029226+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c79029226.spcon)
	e1:SetValue(c79029226.spval)
	c:RegisterEffect(e1)   
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c79029226.cost)
	e3:SetTarget(c79029226.tg)
	e3:SetOperation(c79029226.op)
	c:RegisterEffect(e3)
end
function c79029226.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=Duel.GetLinkedZone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c79029226.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end
function c79029226.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c79029226.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return re:GetHandler():IsSetCard(0xc90e) or re:GetHandler():IsSetCard(0xb90d)
	end
	e:SetLabel(0)
	local rc=re:GetHandler()
	local te,ceg,cep,cev,cre,cr,crp=rc:CheckActivateEffect(false,true,true)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)

end
function c79029226.op(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		Debug.Message("突击检查，双手抱头！不许动！")
		Duel.Hint(HINT_SOUND,0,aux.Stringid(79029226,0))
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
end


