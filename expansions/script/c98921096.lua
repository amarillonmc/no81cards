--时钟指针蛇
function c98921096.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c98921096.mfilter,1)
	--to extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921096,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98921096)
	e2:SetTarget(c98921096.tetg)
	e2:SetOperation(c98921096.teop)
	c:RegisterEffect(e2)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921096,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(c98921096.atkcon)
	e2:SetTarget(c98921096.target)
	e2:SetOperation(c98921096.operation)
	c:RegisterEffect(e2)
end
function c98921096.mfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:IsRace(RACE_CYBERSE) and c:GetLink()>=2
end
function c98921096.tefilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK) and c:IsAbleToExtra() and Duel.IsExistingMatchingCard(c98921096.thfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetLink())
end
function c98921096.thfilter(c,lk)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_FUSION) and c:IsLevelBelow(lk*2)
end
function c98921096.tetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98921096.tefilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98921096.tefilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98921096.tefilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
end
function c98921096.teop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
		local lk=tc:GetLink()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c98921096.thfilter,tp,LOCATION_EXTRA,0,1,1,nil,lk)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c98921096.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_GRAVE)
end
function c98921096.posfilter(c)
	return c:IsCanChangePosition()
end
function c98921096.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98921096.posfilter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c98921096.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,s.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c98921096.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end