--尤利西斯
local m=25000001
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
cm.codelist={EFFECT_CANNOT_SPECIAL_SUMMON,EFFECT_CANNOT_SUMMON,EFFECT_CANNOT_FLIP_SUMMON,EFFECT_CANNOT_ACTIVATE,EFFECT_CANNOT_MSET,EFFECT_CANNOT_SSET,EFFECT_SPSUMMON_COUNT_LIMIT,EFFECT_ACTIVATE_COST,EFFECT_SUMMON_COST,EFFECT_MSET_COST,EFFECT_SSET_COST,EFFECT_FLIPSUMMON_COST,EFFECT_MAX_MZONE,EFFECT_MAX_SZONE,EFFECT_LEFT_SPSUMMON_COUNT,EFFECT_DEVINE_LIGHT,EFFECT_LIMIT_SPECIAL_SUMMON_POSITION,59822133,63060238,97148796,29724053,92345028,67120578}
function cm.con(e,tp)
	return Duel.GetFlagEffect(tp,m)==0
end
function cm.op(e,tp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,m)
	Duel.ConfirmCards(1-tp,c)
	Duel.RegisterFlagEffect(tp,m,0,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(cm.hapeop)
	Duel.RegisterEffect(e1,0)
	EFFECT_MUST_USE_MZONE = 0
	EFFECT_FORBIDDEN = 0
	EFFECT_DISABLE_FIELD = 0
	EFFECT_USE_EXTRA_MZONE = 0
	EFFECT_USE_EXTRA_SZONE = 0
	for tc in aux.Next(Duel.GetMatchingGroup(nil,tp,0x1ff,0x1ff,nil)) do
		local code=tc:GetOriginalCode()
		Card.ReplaceEffect(tc,code,nil)
	end
	function Duel.SetChainLimit(...)
		return
	end
	function Duel.SetChainLimitTillChainEnd(...)
		return
	end
end
function cm.hapeop(e)
	for p=0,1 do
		for _,val in pairs(cm.codelist) do
			for _,ae in pairs({Duel.IsPlayerAffectedByEffect(p,val)}) do
				if ae:GetType()&EFFECT_TYPE_SINGLE==0 then
					ae:SetCondition(aux.FALSE)
				end
			end
		end
	end
end