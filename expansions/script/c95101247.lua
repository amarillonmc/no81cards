--终焉失控磁盘 星球毁灭武装
function c95101247.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6bb0),aux.FilterBoolFunction(Card.IsFusionType,TYPE_FUSION),2,true)
	c:EnableReviveLimit()
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101247,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c95101247.postg)
	e1:SetOperation(c95101247.posop)
	c:RegisterEffect(e1)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetDescription(aux.Stringid(95101247,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c95101247.poscon)
	e2:SetTarget(c95101247.postg2)
	e2:SetOperation(c95101247.posop2)
	c:RegisterEffect(e2)
	--attack effect:remove monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95101247,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c95101247.rmcon1)
	e3:SetTarget(c95101247.rmtg1)
	e3:SetOperation(c95101247.rmop1)
	c:RegisterEffect(e3)
	--defense effect:remove spell
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95101247,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c95101247.rmcon2)
	e4:SetTarget(c95101247.rmtg2)
	e4:SetOperation(c95101247.rmop2)
	c:RegisterEffect(e4)
end
function c95101247.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c95101247.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local res=Duel.TossCoin(tp,1)
	if res==1 then Duel.ChangePosition(c,POS_FACEUP_ATTACK)
	else Duel.ChangePosition(c,POS_FACEUP_DEFENSE) end
end
function c95101247.poscon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2--Duel.IsMainPhase()
end
function c95101247.postg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c95101247.posop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
function c95101247.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackPos() and ep==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c95101247.rmfilter(c,tp,typ)
	return c:IsType(typ) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c95101247.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c95101247.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil,tp,TYPE_MONSTER)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c95101247.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c95101247.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil,tp,TYPE_MONSTER)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c95101247.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsDefensePos() and ep==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c95101247.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c95101247.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tp,TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c95101247.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c95101247.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tp,TYPE_SPELL+TYPE_TRAP)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
