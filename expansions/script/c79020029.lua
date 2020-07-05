--整合运动·宿主拾荒者
function c79020029.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2,nil,nil,99)
	c:EnableReviveLimit()  
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c79020029.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2) 
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCost(c79020029.cost)
	e3:SetCountLimit(1,79020029)
	e3:SetTarget(c79020029.contg)
	e3:SetOperation(c79020029.conop)
	c:RegisterEffect(e3)   
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c79020029.cost1)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c79020029.postg)
	e2:SetOperation(c79020029.posop)
	c:RegisterEffect(e2)
end
function c79020029.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c79020029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,35125879)==0 end
	Duel.RegisterFlagEffect(tp,35125879,RESET_CHAIN,0,1)
end
function c79020029.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,35125879)==0 
	and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) 
	Duel.RegisterFlagEffect(tp,35125879,RESET_CHAIN,0,1)
end
function c79020029.contg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetHandler():GetOverlayCount()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,x) and e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(x)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,x)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,x-1)
end
function c79020029.conop(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetHandler():GetOverlayCount()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==x then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
		if g:GetCount()==0 then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,x-1,x-1,nil)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
end
end
function c79020029.filter2(c,e,tp)
	return c:IsSetCard(0x3904) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c79020029.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c79020029.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79020029.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79020029.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		local mg=e:GetHandler():GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(e:GetHandler()))
		Duel.Overlay(sc,Group.FromCards(e:GetHandler()))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end



