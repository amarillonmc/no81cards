--天空漫步者-狭路奇袭
function c9910242.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9910242.condition)
	e1:SetTarget(c9910242.target)
	e1:SetOperation(c9910242.activate)
	c:RegisterEffect(e1)
end
function c9910242.cfilter(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsRace(RACE_PSYCHO))
end
function c9910242.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9910242.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910242.filter(c)
	if not c:IsFaceup() or not c:IsType(TYPE_LINK) then return false end
	local ct=c:GetLinkedGroup():FilterCount(Card.IsAbleToRemove,nil)
	return ct>0
end
function c9910242.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910242.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910242.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c9910242.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local lg=tc:GetLinkedGroup():Filter(Card.IsAbleToRemove,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,lg,lg:GetCount(),0,0)
	if tc:GetMutualLinkedGroupCount()>0 then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_REMOVE)
		e:SetLabel(0)
	end
	if Duel.GetCurrentChain()>2 then Duel.SetChainLimit(c9910242.chainlm) end
end
function c9910242.chainlm(e,rp,tp)
	return tp==rp
end
function c9910242.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local lg=tc:GetLinkedGroup():Filter(Card.IsAbleToRemove,nil)
	if lg:GetCount()>0 and Duel.Remove(lg,POS_FACEUP,REASON_EFFECT)~=0
		and e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(9910242,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
