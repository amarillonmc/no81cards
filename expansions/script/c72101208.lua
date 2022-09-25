--深空 神之恩赐
function c72101208.initial_effect(c)

	--jiansuo guaishou
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72101208,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,72101209+EFFECT_COUNT_CODE_OATH)
	e2:SetOperation(c72101208.jsop)
	c:RegisterEffect(e2)

	 --extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72101208,2))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcea))
	c:RegisterEffect(e3)

	 --shen weifengkangxing
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(1)
	e4:SetCondition(c72101208.godcon)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)

	--fang zhishiwu tongzhao
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetRange(LOCATION_SZONE)
	e6:SetOperation(c72101208.zswop)
	c:RegisterEffect(e6)
	--fang zhishiwu tezhao
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)



end

--jiansuo guaishou
function c72101208.filter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_LIGHT)) and (not c:IsSummonableCard()) and c:IsAbleToHand()
end
function c72101208.jsop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c72101208.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(72101208,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c72101208.tzlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c72101208.tzlimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DIVINE)
end

--shen weifengkangxing
function c72101208.sfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0xcea) and c:IsAttribute(ATTRIBUTE_DIVINE)
end
function c72101208.godcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c72101208.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

--fang zhishiwu
function c72101208.zswfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:GetOriginalAttribute()==ATTRIBUTE_DIVINE) and c:IsSetCard(0xcea)
end
function c72101208.zswop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c72101208.zswfilter,nil)
	if ct>0 then
		
		if e:GetHandler():AddCounter(0x7210,ct,true) 
			and Duel.IsPlayerCanDraw(tp,1)
			and Duel.IsCanRemoveCounter(tp,1,1,0x7210,1,REASON_EFFECT)
			and Duel.SelectYesNo(tp,aux.Stringid(72101208,1)) then
			Duel.RemoveCounter(tp,1,1,0x7210,1,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end


