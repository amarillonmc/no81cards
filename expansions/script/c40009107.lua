--守护天使的补给
function c40009107.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--decrease tribute
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(40009107,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetCountLimit(1,40009107)
	e0:SetCondition(c40009107.ntcon)
	e0:SetTarget(c40009107.nttg)
	c:RegisterEffect(e0) 
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009107,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,40009146)
	e2:SetCondition(c40009107.drcon)
	e2:SetTarget(c40009107.drtg)
	e2:SetOperation(c40009107.drop)
	c:RegisterEffect(e2)  
end
function c40009107.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c40009107.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsRace(RACE_FAIRY)
end
function c40009107.cfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0xf27)
		and c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c40009107.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40009107.cfilter,1,nil,tp)
end
function c40009107.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c40009107.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,2,REASON_EFFECT)
end