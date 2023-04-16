--无形王者代偿
local m=14000706
local cm=_G["c"..m]
function cm.initial_effect(c)
	--c:EnableReviveLimit()
	--limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_INITIAL)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(0xff)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.con(e,c)
	return not e:GetHandler():IsPublic()
end
function cm.sumfilter(c)
	return c:IsSummonableCard() and not c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
	if not c:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(tp,e:GetHandler())
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
	Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,1))
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.GetFirstMatchingCard(cm.sumfilter,tp,0xff,0xff,nil,tp)
	if tc then
		local zone=1<<0
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true,zone)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		--cannot summon
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_CANNOT_SUMMON)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e0:SetTargetRange(1,1)
		Duel.RegisterEffect(e0,0)
		Duel.Summon(tp,tc,true,nil,99)
		e0:Reset()
	end
end