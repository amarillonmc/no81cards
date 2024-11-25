--波提欧-扬尘孤星-
local cm,m,o=GetID()
function c60010077.initial_effect(c)
	aux.AddCodeList(c,60010029)
	--spsummon
	local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,60010077)
	e1:SetCondition(c60010077.spcon)
	e1:SetTarget(c60010077.sptg)
	e1:SetOperation(c60010077.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60010077,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c60010077.condition)
	e2:SetTarget(c60010077.target)
	e2:SetOperation(c60010077.operation)
	c:RegisterEffect(e2)
	--
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c60010077.defcon)
	e3:SetOperation(c60010077.defop)
	c:RegisterEffect(e3)
end
function c60010077.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_FZONE,0,1,nil)
end
function c60010077.filter(c,tp)
	return c:IsCode(60010029) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c60010077.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c60010077.filter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c60010077.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	--activate
	if Duel.IsExistingMatchingCard(c60010077.filter,tp,LOCATION_GRAVE,0,1,nil,tp) then
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60010077,1))
	local tc=Duel.SelectMatchingCard(tp,c60010077.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		if #g>0 then
			Duel.BreakEffect()
		end
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetValue(-800)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end

function c60010077.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return ep~=tp and not c:IsStatus(STATUS_BATTLE_DESTROYED) and c:GetCardTargetCount()==0
end
function c60010077.tgfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function c60010077.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c60010077.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60010077.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c60010077.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c60010077.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Group.FromCards(c,tc)
	if g:FilterCount(Card.IsRelateToEffect,nil,e)~=2 or g:FilterCount(Card.IsFaceup,nil)~=2 then return end
	c:SetCardTarget(tc)
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TARGET)
	e1:SetCode(EFFECT_SET_POSITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e2)
end
function c60010077.defcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetCardTargetCount()~=0
end
function c60010077.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetCardTarget()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end

function c60010077.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c60010077.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c60010077.defil,tp,0,LOCATION_MZONE,1,nil) then
		local tg=Duel.GetMatchingGroup(c60010077.defil,tp,0,LOCATION_MZONE,nil)
		local tc=tg:GetFirst()
		local val=-1000
		if Duel.IsPlayerAffectedByEffect(tp,60010133) then val=-4000 end
		for i=1,#tg do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(-1000)
			tc:RegisterEffect(e1)
			tc=tg:GetNext()
		end
	else
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end

function c60010077.spcfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsCode(60010029)
end








