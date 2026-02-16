--叛骨之盖加斯特
local s,id,o=GetID()
--string
s.named_with_Rebellion_Skull=1
--s.named_with_Skullize=1
--SETCARD_REBELLION_SKULL =0xdce
--SETCARD_SKULLIZE =0xdce
--string check
function s.Rebellion_Skull(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Rebellion_Skull) or (SETCARD_REBELLION_SKULL and c:IsSetCard(SETCARD_REBELLION_SKULL))
end
function s.Skullize(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Skullize) or (SETCARD_SKULLIZE and c:IsSetCard(SETCARD_SKULLIZE))
end
--
function s.initial_effect(c)
	--summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.sumcon)
	e0:SetTarget(s.sumtarget)
	e0:SetOperation(s.sumactivate)
	c:RegisterEffect(e0)
	--
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function s.sumtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonable(true,nil) end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end
function s.sumactivate(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(id)
	if e:GetHandler():IsSummonable(true,nil) then
		Duel.Summon(tp,e:GetHandler(),true,nil)
	end
end
function s.desfilter(c)
	return c:IsFaceup() and (c:IsLevelBelow(8) or not c:IsLevelAbove(1))
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp)
		and s.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
