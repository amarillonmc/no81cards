--X伙伴 搏斗兽
function c16364305.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c16364305.mfilter,nil,2,2)
	--get effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16364305,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,16364305)
	e1:SetTarget(c16364305.xyztg)
	e1:SetOperation(c16364305.xyzop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16364305,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,16364305+1)
	e2:SetCondition(c16364305.descon)
	e2:SetTarget(c16364305.destg)
	e2:SetOperation(c16364305.desop)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16364305,3))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_XMATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c16364305.tdcon)
	e3:SetTarget(c16364305.tdtg)
	e3:SetOperation(c16364305.tdop)
	c:RegisterEffect(e3)
end
function c16364305.mfilter(c,xyzc)
	return c:IsLevelAbove(1) and c:IsSetCard(0xdc3)
end
function c16364305.matfilter(c)
	return c:IsSetCard(0xdc3) and c:IsType(TYPE_XYZ) and c:IsCanOverlay()
end
function c16364305.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if chk==0 then return ct>0 and e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c16364305.matfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c16364305.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if ct<1 then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c16364305.matfilter,tp,LOCATION_EXTRA,0,1,ct,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c16364305.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_EXTRA) and c:IsPreviousControler(tp)
end
function c16364305.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16364305.cfilter,1,nil,tp)
end
function c16364305.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c16364305.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c16364305.tdfilter(c,tp)
	return c:IsType(TYPE_XYZ) and c:IsPreviousSetCard(0xdc3) and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsLocation(LOCATION_EXTRA)
end
function c16364305.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16364305.tdfilter,1,nil,tp)
end
function c16364305.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD)
end
function c16364305.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.HintSelection(g)
	if #g>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end