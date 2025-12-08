--阳炎兽 奇美拉
local m=22348465
local cm=_G["c"..m]
xpcall(function() require("expansions/script/123") end,function() require("script/123") end)
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348465,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,22348465)
	e1:SetTarget(c22348465.ovtg)
	e1:SetOperation(c22348465.ovop)
	c:RegisterEffect(e1)
	--cannot be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22348465.etcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348465,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	--e3:SetCost(c22348465.atkcost)
	e3:SetTarget(c22348465.atktg)
	e3:SetOperation(c22348465.atkop)
	c:RegisterEffect(e3)
end
function c22348465.ovfilter(c)
	return c:IsSetCard(0x107d) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c22348465.xfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c22348465.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348465.ovfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c22348465.xfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c22348465.ovop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c22348465.xfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c22348465.ovfilter,tp,LOCATION_DECK,0,1,1,nil)
	if not g or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local xc=Duel.SelectMatchingCard(tp,c22348465.xfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	Duel.HintSelection(Group.FromCards(xc))
	Duel.Overlay(xc,g)
end
function c22348465.etcon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c22348465.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) end
end
function c22348465.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(Card.IsType,nil,TYPE_MONSTER)
	if not c:IsRelateToEffect(e) or c:IsFacedown() or not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if not tc then return end
	Duel.SendtoGrave(tc,REASON_EFFECT)
	Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(tc:GetRace())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(tc:GetAttribute())
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(math.ceil(tc:GetAttack()/2))
	c:RegisterEffect(e3)
end
