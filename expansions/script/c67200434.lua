--术结天怨魔 兹纳米亚
function c67200434.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcCodeFun(c,67200432,c67200434.fmfilter,1,true,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_ONFIELD,0,Duel.Release,nil,REASON_MATERIAL)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200434,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c67200434.tdtg)
	e1:SetOperation(c67200434.tdop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)   
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200434,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,67200434)
	e3:SetTarget(c67200434.thtg)
	e3:SetOperation(c67200434.thop)
	c:RegisterEffect(e3) 
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200434,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c67200434.pencon)
	e4:SetTarget(c67200434.pentg)
	e4:SetOperation(c67200434.penop)
	c:RegisterEffect(e4)   
end
function c67200434.fmfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
--
function c67200434.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(Card.IsAbleToHand,nil)
	if chk==0 then return g:GetCount()>0 and c:IsAbleToHand() end
	g:AddCard(c)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c67200434.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(Card.IsRelateToEffect,nil,e)
	if c:IsRelateToEffect(e) and g:GetCount()>0 then
		g:AddCard(c)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
--
function c67200434.filter(c)
	return c:IsCode(67200435) and c:IsSSetable()
end
function c67200434.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200434.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200434.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c67200434.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc then
			Duel.SSet(tp,tc)
		end
	end
end
--
function c67200434.pencon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c67200434.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200434.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end