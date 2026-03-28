--剑装拓展模组 鸫
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),4,2,nil,nil,99)
	c:EnableReviveLimit()
	--不可作为超量素材限制（超量召唤的回合）
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(1)
	e0:SetCondition(s.xyzlimit)
	c:RegisterEffect(e0)

	--①：特召成功，吸素材（手墓除外2张 -> 可选场上1张）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.mattg)
	e1:SetOperation(s.matop)
	c:RegisterEffect(e1)

	--②：二速堆墓或除外
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(s.tgcost)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)

end
--------------------------------------------------------------------------------
-- 限制：超量召唤的回合不能作为素材
--------------------------------------------------------------------------------
function s.xyzlimit(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsStatus(STATUS_SPSUMMON_TURN)
end

--------------------------------------------------------------------------------
-- ①效果
--------------------------------------------------------------------------------

--过滤器：手卡/墓地/除外的机械族怪兽
function s.matfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end

function s.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
end

function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsType(TYPE_XYZ) then return end
	local g=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #g<2 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:Select(tp,2,2,nil)
	Duel.Overlay(c,sg)
		local fg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
		if #fg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local tcg=fg:Select(tp,1,1,nil)
			if #tcg>0 and not tcg:GetFirst():IsImmuneToEffect(e) then
				Duel.HintSelection(tcg)
				local og=tcg:GetFirst():GetOverlayGroup()
				if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
				end
				Duel.Overlay(c,tcg)
			end
		end
end

--------------------------------------------------------------------------------
-- ②效果
--------------------------------------------------------------------------------

function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end

function s.tgfilter(c)
	return c:IsSetCard(0x610) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3)) --请选择要操作的卡
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToGrave()
		local b2=tc:IsAbleToRemove()
		local op=0
		
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4)) --"送去墓地", "除外"
		elseif b1 then
			op=0
		else
			op=1
		end
		
		if op==0 then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end