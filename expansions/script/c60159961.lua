--诡计精灵
function c60159961.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,3,2,nil,nil,99)
	
	--1xg
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c60159961.attval)
	c:RegisterEffect(e1)
	
	--2xg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c60159961.indval1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c60159961.indval2)
	c:RegisterEffect(e3)
	
	--3xg
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60159961,0))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(TIMING_DAMAGE_STEP)
	e4:SetCountLimit(1,60159961)
	e4:SetCost(c60159961.matcost)
	e4:SetTarget(c60159961.mattg)
	e4:SetOperation(c60159961.matop)
	c:RegisterEffect(e4)
end

	--1xg
function c60159961.effilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c60159961.attval(e,c)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local wg=og:Filter(c60159961.effilter,nil)
	local wbc=wg:GetFirst()
	local att=0
	while wbc do
		att=att|wbc:GetAttribute()
		wbc=wg:GetNext()
	end
	return att
end

	
	--2xg
function c60159961.indval1(e,c)
	return c:GetBattleTarget():GetAttribute()&c:GetAttribute()~=0
end
function c60159961.indval2(e,re,rp)
	if not (rp==1-e:GetHandlerPlayer() and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)) then return false end
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsControler(rp) and (rc:IsFaceup() or not rc:IsLocation(LOCATION_MZONE)) then
		return e:GetHandler():IsAttribute(rc:GetAttribute())
	else
		return e:GetHandler():IsAttribute(rc:GetOriginalAttribute())
	end
end

	--3xg
function c60159961.matcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60159961.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c60159961.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c60159961.matfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c60159961.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c60159961.matfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
			local sc2=g:GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(math.max(sc2:GetBaseAttack(),sc2:GetBaseDefense()))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	end
end