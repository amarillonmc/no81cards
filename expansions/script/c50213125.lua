--Kamipro 苏尔
function c50213125.initial_effect(c)
	c:EnableCounterPermit(0xcbf)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50213125,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c50213125.ntcon)
	c:RegisterEffect(e1)
	--change level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c50213125.lvop)
	c:RegisterEffect(e2)
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetCode(EFFECT_SUMMON_COST)
	e22:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e22:SetOperation(c50213125.lvop2)
	c:RegisterEffect(e22)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,50213126)
	e3:SetCost(c50213125.tdcost)
	e3:SetTarget(c50213125.tdtg)
	e3:SetOperation(c50213125.tdop)
	c:RegisterEffect(e3)
	--attack counter 1
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCondition(c50213125.atccon)
	e4:SetOperation(c50213125.atcop)
	c:RegisterEffect(e4)
	--recover
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCost(c50213125.rccost)
	e5:SetTarget(c50213125.rctg)
	e5:SetOperation(c50213125.rcop)
	c:RegisterEffect(e5)
end
function c50213125.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c50213125.lvcon(e)
	return e:GetHandler():GetMaterialCount()==0
end
function c50213125.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c50213125.lvcon)
	e1:SetValue(4)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c50213125.lvcon2(e)
	return e:GetHandler():GetMaterialCount()>0
end
function c50213125.lvop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c50213125.lvcon2)
	e1:SetValue(6)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c50213125.costfilter(c)
	return c:IsSetCard(0xcbf) and c:IsAbleToGraveAsCost()
end
function c50213125.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50213125.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c50213125.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c50213125.cfilter(c,e,tp)
	return c:IsSummonPlayer(1-tp) and c:IsLocation(LOCATION_MZONE) and c:IsAbleToDeck()
		and (not e or c:IsRelateToEffect(e))
end
function c50213125.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c50213125.cfilter,1,nil,nil,tp) end
	local g=eg:Filter(c50213125.cfilter,nil,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c50213125.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c50213125.cfilter,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c50213125.atccon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c50213125.atcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0xcbf,1)
	end
end
function c50213125.rccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xcbf,10,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xcbf,10,REASON_COST)
end

function c50213125.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,5000)
end
function c50213125.rcop(e,tp,eg,ep,ev,re,r,rp)
	local p,rec=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,rec,REASON_EFFECT)
end