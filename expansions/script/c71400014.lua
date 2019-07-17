--妄想梦境-梦幻图书馆
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400014.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400014,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c71400014.condition2)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c71400014.target2)
	e2:SetOperation(c71400014.operation2)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71400014,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c71400014.condition3)
	e3:SetTarget(c71400014.target3)
	e3:SetOperation(c71400014.operation3)
	c:RegisterEffect(e3)
	--self limitation & field activation
	yume.AddYumeFieldGlobal(c,71400014,1)
end
function c71400014.operation2(e,tp,eg,ep,ev,re,r,rp)
	local cnt=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if cnt<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then cnt=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71400014.filter2,tp,LOCATION_HAND,0,1,cnt,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local xyzg=Duel.GetMatchingGroup(c71400014.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if xyzg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71400014,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.BreakEffect()
		Duel.XyzSummon(tp,xyz,nil)
	end
end
function c71400014.filter2(c,e,tp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400014.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71400014.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
end
function c71400014.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c71400014.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c71400014.xyzfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c71400014.xyz2filter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
--Select Xyz Monsters
function c71400014.xyzfilter(c)
	return c:IsSetCard(0x715) and c:IsXyzSummonable(nil)
end
function c71400014.filter3(c)
	return c:IsSetCard(0x714) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c71400014.condition3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71400014.filter3,1,nil)
end
function c71400014.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--[[
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,1)
	--]]
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c71400014.operation3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	--local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	--Duel.Draw(p,d,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=g:Select(tp,1,1,nil)
		Duel.HintSelection(g)
		Duel.SendtoGrave(g:GetFirst(),REASON_EFFECT)
	end
end