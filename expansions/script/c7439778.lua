--鹰身女妖的狩猎
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12206212)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(s.adjustop)
	c:RegisterEffect(e01)
	--change effect type
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_FIELD)
	e02:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e02:SetCode(id)
	e02:SetRange(LOCATION_SZONE)
	e02:SetTargetRange(1,0)
	c:RegisterEffect(e02)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x64)
end
function s.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0 or Duel.IsExistingMatchingCard(s.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.tffilter(c,tp)
	return c:IsCode(75782277) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.thfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsCode(76812113,12206212) and c:IsAbleToHand()
end
function s.sumfilter(c)
	return c:IsSetCard(0x64) and c:IsType(TYPE_MONSTER) and c:IsSummonable(true,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.tffilter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp)
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,7))
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tffilter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
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
	end
	local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
	if b2 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
		end
	end
	local b3=Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND,0,1,nil)
	if b3 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Summon(tp,g:GetFirst(),true,nil)
		end
	end
end
function s.actfilter(c)
	return c:GetOriginalCode()==75782277
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local g=Duel.GetMatchingGroup(s.actfilter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		eclone=Effect.Clone
		--for i,f in pairs(Effect) do Debug.Message(i) end
		Card.RegisterEffect=function(card,effect,flag)
			if effect and effect:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
				effect:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
					if chkc then return chkc:IsOnField() and (chkc:IsType(TYPE_SPELL+TYPE_TRAP) or Duel.IsPlayerAffectedByEffect(tp,id)) end
					if chk==0 then return true end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
					local g=Duel.SelectTarget(tp,(
						function(c) 
							return c:IsType(TYPE_SPELL+TYPE_TRAP) or Duel.IsPlayerAffectedByEffect(tp,id) 
						end)
					,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
					Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
				end)
			end
			return cregister(card,effect,flag)
		end
		for tc in aux.Next(g) do
			tc:ReplaceEffect(tc:GetOriginalCode(),0)
		end
		Card.RegisterEffect=cregister
	end
	e:Reset()
end
