--星宫守护神·露娜蒂亚
function c72421460.initial_effect(c)
	-- Xyz Summon 
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x9728),4,2)
	c:EnableReviveLimit()
	-- (1) 主要阶段去除超量素材特召
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72421460,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,72421460)
	e1:SetCondition(c72421460.spcon)
	e1:SetCost(c72421460.spcost)
	e1:SetTarget(c72421460.sptg)
	e1:SetOperation(c72421460.spop)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
	
	-- (2) 墓地除外回收+除外对方卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72421460,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,72421461) 
	e2:SetCost(c72421460.rmcost)
	e2:SetTarget(c72421460.rmtg)
	e2:SetOperation(c72421460.rmop)
	c:RegisterEffect(e2)
end

function c72421460.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c72421460.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c72421460.spfilter(c,e,tp)
	return c:IsSetCard(0x9728) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c72421460.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c72421460.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c72421460.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c72421460.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

-- 效果②cost：从墓地除外自身
function c72421460.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

-- 效果②目标：回收5张+除外对方卡
function c72421460.tdfilter(c)
	return c:IsSetCard(0x9728) and c:IsAbleToDeck()
end
function c72421460.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72421460.tdfilter,tp,LOCATION_GRAVE,0,5,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c72421460.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c72421460.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if #g>=5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,5,5,nil)
		if Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
			-- 选择对方场上1张卡
			local fc=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
			-- 选择对方墓地1张卡
			local gc=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
			local banishGroup=Group.CreateGroup()
			
			if #fc>0 and Duel.SelectYesNo(tp,aux.Stringid(72421460,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local tc=fc:Select(tp,1,1,nil):GetFirst()
				banishGroup:AddCard(tc)
			end
			
			if #gc>0 and Duel.SelectYesNo(tp,aux.Stringid(72421460,3)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sc=gc:Select(tp,1,1,nil):GetFirst()
				banishGroup:AddCard(sc)
			end
			
			if #banishGroup>0 then
				Duel.Remove(banishGroup,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end