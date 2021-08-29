--机舰钢战-大和号
function c82557944.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),8,3)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--reduce tribute
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(82557944,4))
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetTargetRange(LOCATION_HAND,0)
	e7:SetCode(EFFECT_SUMMON_PROC)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,82557844)
	e7:SetCondition(c82557944.ntcon)
	e7:SetTarget(c82557944.nttg)
	c:RegisterEffect(e7)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82557944,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c82557944.negcon)
	e2:SetCost(c82557944.cost)
	e2:SetTarget(c82557944.negtg)
	e2:SetOperation(c82557944.negop)
	c:RegisterEffect(e2)
	--material
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(82557944,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,82557944)
	e6:SetTarget(c82557944.oltg)
	e6:SetOperation(c82557944.olop)
	c:RegisterEffect(e6)
end
function c82557944.ntcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c82557944.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsRace(RACE_MACHINE)
end
function c82557944.tfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function c82557944.negcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c82557944.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c82557944.cfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_XYZ)
end
function c82557944.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayGroup():IsExists(c82557944.cfilter,1,nil,e,tp)
	 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local csp=e:GetHandler():GetOverlayGroup():Filter(c82557944.cfilter,nil,e,tp)
	local sp=csp:Select(tp,1,1,nil)
	if Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)~=0 then return true end
end
function c82557944.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c82557944.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c82557944.olfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsLevel(7)
end
function c82557944.oltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsRace(RACE_MACHINE) and chkc:IsLevel(7) end
	if chk==0 then return Duel.IsExistingTarget(c82557944.olfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c82557944.olfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c82557944.olop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end