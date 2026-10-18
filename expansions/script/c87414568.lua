--噬魂龙 君主阿尔比昂
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3)
	c:EnableReviveLimit()

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)

	--①
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.matcost)
	e1:SetTarget(s.mattg)
	e1:SetOperation(s.matop)
	c:RegisterEffect(e1)

	--②
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.discon)
	e2:SetCost(s.discost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end

function s.matcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	if chk==0 then return ct>0 and c:CheckRemoveOverlayCard(tp,ct,REASON_COST) end
		local g=c:GetOverlayGroup()
		Duel.SendtoGrave(g,REASON_EFFECT)
end

function s.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) 
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 
		and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=3 end
end

function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<3 then return end

	local g1=Duel.GetDecktopGroup(tp,3)
	local g2=Duel.GetDecktopGroup(1-tp,3)

	g1:Merge(g2)

	Duel.DisableShuffleCheck()
	Duel.Overlay(c,g1)
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end

function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,5,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,5,5,REASON_COST)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local attr=0
	if rc:IsRelateToEffect(re) then
		attr=rc:GetAttribute()
	else
		attr=rc:GetOriginalAttribute()
	end
	
	if chk==0 then 
		return attr~=0 and Duel.IsExistingMatchingCard(function(c,a) return c:IsFaceup() and c:IsAttribute(a) end,tp,0,LOCATION_MZONE,1,nil,attr) 
	end
	
	e:SetLabel(attr)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)

	local g=Duel.GetMatchingGroup(function(c,a) return c:IsFaceup() and c:IsAttribute(a) end,tp,0,LOCATION_MZONE,nil,attr)
	if #g>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
	end
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		local attr=e:GetLabel()
		if attr and attr~=0 then
			local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsAttribute(attr) end,tp,0,LOCATION_MZONE,nil)
			if #g>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end