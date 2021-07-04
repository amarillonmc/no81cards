--四糸乃 冰雪精灵
local m=33400517
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,cm.lcheck)
	c:EnableReviveLimit()  
	  --activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(cm.afilter))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.negcon)
	e3:SetCost(cm.negcost)
	e3:SetTarget(cm.negtg)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
 --special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.cost)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x6341,0x3344)
end

function cm.afilter(c)
	return c:IsSetCard(0x3344) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function cm.ckfilter1(c)
	return c:GetCounter(0x1015)~=0 and c:IsAbleToHandAsCost()
end
function cm.ckfilter(c)
	return c:IsSetCard(0x3344) and c:IsFaceup()
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return   not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)  and  Duel.IsChainNegatable(ev) 
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ckfilter1,tp,LOCATION_ONFIELD,0,1,nil) and (Duel.CheckLPCost(tp,1000) or Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil)) end
	local tg=Duel.SelectMatchingCard(tp,cm.ckfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoHand(tg,tp,REASON_COST)
   if not Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil)then Duel.PayLPCost(tp,1000)
	end
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:GetCounter(0x1015)~=0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp) 
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)then
		local ct=Duel.GetMatchingGroupCount(cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
		Duel.Destroy(eg,REASON_EFFECT)
		if ct~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) or Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	if not Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil)then Duel.PayLPCost(tp,1000)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x341) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and  Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		tc:AddCounter(0x1015,4)
	end
end
