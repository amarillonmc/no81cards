--愚者总按两遍铃
function c60159953.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60159953,3))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCondition(c60159953.e1con)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60159953,4))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c60159953.e1con2)
	c:RegisterEffect(e1)

	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60159953,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c60159953.e2con)
	c:RegisterEffect(e2)

	--1xg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60159953,1))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c60159953.e3con)
	e3:SetCost(c60159953.e3cost)
	e3:SetTarget(c60159953.e3tg)
	e3:SetOperation(c60159953.e3op)
	c:RegisterEffect(e3)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60159953,2))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c60159953.e3con2)
	e3:SetCost(c60159953.e3cost)
	e3:SetTarget(c60159953.e3tg2)
	e3:SetOperation(c60159953.e3op2)
	c:RegisterEffect(e3)
end

	--Activate
function c60159953.e1con(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c60159953.e1con2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end

	--act in hand
function c60159953.e2con(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end

	--1xg
function c60159953.e3con(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c60159953.e3con2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c60159953.e3cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c60159953.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function c60159953.e3tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function c60159953.e3op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c60159953.e3op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) then
			re:GetHandler():CancelToGrave()
			Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		else
			Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end