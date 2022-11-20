--西洋棋阻塞战术
function c4455806.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--reduce tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4455806,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCondition(c4455806.ntcon)
	e2:SetTarget(c4455806.nttg)
	c:RegisterEffect(e2) 
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4455806,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetTarget(function(e,c) 
	return c.SetCard_YLchess end) 
	c:RegisterEffect(e3)
end
c4455806.SetCard_YLchess=true   
function c4455806.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c4455806.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsLevelBelow(7) and c.SetCard_YLchess
end









