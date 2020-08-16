--虚拟YouTuber的善意
function c33701325.initial_effect(c)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701325,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCost(c33701325.negcost)
	e2:SetCondition(c33701325.negcon)
	e2:SetTarget(c33701325.negtg)
	e2:SetOperation(c33701325.negop)
	c:RegisterEffect(e2)	
end
function c33701325.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c33701325.nefil(c)
	return (c:IsSetCard(0x445) or c:IsSetCard(0x344c))
end
function c33701325.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g==nil then return end
	return g:FilterCount(c33701325.nefil,nil)~=0
end
function c33701325.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c33701325.sdfil(c)
	return c:IsSetCard(0x445) or c:IsSetCard(0x344c)
end
function c33701325.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
	if Duel.IsExistingMatchingCard(c33701325.sdfil,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,nil) and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	local g=Duel.SelectMatchingCard(tp,c33701325.sdfil,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	end
	end
	local c=e:GetHandler()
	local tc=re:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetTarget(c33701325.distg)
	e1:SetLabelObject(tc)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c33701325.discon)
	e2:SetOperation(c33701325.disop)
	e2:SetLabelObject(tc)
	Duel.RegisterEffect(e2,tp)
end
function c33701325.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsCode(tc:GetCode())
end
function c33701325.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode())
end
function c33701325.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end




