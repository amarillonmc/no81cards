--黑钢国际·重装干员-雷蛇
function c79029043.initial_effect(c)
	c:EnableReviveLimit()
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029043.spcon)
	e1:SetTarget(c79029043.sptg)
	e1:SetCountLimit(1,79029043)
	e1:SetOperation(c79029043.spop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79029043.discon)
	e2:SetTarget(c79029043.distg)
	e2:SetOperation(c79029043.disop)
	c:RegisterEffect(e2)
	--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c79029043.reptg)
	e3:SetOperation(c79029043.repop)
	c:RegisterEffect(e3)
end
function c79029043.sprfilter(c)
	return c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_REMOVED) and c:IsSetCard(0x1904) and bit.band(c:GetOriginalType(),TYPE_TRAP)~=0 and c:IsAbleToGraveAsCost()
end
function c79029043.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>0
end
function c79029043.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c79029043.sprfilter,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(c79029043.fselect,2,2,tp)
end
function c79029043.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c79029043.sprfilter,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c79029043.fselect,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c79029043.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
function c79029043.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c79029043.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,eg,1,0,0)
end
function c79029043.disop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1099,1)
end
function c79029043.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_RULE)==0
		and Duel.GetCounter(tp,LOCATION_ONFIELD,nil,0x1099)>=5 end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),79029096) then
	return true
end
end
function c79029043.repop(e,tp,eg,ep,ev,re,r,rp,chk)
	 Duel.RemoveCounter(tp,1,0,0x1099,5,REASON_EFFECT+REASON_REPLACE)
end