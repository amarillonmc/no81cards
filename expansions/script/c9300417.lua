--替身使者-辻彩
function c9300417.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9300417+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9300417.sprcon)
	c:RegisterEffect(e1)
	--change1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9300417,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+CATEGORY_TOGRAVE)
	e2:SetCountLimit(1,9300417)
	e2:SetCost(c9300417.cost)
	e2:SetTarget(c9300417.chtg)
	e2:SetOperation(c9300417.chop)
	c:RegisterEffect(e2)
	--change2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9300417,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+CATEGORY_TODECK)
	e3:SetCountLimit(1,9301417)
	e3:SetCost(c9300417.cost2)
	e3:SetTarget(c9300417.chtg2)
	e3:SetOperation(c9300417.chop2)
	c:RegisterEffect(e3)
end
function c9300417.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x1f99) and c:GetCode()~=9300415
end
function c9300417.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9300417.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c9300417.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c9300417.cfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,0,1,nil,c)
end
function c9300417.cfilter(c,tc)
	return (c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_ONFIELD) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() --and (not c:IsCode(tc:GetCode()) or not c:IsAttribute(tc:GetAttribute()))
end
function c9300417.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c9300417.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9300417.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9300417.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9300417.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c9300417.chop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c9300417.cfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tc)
	if cg:GetCount()==0 then return end
	Duel.SendtoGrave(cg,REASON_EFFECT)
	local ec=cg:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(ec:GetCode())
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(ec:GetAttribute())
	tc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c9300417.aclimit)
	e3:SetLabel(ec:GetCode())
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
		if tc:IsOriginalSetCard(0x1f99) then
		local e4=Effect.CreateEffect(tc)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ADD_SETCODE)
		e4:SetValue(0x1f99)
		tc:RegisterEffect(e4)
   end
end
function c9300417.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end
function c9300417.filter2(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c9300417.cfilter2,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c)
end
function c9300417.cfilter2(c,tc)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() --and not c:IsCode(tc:GetCode()) 
end
function c9300417.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c9300417.chtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9300417.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9300417.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9300417.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c9300417.chop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local cg=Duel.SelectMatchingCard(tp,c9300417.cfilter2,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tc)
	if cg:GetCount()==0 then return end
	Duel.SendtoDeck(cg,nil,2,REASON_EFFECT)
	local ec=cg:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(ec:GetCode())
	tc:RegisterEffect(e1)
		if tc:IsOriginalSetCard(0x1f99) then
		local e4=Effect.CreateEffect(tc)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ADD_SETCODE)
		e4:SetValue(0x1f99)
		tc:RegisterEffect(e4)
	  end
end
