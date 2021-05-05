--混沌No.98 绝望皇龙 霍普勒斯德拉古恩
function c40009413.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,3,c40009413.ovfilter,aux.Stringid(40009413,0),3,c40009413.xyzop)
	c:EnableReviveLimit() 
	--negate activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009413,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c40009413.condition)
	e1:SetCost(c40009413.cost)
	e1:SetTarget(c40009413.target)
	e1:SetOperation(c40009413.operation)
	c:RegisterEffect(e1) 
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009413,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_BATTLE_START)
	e2:SetCountLimit(1,40009413)
	e2:SetCondition(c40009413.spcon)
	e2:SetTarget(c40009413.sptg)
	e2:SetOperation(c40009413.spop)
	c:RegisterEffect(e2)  
end
c40009413.xyz_number=98
function c40009413.cfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c40009413.ovfilter(c)
	return c:IsFaceup() and c:IsCode(55470553)
end
function c40009413.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009413.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c40009413.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c40009413.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER)
end
function c40009413.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009413.thfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c40009413.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009413.thfilter,rp,LOCATION_ONFIELD,0,1,nil) end
end
function c40009413.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c40009413.repop)
end
function c40009413.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,c40009413.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c40009413.spcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f)
end
function c40009413.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c40009413.spcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c40009413.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c40009413.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f) and c:IsCanOverlay()
end
function c40009413.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e)
		and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.GetMatchingGroup(c40009413.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			if not tc:IsImmuneToEffect(e) and not tc:IsType(TYPE_TOKEN) then
			local og=tc:GetOverlayGroup()
				if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
				end
			Duel.Overlay(c,Group.FromCards(tc))
			end
			tc=g:GetNext()
		end
	end
end



