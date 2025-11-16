--授冠之时
function c75081102.initial_effect(c)
	--activate
	local e0=aux.AddRitualProcGreater2(c,c75081102.spfilter,LOCATION_HAND+LOCATION_DECK,nil,c75081102.mfilter)
	e0:SetCountLimit(1,75081102+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e0)  
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75081102,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	--e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c75081102.spcon)
	e1:SetTarget(c75081102.sptg)
	e1:SetOperation(c75081102.spop)
	c:RegisterEffect(e1)  
end
function c75081102.spfilter(c)
	return c:IsSetCard(0xc754)
end
function c75081102.mfilter(c)
	return c:IsSetCard(0xc754)
end
--
function c75081102.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c75081102.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return true end
	e:SetLabel(0)
	local te=c:CheckActivateEffect(true,true,false)
	e:SetLabelObject(te)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
end
function c75081102.spop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
