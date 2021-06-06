--幻异梦境-黑白世界
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400049.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--self to deck & activate field
	yume.AddYumeFieldGlobal(c,71400049,1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400049,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c71400049.con1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(c71400049.tg1)
	e1:SetOperation(c71400049.op1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400049,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c71400049.con2)
	e2:SetTarget(c71400049.tg2)
	e2:SetOperation(c71400049.op2)
	c:RegisterEffect(e2)
end
function c71400049.op1(e,tp,eg,ep,ev,re,r,rp)
	local cnt=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if cnt<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then cnt=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71400049.filter1,tp,LOCATION_HAND,0,1,cnt,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local syng=Duel.GetMatchingGroup(c71400049.synfilter,tp,LOCATION_EXTRA,0,nil)
	if syng:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71400049,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local syn=syng:Select(tp,1,1,nil):GetFirst()
		Duel.SynchroSummon(tp,syn,nil)
	end
end
function c71400049.filter1(c,e,tp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400049.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71400049.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,0)
end
function c71400049.con1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
--Select Synchro Monsters
function c71400049.synfilter(c)
	return c:IsSetCard(0x717) and c:IsSpecialSummonable(SUMMON_TYPE_SYNCHRO)
end
--Synchro Summon Filter
function c71400049.synfilter2(c)
	return c:IsSetCard(0x714) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c71400049.con2(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c71400049.synfilter2,nil)
	return ct>0
end
function c71400049.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
end
function c71400049.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=eg:FilterCount(c71400049.synfilter2,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c71400049.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	ct=math.min(ct,ft,g:GetCount())
	if ct<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,ct,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end