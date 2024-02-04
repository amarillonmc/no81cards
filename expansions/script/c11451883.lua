--龙剑灵装
--23.06.14
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DUAL_SUMMONABLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(aux.IsDualState)
		e2:SetValue(TYPE_NORMAL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		tc:RegisterEffect(e3,true)
		--indes
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e4:SetRange(LOCATION_MZONE)
		e4:SetTargetRange(LOCATION_MZONE,0)
		e4:SetCondition(aux.IsDualState)
		e4:SetTarget(function(e,c) return c:GetOriginalType()&TYPE_NORMAL>0 end)
		e4:SetValue(function(e,re,rp) return not re:GetHandler():IsLocation(LOCATION_MZONE) or re:GetHandler():GetSummonType()&SUMMON_TYPE_NORMAL==0 end)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4,true)
		--summon
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(m,0))
		e5:SetCategory(CATEGORY_SUMMON+CATEGORY_DRAW+CATEGORY_LEAVE_GRAVE+CATEGORY_TODECK)
		e5:SetType(EFFECT_TYPE_QUICK_O)
		e5:SetCode(EVENT_FREE_CHAIN)
		e5:SetRange(LOCATION_MZONE)
		e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e5:SetCountLimit(1)
		e5:SetCondition(aux.IsDualState)
		e5:SetCost(cm.spcost)
		e5:SetTarget(cm.sptg)
		e5:SetOperation(cm.spop)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e5,true)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
		Duel.SpecialSummonComplete()
	end
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.tgfilter(c,tp)
	return c:IsAbleToDeck() and (not c:IsType(TYPE_NORMAL) or Duel.IsPlayerCanDraw(tp))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,true,nil) and Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,true,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		Duel.Summon(tp,tc,true,nil)
		local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		sg:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetCountLimit(1)
		e1:SetLabelObject(sg)
		e1:SetOperation(cm.adjustop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SUMMON_NEGATED)
		e2:SetLabelObject(e1)
		e2:SetOperation(cm.adjustop2)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	if sg and aux.GetValueType(sg)=="Group" then
		sg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		if #sg==0 then return end
		local ng=sg:Filter(Card.IsType,nil,TYPE_NORMAL)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		og=Group.__band(og,ng)
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
function cm.adjustop2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te and aux.GetValueType(te)=="Effect" then te:Reset() end
end