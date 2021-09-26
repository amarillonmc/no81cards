--异界歪魔 苏芳杏里咲
function c67200080.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,67200065,67200066,true,true)	
	--des spell&trap
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetCountLimit(1)
	e1:SetTarget(c67200080.destg)
	e1:SetOperation(c67200080.desop)
	c:RegisterEffect(e1)
	--send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200080,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,67200080)
	e2:SetCondition(c67200080.condition)
	e2:SetTarget(c67200080.target)
	e2:SetOperation(c67200080.operation)
	c:RegisterEffect(e2)
	--activate cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetCost(c67200080.costchk)
	e3:SetOperation(c67200080.costop)
	c:RegisterEffect(e3)
end
--
function c67200080.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c67200080.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c67200080.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c67200080.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c67200080.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c67200080.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
--
function c67200080.cfilter(c,tp,rp)
	return c:IsPreviousControler(tp) and c:GetPreviousTypeOnField()&TYPE_TRAP~=0
		and c:IsPreviousSetCard(0x673)
end
function c67200080.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200080.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function c67200080.tgfilter(c)
	return c:IsSetCard(0x673) and c:IsAbleToGrave()
end
function c67200080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200080.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c67200080.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67200080.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--
function c67200080.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,67200080)
	return Duel.CheckLPCost(tp,ct*500)
end
function c67200080.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
