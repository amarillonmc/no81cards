--第84届一等星讨论会！
function c28328484.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--field effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x284))
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--copy?
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28328484,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c28328484.cpcost)
	e3:SetTarget(c28328484.cptg)
	e3:SetOperation(c28328484.cpop)
	c:RegisterEffect(e3)
end
function c28328484.atkval(e,c)
	local lv=c:IsLevelAbove(1) and c:GetLevel() or c:GetRank()
	return lv*100
end
function c28328484.costfilter(c)
	return c:IsSetCard(0x284) and c:IsAbleToGraveAsCost()
end
function c28328484.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28328484.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28328484.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c28328484.efilter(e)
	local ct=#c28328484.effect_list
	if (e:IsHasRange(LOCATION_HAND) or e:GetCode()==EVENT_TO_HAND and (e:GetType()&EFFECT_TYPE_SINGLE)~=0) and e:IsActivated() then c28328484.effect_list[ct+1]=e end
	return false--e:IsHasRange(LOCATION_HAND) and e:IsActivated()
end
function c28328484.cpfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER)) then return false end
	c28328484.effect_list={}
	c:IsOriginalEffectProperty(c28328484.efilter)
	for _,te in ipairs(c28328484.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(te,tp,eg,ep,ev,re,r,rp,0) then return true end
	end
	return false
end
function c28328484.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28328484.cpfilter,tp,LOCATION_HAND,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
end
function c28328484.cpop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c28328484.cpfilter,tp,LOCATION_HAND,0,nil,e,tp,eg,ep,ev,re,r,rp)
	if #g==0 then return end
	local tc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	c28328484.effect_list={}
	tc:IsOriginalEffectProperty(c28328484.efilter)
	local e_list={}
	for _,te in ipairs(c28328484.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(te,tp,eg,ep,ev,re,r,rp,0) then table.insert(e_list,te) end--if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(c28328484.effect_list,i) end
	end
	local te=e_list[1]
	--[[if #e_list>1 then
		local des_list={}
		for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
		local op=Duel.SelectOption(tp,table.unpack(des_list))
		te=e_list[op+1]
	end]]--
	c28328484.effect_list={}
	--copy
	tc:CreateEffectRelation(e)--Card.IsRelateToChain
	tc:CreateEffectRelation(te)--Card.IsRelateToEffect
	local tg,op=te:GetTarget(),te:GetOperation()
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+28328484)
	e1:SetProperty(te:GetProperty())
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(tg)
	e1:SetOperation(op)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+28328484,e,REASON_EFFECT,tp,tp,0)
	--[[tc:CreateEffectRelation(e)--Card.IsRelateToChain
	tc:CreateEffectRelation(te)--Card.IsRelateToEffect
	local tg=te:GetTarget()
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	local op=te:GetOperation()
	if op then op(te,tp,eg,ep,ev,re,r,rp) end]]
end
