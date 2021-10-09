--三途之河领航人
function c9980322.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c9980322.lcheck)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9980322.atkcon)
	e1:SetOperation(c9980322.atkop)
	c:RegisterEffect(e1)
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c9980322.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980322,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,9980322)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9980322.setcon)
	e1:SetTarget(c9980322.settg)
	e1:SetOperation(c9980322.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c9980322.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x6bcc)
end
function c9980322.lkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bcc)
end
function c9980322.indcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c9980322.lkfilter,1,nil)
end
function c9980322.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9980322.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local atk=0
	local tc=g:GetFirst()
	while tc do
		local lk=tc:GetLink()+tc:GetLevel()
		atk=atk+lk
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk*300)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c9980322.setcfilter(c,tp,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsSetCard(0x6bcc) and c:IsFaceup() and c:IsControler(tp) and ec:GetLinkedGroup():IsContains(c)
	else
		return c:IsPreviousSetCard(0x6bcc) and c:IsPreviousPosition(POS_FACEUP)
			and c:GetPreviousControler()==tp and bit.extract(ec:GetLinkedZone(tp),c:GetPreviousSequence())~=0
	end
end
function c9980322.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9980322.setcfilter,1,nil,tp,e:GetHandler())
end
function c9980322.setfilter(c)
	return ((c:IsType(TYPE_SPELL) and c:IsSetCard(0x46)) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x6bcc))) and c:IsSSetable()
end
function c9980322.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9980322.setfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c9980322.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c9980322.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end