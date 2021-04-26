--蚀异梦境-幻想植物回路
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400032.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400032,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c71400032.con1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(c71400032.tg1)
	e1:SetOperation(c71400032.op1)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400032,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c71400032.con2)
	e2:SetTarget(c71400032.tg2)
	e2:SetOperation(c71400032.op2)
	c:RegisterEffect(e2)
	--self limitation & field activation
	yume.AddYumeFieldGlobal(c,71400032,2)
end
function c71400032.op1(e,tp,eg,ep,ev,re,r,rp)
	local cnt=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if cnt<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then cnt=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71400032.filter1,tp,LOCATION_HAND,0,1,cnt,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local lnkg=Duel.GetMatchingGroup(c71400032.lnkfilter,tp,LOCATION_EXTRA,0,nil)
	if lnkg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71400032,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local lnk=lnkg:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummonRule(tp,lnk,SUMMON_TYPE_LINK)
	end
end
function c71400032.filter1(c,e,tp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400032.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71400032.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,0)
end
function c71400032.con1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
--Select Link Monsters
function c71400032.lnkfilter(c)
	return c:IsSetCard(0x716) and c:IsSpecialSummonable(SUMMON_TYPE_LINK)
end
function c71400032.con2(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return eg:GetCount()==1 and ec:IsSetCard(0x714) and ec:IsSummonType(SUMMON_TYPE_LINK)
end
function c71400032.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function c71400032.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c71400032.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)==1 then
		local g2=Duel.SelectMatchingCard(tp,c71400032.filter2a,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
			Duel.BreakEffect()
			Duel.SetLP(tp,Duel.GetLP(tp)-500)
		end
	end
end
function c71400032.filter2(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c71400032.filter2a(c)
	return c:IsSetCard(0xd714) and c:IsAbleToHand()
end