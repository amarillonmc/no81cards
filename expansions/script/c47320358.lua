-- 新昼地的新黎明号
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,47320301,47320357)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5c17),4,3,s.ovfilter,aux.Stringid(id,0),3,s.xyzop)
	s.move_destroy(c)
	s.attach_effect(c)
	s.protection_effect(c)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(47320357)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_COST+REASON_DISCARD)
end

function s.move_destroy(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
    e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.descon)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_MZONE)
		and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=tp)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local cg=e:GetHandler():GetColumnGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_ONFIELD,1,nil,cg) end
    local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desfilter(c,cg)
	return c:IsFaceup() and cg:IsContains(c)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil,cg)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end

function s.attach_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id-1000)
	e3:SetTarget(s.attg)
	e3:SetOperation(s.atop)
	c:RegisterEffect(e3)
end

function s.atfilter(c)
	return aux.IsCodeListed(c,47320301) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end

function s.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.atfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.atfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,s.atfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end

function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsCanOverlay() then
		Duel.Overlay(c,Group.FromCards(tc))
	end
end

function s.protection_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetCondition(s.protcon)
	e4:SetTarget(s.prottg)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(aux.indoval)
	c:RegisterEffect(e5)
end

function s.protcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,47320357)
end

function s.prottg(e,c)
    local cg=e:GetHandler():GetColumnGroup()
    local ec=e:GetHandler()
	return ec or c:IsControler(e:GetHandlerPlayer()) and cg:IsContains(c)
end
