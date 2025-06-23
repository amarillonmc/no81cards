--策略 人事交易 经理
function c65809111.initial_effect(c)
	--search and spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65809111,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCost(c65809111.spcost)
	e1:SetTarget(c65809111.sptg)
	e1:SetOperation(c65809111.spop)
	c:RegisterEffect(e1)
	--activate cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_ACTIVATE_COST)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(LOCATION_HAND)
	e0:SetTargetRange(1,1)
	e0:SetTarget(c65809111.chktg)
	e0:SetOperation(c65809111.chkop)
	c:RegisterEffect(e0)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65809111,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c65809111.cpcon)
	e2:SetCost(c65809111.cpcost)
	e2:SetTarget(c65809111.cptg)
	e2:SetOperation(c65809111.cpop)
	e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
end
function c65809111.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c65809111.thfilter(c)
	return c:IsSetCard(0xca30) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65809111.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65809111.thfilter,tp,LOCATION_DECK,0,2,nil)
		and Duel.IsPlayerCanSpecialSummon(tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetMZoneCount(1-tp,nil,tp)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function c65809111.spfilter(c,e,tp)
	return c:IsSetCard(0xca30) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c65809111.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c65809111.thfilter,tp,LOCATION_DECK,0,2,2,nil)
	if tg:GetCount()~=2 then return end
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	Duel.ShuffleHand(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetMZoneCount(1-tp,nil,tp)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c65809111.spfilter,tp,LOCATION_HAND,0,2,2,nil,e,tp)
	Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP)
end
function c65809111.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and e:GetLabelObject():GetLabel()==1
end
function c65809111.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() or c:IsDiscardable() end
	if c:IsDiscardable() and (c:IsPublic() or Duel.SelectOption(tp,aux.Stringid(65809111,2),aux.Stringid(65809111,3))==1) then
		Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	else
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(66)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c65809111.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=re:GetTarget()
	if chk==0 then return (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) end-- and e:IsCostChecked()
	e:SetProperty(re:GetProperty())
	local tg=re:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	re:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(re)
	Duel.ClearOperationInfo(0)
end
function c65809111.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c65809111.chktg(e,te,tp)
	e:SetLabelObject(te)
	return true
end
function c65809111.chkop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	if te:GetActivateLocation()==LOCATION_MZONE and not tc:IsAttack(tc:GetBaseAttack()) then e:SetLabel(1) else e:SetLabel(0) end
end
