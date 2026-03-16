local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,2,2)
	c:EnableReviveLimit()
	--Effect 1: Negate Hand effect and Attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.negcon1)
	e1:SetTarget(s.negtg1)
	e1:SetOperation(s.negop1)
	c:RegisterEffect(e1)
	--Effect 2: Negate Field/GY effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetCondition(s.negcon2)
	e2:SetCost(s.negcost2)
	e2:SetTarget(s.negtg2)
	e2:SetOperation(s.negop2)
	c:RegisterEffect(e2)
end
function s.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsXyzLevel(xyzc,6)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetAttribute)==1 and g:GetClassCount(Card.GetCode)==2
end
function s.negcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	-- 对方把手卡的怪兽的效果发动，且对方手卡比这张卡素材多
	return ep==1-tp and loc==LOCATION_HAND and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsChainNegatable(ev)
		and Duel.GetFieldGroupCount(ep,LOCATION_HAND,0)>c:GetOverlayCount()
end
function s.negtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.negop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and c:IsRelateToEffect(e) and c:IsType(TYPE_XYZ) then
		-- 那个发动无效，那只怪兽或对方墓地1只怪兽作为这张卡的超量素材
		-- 候补：对方墓地怪兽
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCanOverlay),tp,0,LOCATION_GRAVE,nil,c)
		-- 候补：那只怪兽(rc)。如果rc不在墓地(例如仍在手卡)，手动加入候补。
		-- 如果rc在墓地，已经被g包含(除非被NecroValley排除，那样也不应被选)。
		if rc:IsRelateToEffect(re) and rc:IsCanOverlay() and not rc:IsLocation(LOCATION_GRAVE) then
			g:AddCard(rc)
		end
		
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sg=g:Select(tp,1,1,nil)
			if #sg>0 then
				Duel.Overlay(c,sg)
			end
		end
	end
end
function s.negcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	-- 对方手卡比这张卡素材少，对方把场上·墓地的怪兽效果发动
	return ep==1-tp and (loc==LOCATION_MZONE or loc==LOCATION_GRAVE) and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsChainNegatable(ev)
		and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)<c:GetOverlayCount()
end
function s.negcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.negtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.negop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end