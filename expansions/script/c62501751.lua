--蚀痕无命 环誓天咒
function c62501751.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xea4),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),1,1,true)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c62501751.splimit)
	c:RegisterEffect(e0)
	--spsummon
	local se0=Effect.CreateEffect(c)
	se0:SetType(EFFECT_TYPE_FIELD)
	se0:SetCode(EFFECT_SPSUMMON_PROC)
	se0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	se0:SetRange(LOCATION_EXTRA)
	--se0:SetValue(SUMMON_TYPE_FUSION)
	se0:SetCondition(c62501751.sprcon)
	se0:SetTarget(c62501751.sprtg)
	se0:SetOperation(c62501751.sprop)
	c:RegisterEffect(se0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62501751,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,62501751)
	e1:SetCondition(c62501751.thcon)
	e1:SetTarget(c62501751.thtg)
	e1:SetOperation(c62501751.thop)
	c:RegisterEffect(e1)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,62501751+1)
	e4:SetTarget(c62501751.rmtg)
	e4:SetOperation(c62501751.rmop)
	c:RegisterEffect(e4)
	c62501751.remove_event_effect=e4
end
function c62501751.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c62501751.matfilter(c)
	return c:IsFacedown() and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
end
function c62501751.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetOwner()
	local mg=Duel.GetMatchingGroup(c62501751.matfilter,tp,LOCATION_REMOVED,0,nil)
	return #mg>=6 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c62501751.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(c62501751.matfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=mg:SelectSubGroup(tp,aux.TRUE,true,6,6,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c62501751.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	c:SetMaterial(mg)
	Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
	mg:DeleteGroup()
end
function c62501751.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function c62501751.rmfilter(c,tp)
	return c:IsSetCard(0xea4) and not c:IsCode(62501751) and c:IsFaceupEx() and c:IsAbleToRemoveAsCost(POS_FACEDOWN) and Duel.IsExistingMatchingCard(c62501751.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,c:GetType()&0x7)
end
function c62501751.thfilter(c,t)
	return not c:IsType(t) and c:IsSetCard(0xea4) and (c:IsFacedown() or not c:IsLocation(LOCATION_REMOVED))
end
function c62501751.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c62501751.rmfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,tp)
	if chk==0 then return #g>0 and e:IsCostChecked() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,c62501751.rmfilter,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,sg)
	Duel.Remove(sg,POS_FACEDOWN,REASON_COST)
	e:SetLabel(sg:GetFirst():GetType()&0x7)
end
function c62501751.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c62501751.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e:GetLabel()):GetFirst()
	if not tc then return end
	--Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	--if not tc:IsLocation(LOCATION_HAND) or not Duel.SelectYesNo(tp,aux.Stringid(28399999,2)) then return end
end
function c62501751.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,POS_FACEDOWN)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c62501751.gcheck(sg,tp)
	if sg:FilterCount(Card.IsControler,nil,1-tp)>1 then return false end
	local g=sg:Filter(Card.IsControler,nil,tp)
	return g:GetClassCount(Card.GetLocation)==#g and g:FilterCount(Card.IsOnField,nil)<=1
end
function c62501751.efilter(e)
	local ct=#c62501751.effect_list
	if e:GetCode()==EVENT_REMOVE and (e:GetType()&EFFECT_TYPE_SINGLE)==EFFECT_TYPE_SINGLE and e:IsActivated() then c62501751.effect_list[ct+1]=e end
	return false
end
function c62501751.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not c:IsSetCard(0xea4) or c:IsControler(1-tp) then return false end
	local te=c.remove_event_effect
	if not te then return false end
	local check=e:IsCostChecked()
	e:SetCostCheck(false)
	local tg=te:GetTarget()
	local res=not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
	--[[c62501751.effect_list={}
	c:IsOriginalEffectProperty(c62501751.efilter)
	for _,te in ipairs(c62501751.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	end]]
	e:SetCostCheck(check)
	return res
end
function c62501751.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,POS_FACEDOWN)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c62501751.gcheck,false,1,4,tp)
	if #sg==0 then return end
	Duel.ConfirmCards(1-tp,sg)
	if Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)==0 then return end
	--
	local og=Duel.GetOperatedGroup()
	if og:FilterCount(c62501751.cfilter,nil,e,tp,eg,ep,ev,re,r,rp)==0 or not Duel.SelectYesNo(tp,aux.Stringid(62501751,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=og:FilterSelect(tp,c62501751.cfilter,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	if not tc then return end
	Duel.BreakEffect()
	--[[c62501751.effect_list={}
	tc:IsOriginalEffectProperty(c62501751.efilter)
	local e_list={}
	for _,te in ipairs(c62501751.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then table.insert(e_list,te) end--if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(c62501751.effect_list,i) end
	end
	local te=e_list[1]
	if #e_list>1 then
		local des_list={}
		for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
		local op=Duel.SelectOption(tp,table.unpack(des_list))
		te=e_list[op+1]
	end
	c62501751.effect_list={}]]
	local te=tc.remove_event_effect
	--copy
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	e:SetProperty(EFFECT_FLAG_DELAY)--Original Property
end
