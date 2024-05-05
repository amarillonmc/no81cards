--红锈龙 消融龙

local id=32000218
local zd=0xff6
function c32000218.initial_effect(c)
	--XyzSummon
	aux.AddXyzProcedureLevelFree(c,c32000218.xyzfilter,c32000218.xyzcheck,2,2)
	c:EnableReviveLimit()
	
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c32000218.e1tg)
	e1:SetValue(c32000218.e1val)
	e1:SetOperation(c32000218.e1op)
	c:RegisterEffect(e1)

    --SPSUMMON
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(c32000218.e2cost)
	e2:SetTarget(c32000218.e2tg)
	e2:SetOperation(c32000218.e2op)
	c:RegisterEffect(e2)

	
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c32000218.tglimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)

end

--XyzSummon
function c32000218.xyzfilter(c)
	return c:IsLevelAbove(0)
end

function c32000218.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==g:GetCount() and g:IsExists(Card.IsSetCard,1,nil,zd)
end

--e1

function c32000218.e1filter(c,tp)
	return c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:IsSetCard(zd)
end
function c32000218.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()  
	if chk==0 then return eg:IsExists(c32000218.e1filter,1,nil,tp)
		and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) and rp==1-tp end
	return Duel.SelectEffectYesNo(tp,c,96)
end

function c32000218.e1val(e,c)
	return c32000218.e1filter(c,e:GetHandlerPlayer())
end
function c32000218.e1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
end

--e2
function c32000218.e2spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsSetCard(zd) or c:IsType(TYPE_XYZ) and c:IsRankBelow(4))
end

function c32000218.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,2,REASON_EFFECT) end
	 Duel.RemoveOverlayCard(tp,1,0,2,2,REASON_EFFECT)
end

function c32000218.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c32000218.e2spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end

function c32000218.e2op(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c32000218.e2spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp))
	then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32000218.e2spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	
	if not (Card.IsType(g:GetFirst(),TYPE_XYZ) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,1,nil))
 then return end
	local g2=Duel.GetDecktopGroup(tp,1)
	if g2:GetCount()==1 then
		Duel.DisableShuffleCheck()
		Duel.Overlay(g:GetFirst(),g2)
	end
	
end


--e3

function c32000218.tglimit(e,c)
	return c:IsSetCard(zd)
end




