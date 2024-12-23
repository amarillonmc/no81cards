--剑灵龙啸
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
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
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
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADJUST)
	e7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetLabelObject(c)
	e7:SetOperation(cm.regop2)
	Duel.RegisterEffect(e7,tp)
	Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,2)
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	local code=sc:GetOriginalCode()
	local g=Duel.GetFieldGroup(0,LOCATION_MZONE,LOCATION_MZONE):Filter(function(c) return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_DRAGON) and c:IsSummonableCard() and c:GetFlagEffect(m)==0 end,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(sc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DUAL_SUMMONABLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCondition(function() return Duel.GetFlagEffect(0,m)>0 end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(sc)
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
		local e4=Effect.CreateEffect(sc)
		e4:SetType(EFFECT_TYPE_FIELD)
		if code==11451881 then
			e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e4:SetValue(function(e,c) return c:GetSummonType()&SUMMON_TYPE_NORMAL==0 end)
		elseif code==11451882 then
			e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e4:SetValue(function(e,re,rp) return not re:GetHandler():IsLocation(LOCATION_MZONE) or re:GetHandler():GetSummonType()&SUMMON_TYPE_NORMAL==0 end)
		elseif code==11451883 then
			e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e4:SetValue(function(e,re,rp) return not re:GetHandler():IsLocation(LOCATION_MZONE) or re:GetHandler():GetSummonType()&SUMMON_TYPE_NORMAL==0 end)
		end
		e4:SetRange(LOCATION_MZONE)
		e4:SetTargetRange(LOCATION_MZONE,0)
		e4:SetCondition(aux.IsDualState)
		e4:SetTarget(function(e,c) return c:GetOriginalType()&TYPE_NORMAL>0 end)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4,true)
		--summon
		local e5=Effect.CreateEffect(sc)
		e5:SetDescription(aux.Stringid(code,0))
		e5:SetCategory(CATEGORY_SUMMON)
		e5:SetType(EFFECT_TYPE_QUICK_O)
		e5:SetCode(EVENT_FREE_CHAIN)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCountLimit(1)
		e5:SetCondition(aux.IsDualState)
		if code==11451883 then 
			e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
		end
		e5:SetCost(sc.spcost)
		e5:SetTarget(sc.sptg)
		e5:SetOperation(sc.spop)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(sc)
		e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_SUMMON_SUCCESS)
		e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		e6:SetOperation(function() 
							tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,0))
							tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,1))
						end)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e6,true)
	end
end
function cm.costfilter(c)
	return c:IsSetCard(0xa976) and c:IsAbleToGraveAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,true,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,true,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc then
		Duel.Summon(tp,tc,true,nil)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.adjustop)
		e1:SetLabelObject(e:GetLabelObject())
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
	local tc=e:GetLabelObject()
	if tc and aux.GetValueType(tc)=="Card" and tc:IsType(TYPE_SPELL) then
		local te=tc:GetActivateEffect()
		if not te then return end
		local tg=te:GetTarget()
		if (not tg or (tg and tg(te,tp,eg,ep,ev,re,r,rp,0))) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local op=te:GetOperation()
			if op then op(te,tp,eg,ep,ev,re,r,rp) end
		end
	end
end
function cm.adjustop2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te and aux.GetValueType(te)=="Effect" then te:Reset() end
end