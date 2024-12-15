--混沌幻神之影
function c98500302.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,10000000,10000010,10000020)
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionCode,10000020,10000000,10000010),c98500302.ffilter,1,2,true)
	aux.AddContactFusionProcedure(c,c98500302.cfilter,LOCATION_HAND+LOCATION_MZONE,0,c98500302.sprop(c))
	--CANNOT_BE_FUSION_MATERIAL
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e1)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e7)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98500302,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98500302)
	e2:SetTarget(c98500302.drtg)
	e2:SetOperation(c98500302.drop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98500302,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98510303)
	e3:SetCost(c98500302.spcost)
	e3:SetTarget(c98500302.sptg)
	e3:SetOperation(c98500302.spop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98500302,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,98510303)
	e4:SetCost(c98500302.spcost)
	e4:SetTarget(c98500302.fustg)
	e4:SetOperation(c98500302.fusop)
	c:RegisterEffect(e4)
end
function c98500302.ffilter(c)
	return c:IsRace(RACE_DIVINE) or c:IsAttribute(ATTRIBUTE_DIVINE)
end
function c98500302.sprop(c)
	return function(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
		local cg=g:Filter(Card.IsPreviousLocation,nil,LOCATION_MZONE)
		local tc=cg:GetFirst()
		while tc do
			local code=tc:GetOriginalCode()
			c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,1)
			tc=cg:GetNext()
		end
	end
end
function c98500302.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_HAND)
end
function c98500302.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sc=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sc,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end
function c98500302.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98500302.filter(c,e,tp)
	return (c:IsCode(10000020,10000000,10000010) or aux.IsCodeListed(c,10000020,10000000) or aux.IsCodeListed(c,10000010)) and c:IsLevelBelow(10) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c98500302.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c98500302.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c98500302.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98500302.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
end
function c98500302.filter1(c,e)
	return c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c98500302.filter2(c,e,tp,m,chkf)
	return not c:IsCode(98500302) and c98500302.ffilter(c) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:CheckFusionMaterial(m,nil,chkf,true)
end
function c98500302.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp|0x200
		local mg=Duel.GetMatchingGroup(c98500302.filter1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil,e)
		return Duel.IsExistingMatchingCard(c98500302.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,chkf)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98500302.fusop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp|0x200
	local mg=Duel.GetMatchingGroup(c98500302.filter1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil,e)
	local sg=Duel.GetMatchingGroup(c98500302.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,chkf)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf,true)
		Duel.SendtoDeck(mat,nil,2,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
