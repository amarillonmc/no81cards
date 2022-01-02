--逆转的机壳
local m=29065901
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(m)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	if not cm.clfcheck then
		cm.clfcheck=true
		local ef2=Effect.CreateEffect(c)
		ef2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ef2:SetCode(EVENT_ADJUST)
		ef2:SetCondition(cm.con)
		ef2:SetOperation(cm.op)
		Duel.RegisterEffect(ef2,tp)
	end
end
function cm.setcheck(c,tp)
	return c:IsCode(51194046) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and c:IsType(TYPE_PENDULUM) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
end
function cm.activate(e,tp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.IsExistingMatchingCard(cm.setcheck,tp,LOCATION_DECK,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=Duel.SelectMatchingCard(tp,cm.setcheck,tp,LOCATION_DECK,0,1,1,nil,tp)
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function cm.replace(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xaa) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cm.check(c)
	return c:GetFlagEffect(m)==0 
end
function cm.con(e,tp)
	return Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_PZONE,0,1,nil) and Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),m)
end
function cm.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xaa)
end
function cm.op(e,tp)
	local rg=Duel.GetMatchingGroup(cm.check,tp,LOCATION_PZONE,0,nil)
	for tc in aux.Next(rg) do
		table_effect={}
		clffunc=Card.RegisterEffect
		Card.RegisterEffect=function(card,effect,flag)
			if effect and effect:GetCode()~=EFFECT_CANNOT_SPECIAL_SUMMON then
				local eff=effect:Clone()
				table.insert(table_effect,eff)
			end
			return clffunc(card,effect,flag)
		end
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0,0)
		Duel.CreateToken(tp,tc:GetOriginalCode())
		Card.RegisterEffect=clffunc
		local cid2=tc:ReplaceEffect(m+1,RESET_EVENT+RESETS_STANDARD,1)
		for key,eff in ipairs(table_effect) do
			Card.RegisterEffect(tc,eff,true)
		end
	end
end