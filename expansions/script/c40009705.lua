--极光战姬 阿嘉拉罗格
function c40009705.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xbf1b),3,2)
	c:EnableReviveLimit()   
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009705,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40009705)
	e1:SetCondition(c40009705.xccon1)
	e1:SetTarget(c40009705.xctg)
	e1:SetOperation(c40009705.xcop)
	c:RegisterEffect(e1) 
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c40009705.xccon2)
	c:RegisterEffect(e3)
	if not c40009705.global_check then
		c40009705.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetLabel(40009705)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end  
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40009705,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,40009706)
	e4:SetCondition(c40009705.spcon1)
	e4:SetCost(c40009705.spcost)
	e4:SetTarget(c40009705.sptg)
	e4:SetOperation(c40009705.spop)
	c:RegisterEffect(e4) 
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCondition(c40009705.spcon2)
	c:RegisterEffect(e5) 
end
function c40009705.xccon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetFlagEffect(40009705)>0 and not Duel.IsPlayerAffectedByEffect(tp,40009707)
end
function c40009705.xccon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetFlagEffect(40009705)>0 and Duel.IsPlayerAffectedByEffect(tp,40009707)
end
function c40009705.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,40009707)
end
function c40009705.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,40009707)
end
function c40009705.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanOverlay()
end
function c40009705.xctgfilter(c)
	return c:IsFaceup() and c:IsCode(40009623) 
end
function c40009705.xctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c40009705.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009705.desfilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c40009705.xctgfilter,tp,LOCATION_FZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c40009705.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c40009705.xcop(e,tp,eg,ep,ev,re,r,rp)
	local g0=Duel.GetMatchingGroup(c40009705.xctgfilter,tp,LOCATION_FZONE,0,nil)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if g0:GetCount()>0 and tg:GetCount()>0 then
		local g2=Duel.SelectMatchingCard(tp,c40009705.xctgfilter,tp,LOCATION_FZONE,0,1,1,nil)
		Duel.HintSelection(g2)
		local tc=g2:GetFirst()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,Group.FromCards(tg))
	end
end
function c40009705.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009705.spfilter(c,e,tp)
	return c:IsSetCard(0xbf1b) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009705.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c40009705.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40009705.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c40009705.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c40009705.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end