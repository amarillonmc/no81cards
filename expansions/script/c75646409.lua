--暧昧小鹿 鹿乃
function c75646409.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,c75646409.ovfilter,aux.Stringid(75646409,0),2,c75646409.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c75646409.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c75646409.defval)
	c:RegisterEffect(e2)
	--top
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75646409,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,75646409)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c75646409.cost)
	e3:SetTarget(c75646409.target)
	e3:SetOperation(c75646409.operation)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c75646409.tg)
	e5:SetOperation(c75646409.op)
	c:RegisterEffect(e5)
end
function c75646409.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x32c4) and c:IsType(TYPE_SYNCHRO+TYPE_FUSION+TYPE_RITUAL)
end
function c75646409.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,75646409)==0 end
	Duel.RegisterFlagEffect(tp,75646409,RESET_PHASE+PHASE_END,0,1)
end
function c75646409.atkfilter(c)
	return c:IsSetCard(0x32c4) and c:GetAttack()>=0
end
function c75646409.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c75646409.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c75646409.deffilter(c)
	return c:IsSetCard(0x32c4) and c:GetDefense()>=0
end
function c75646409.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c75646409.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c75646409.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c75646409.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x32c4)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c75646409.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75646402,0))
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x32c4)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
function c75646409.filter(c,e,tp)
	return c:IsSetCard(0x32c4) and c:GetPreviousControler()==tp
		and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_COST) and c:IsCanBeEffectTarget(e) and not c:IsForbidden()
end
function c75646409.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c75646409.filter(chkc,e,tp) end
	if chk==0 then return re and re:GetHandler()~=e:GetHandler() and re:IsHasType(0x7f0) and eg:IsExists(c75646409.filter,1,nil,e,tp) end
	local g=eg:Filter(c75646409.filter,nil,e,tp)
	local tc=nil
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tc=g:Select(tp,1,1,nil):GetFirst()
	else
		tc=g:GetFirst()
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c75646409.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end