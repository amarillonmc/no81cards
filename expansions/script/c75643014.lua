--摘星征途 冬香
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,75643010)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,5)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.mtcon)
	e1:SetTarget(s.mttg)
	e1:SetOperation(s.mtop)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id-70000000)
	e2:SetCondition(s.efcon)
	e2:SetCost(s.efcost)
	e2:SetTarget(s.eftg)
	e2:SetOperation(s.efop)
	c:RegisterEffect(e2)
	--extra attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_XMATERIAL)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetCondition(s.gfcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.mtfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x52c6) and c:IsCanOverlay() and not c:IsCode(id)
end
function s.mcfilter(c)
	return c:IsFaceup() and c:IsCode(75643000)
end
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.mtfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and g:GetClassCount(Card.GetCode)>=1 end
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=1
	if Duel.IsExistingMatchingCard(s.mcfilter,tp,LOCATION_ONFIELD,0,1,nil) then ft=2 end
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.mtfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	if g:GetClassCount(Card.GetCode)<ft then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	if g1:GetCount()>0 then
		Duel.Overlay(c,g1)
	end
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(75643010)
end
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsAbleToEnterBP() and Duel.IsCanRemoveCounter(tp,1,0,0x32c6,4,REASON_EFFECT)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,2)},
		{b2,aux.Stringid(id,3)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
		local dam=e:GetHandler():GetAttack()
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(dam)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		elseif op==2 then
	end
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			if Duel.Destroy(g,REASON_EFFECT)>0 then
				local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
				Duel.Damage(p,e:GetHandler():GetAttack(),REASON_EFFECT)
			end
		end
	elseif op==2 then
		local c=e:GetHandler()
		if Duel.RemoveCounter(tp,1,0,0x32c6,4,REASON_EFFECT) then 
			if c:IsFaceup() and c:IsRelateToEffect(e) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EXTRA_ATTACK)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(2)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e1)
			end
		end
	end
end
function s.gfcon(e)
	local c=e:GetHandler()
	return c:IsSetCard(0x52c6) and c:IsType(TYPE_XYZ)
end