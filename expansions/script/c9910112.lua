--战车道装甲·保时捷虎式
require("expansions/script/c9910106")
function c9910112.initial_effect(c)
	--xyz summon
	Zcd.AddXyzProcedure(c,nil,6,2,c9910112.xyzfilter,aux.Stringid(9910112,0),99)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910112,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c9910112.imcost)
	e1:SetTarget(c9910112.imtg)
	e1:SetOperation(c9910112.imop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910112,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c9910112.descon)
	e2:SetTarget(c9910112.destg)
	e2:SetOperation(c9910112.desop)
	c:RegisterEffect(e2)
end
function c9910112.xyzfilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x952) and c:IsFaceup()))
		and c:GetLevel()==6
end
function c9910112.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910112.ctfilter(c,tp)
	local seq=c:GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c9910112.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910112.ctfilter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c9910112.ctfilter,tp,LOCATION_MZONE,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910112.ctfilter,tp,LOCATION_MZONE,0,1,1,c,tp)
end
function c9910112.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function c9910112.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsLocation(LOCATION_MZONE) or tc:IsControler(1-tp) then return end
	local seq=tc:GetSequence()
	if seq>4 then return end
	if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) then
		local zone=0
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then zone=bit.replace(zone,0x1,seq-1) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then zone=bit.replace(zone,0x1,seq+1) end
		zone=bit.bxor(zone,0xff)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,zone)
		local nseq=math.log(s,2)
		Duel.MoveSequence(c,nseq)
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(c9910112.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
function c9910112.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetPreviousControler()==tp
end
function c9910112.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9910112.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
