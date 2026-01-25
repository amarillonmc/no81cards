--摘星征途 琥珀
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,75643010)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,4)
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
	--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1500)
	e3:SetCondition(s.gfcon)
	c:RegisterEffect(e3)
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
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,2)},
		{b2,aux.Stringid(id,3)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetTargetPlayer(1-tp)
		local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)*500
		Duel.SetTargetParam(dam)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
		elseif op==2 then
		e:SetCategory(CATEGORY_ATKCHANGE)
	end
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)*500
		Duel.Damage(p,dam,REASON_EFFECT)
	elseif op==2 then
		local c=e:GetHandler()
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
			if ct>0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(ct*500)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				c:RegisterEffect(e1)
			end
		end
	end
end
function s.gfcon(e)
	local c=e:GetHandler()
	return c:IsSetCard(0x52c6) and c:IsType(TYPE_XYZ)
end