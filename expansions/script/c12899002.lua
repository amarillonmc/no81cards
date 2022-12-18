--H.P.K.-001
local m=12899002
local cm=_G["c"..m]
function cm.initial_effect(c)
	  c:EnableReviveLimit()
 --cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,m)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.spcon1)
	e2:SetTarget(cm.sptg1)
	e2:SetOperation(cm.spop1)
	c:RegisterEffect(e2)
  --negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+10000)
	e3:SetCondition(cm.negcon)
	e3:SetCost(cm.negcost)
	e3:SetTarget(cm.negtg)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
end
function cm.ckfilter(c)
	return ((not c:IsSetCard(0x5a71)) and c:IsFaceup()) or c:IsFacedown()
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetTurnPlayer()==1-tp and rp==tp  and re:GetHandler():IsSetCard(0x6a71) and not Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP_DEFENSE)
	end
end

function cm.ckfilter3(c)
	return  c:IsSetCard(0x5a71) and c:IsFaceup()
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)   
		and Duel.IsChainNegatable(ev) and ep==1-tp and not Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(cm.ckfilter3,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if  re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
end