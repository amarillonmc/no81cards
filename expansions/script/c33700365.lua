--虚拟YouTuber的暴走
function c33700365.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c33700365.cost)
	e1:SetTarget(c33700365.target)
	e1:SetOperation(c33700365.activate)
	c:RegisterEffect(e1)
end
function c33700365.cost(e)
	e:SetLabel(100)
	return true
end
function c33700365.tgfilter(c,tc)
	return c:IsFaceup() and c:IsSetCard(0x445) and not c:IsCode(tc:GetCode())
end
function c33700365.cfilter(c)
	return c:IsSetCard(0x445) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and Duel.IsExistingTarget(c33700365.tgfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c)
end
function c33700365.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33700365.tgfilter(chkc) end
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c33700365.cfilter,tp,LOCATION_EXTRA,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c33700365.cfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	Duel.SendtoGrave(tc,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33700365.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tc)
	e:SetValue(tc:GetCode())
end
function c33700365.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		tc:CopyEffect(e:GetValue(),RESET_EVENT+RESETS_STANDARD)
	end
end
