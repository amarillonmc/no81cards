--蚀痕无命 因尤黛安
function c62501701.initial_effect(c)
	--effect
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,62501701,EVENT_REMOVE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62501701,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(custom_code)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(c62501701.efcon)
	e1:SetTarget(c62501701.eftg)
	e1:SetOperation(c62501701.efop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62501701,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,62501701)
	e2:SetTarget(c62501701.thtg)
	e2:SetOperation(c62501701.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,62501701+1)
	e4:SetTarget(c62501701.rmtg)
	e4:SetOperation(c62501701.rmop)
	c:RegisterEffect(e4)
	c62501701.remove_event_effect=e4
end
function c62501701.chkfilter(c,tp)
	return c:IsControler(tp) and c:IsFacedown()-- and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousLevelOnField()==3
end
function c62501701.efcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c62501701.chkfilter,1,nil,tp)
end
function c62501701.efilter(e)
	local ct=#c62501701.effect_list
	if e:GetCode()==EVENT_REMOVE and (e:GetType()&EFFECT_TYPE_SINGLE)==EFFECT_TYPE_SINGLE and e:IsActivated() then c62501701.effect_list[ct+1]=e end
	return false
end
function c62501701.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0xea4) and c:IsControler(tp) and not c:IsHasEffect(62501701)) then return false end-- and c:IsLocation(LOCATION_REMOVED) and c:IsFacedown()
	local te=c.remove_event_effect
	if not te then return false end
	--Debug.Message(c:GetCode())
	local check=e:IsCostChecked()
	e:SetCostCheck(false)
	local tg=te:GetTarget()
	local res=not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
	--[[c62501701.effect_list={}
	c:IsOriginalEffectProperty(c62501701.efilter)
	for _,te in ipairs(c62501701.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then e:SetCostCheck(res) return true end
	end]]
	e:SetCostCheck(check)
	return res
end
function c62501701.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and eg:IsExists(c62501701.cfilter,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=eg:FilterSelect(tp,c62501701.cfilter,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmCards(1-tp,g)
	local code=g:GetFirst():GetCode()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(62501701)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,code))
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	Duel.SetTargetCard(g)
end
function c62501701.efop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	--[[c62501701.effect_list={}
	tc:IsOriginalEffectProperty(c62501701.efilter)
	local e_list={}
	for _,te in ipairs(c62501701.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then table.insert(e_list,te) end--if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(c62501701.effect_list,i) end
	end
	if #e_list==0 then return end
	local te=e_list[1]
	if #e_list>1 then
		local des_list={}
		for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
		local op=Duel.SelectOption(tp,table.unpack(des_list))
		te=e_list[op+1]
	end
	c62501701.effect_list={}]]
	local te=tc.remove_event_effect
	--copy
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	e:SetProperty(EFFECT_FLAG_DELAY)--Original Property
end
function c62501701.thfilter(c,chk)
	return c:IsSetCard(0xea4) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c)) and (c:IsFacedown() or not c:IsLocation(LOCATION_REMOVED))
end
function c62501701.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501701.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c62501701.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c62501701.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,1):GetFirst()
	if not tc then return end
	--Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or not c:IsAbleToHand() then return end
	if not tc:IsLocation(LOCATION_HAND) or not Duel.SelectYesNo(tp,aux.Stringid(62501701,2)) then return end
	Duel.BreakEffect()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
function c62501701.rmfilter(c,tp)
	return c:IsSetCard(0xea4) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c62501701.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501701.rmfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c62501701.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c62501701.rmfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	if rg:GetCount()>0 then
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	end
end
