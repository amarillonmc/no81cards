local m=15000730
local cm=_G["c"..m]
cm.name="噩梦茧机蛹·凯瑟琳"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)
	c:EnableReviveLimit()
	--I came, this turn
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	--all return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,15000730)
	e2:SetCondition(cm.rtcon)
	e2:SetTarget(cm.rttg)
	e2:SetOperation(cm.rtop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(cm.retcon)
	e3:SetCost(cm.retcost)
	e3:SetTarget(cm.rettg)
	e3:SetOperation(cm.retop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetTarget(cm.eftg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--P
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(cm.pcon)
	e5:SetTarget(cm.ptg)
	e5:SetOperation(cm.pop)
	c:RegisterEffect(e5)
end
c15000730.pendulum_level=3
function cm.ovfilter(c)
	return c:GetEffectCount(15000724)~=0
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return e:GetHandler():IsRank(2,3) end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(15000730,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(15000730)~=0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.rtfilter(c)
	return c:IsSetCard(0x6f38) and c:IsFaceup() and c:IsAbleToHand()
end
function cm.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rtfilter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.rtfilter,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,LOCATION_SZONE)
end
function cm.rtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rtfilter,tp,LOCATION_SZONE,0,nil)
	if g:GetCount()~=0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,15000730)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(tp,15000730)} do
			if i==c:GetOriginalCodeRule() then return false end
		end
	end
	return true
end
function cm.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,15000730,RESET_PHASE+PHASE_END,0,1,c:GetOriginalCodeRule())
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x6f38) and ((c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)~=0) or (c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)~=0)) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(e:GetHandler():GetOriginalCodeRule())
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,c,e,tp) and c:IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,tp,LOCATION_HAND)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,c,e,tp)
	if g:GetCount()==0 then return end
	if Duel.SendtoExtraP(c,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,c)
		if sg:GetCount()~=0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.eftg(e,c)
	return c:IsSetCard(0x6f38) and c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM)
end
function cm.pfilter(c,e,tp)
	return c:IsSetCard(0x6f38) and c:IsAbleToHand()
end
function cm.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x6f38)
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable(e) and Duel.IsExistingTarget(cm.pfilter,tp,LOCATION_PZONE,0,1,c) end
	local g=Duel.SelectTarget(tp,cm.pfilter,tp,LOCATION_PZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,tp,LOCATION_PZONE)
end
function cm.gainfilter(c,code)
	return c:GetOriginalCodeRule()==code
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	if Duel.Destroy(c,REASON_EFFECT)~=0 then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
			local code=tc:GetOriginalCodeRule()
			local yg=Duel.GetMatchingGroup(cm.gainfilter,tp,0xff,0xff,nil,code)
			local yc=yg:GetFirst()
			while yc do
				--effect gain
				local e3=Effect.CreateEffect(c)
				e3:SetDescription(aux.Stringid(m,3))
				e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TOEXTRA)
				e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
				e3:SetCode(EVENT_FREE_CHAIN)
				e3:SetRange(LOCATION_HAND)
				e3:SetCountLimit(1,15000731)
				e3:SetTarget(cm.rhtg)
				e3:SetOperation(cm.rhop)
				e3:SetLabel(tp)
				e3:SetReset(RESET_PHASE+PHASE_END)
				yc:RegisterEffect(e3)
				yc=yg:GetNext()
			end
		end
	end
end
function cm.rhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and c:IsAbleToExtra() and c:GetControler()==e:GetLabel() and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,tp,LOCATION_HAND)
end
function cm.rhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()==0 then return end
	if Duel.SendtoExtraP(c,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,c)
		if sg:GetCount()~=0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end