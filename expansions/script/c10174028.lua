--堆栈大蛇
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10174028
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.spcon,cm.spop,nil,{1,m})
	local e2=rsef.FTO(c,EVENT_TO_GRAVE,{m,0},{1,m+100},"sp","de,dsp",LOCATION_GRAVE,nil,rscost.cost(Card.IsAbleToRemove,"rm"),cm.sptg2,cm.spop2)
end
function cm.spfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_COST)<=0 or not tc:IsLocation(LOCATION_REMOVED) then return end
	local att,race,code1,code2=tc:GetAttribute(),tc:GetRace(),tc:GetCode()
	local e1,e2,e3=rsef.SV_ADD(c,"linkatt,linkrace,linkcode",{att,race,code1},nil,rsreset.est-RESET_TOFIELD)
	if code2 then local e4=rsef.SV_ADD(c,"linkcode",code2,nil,rsreset.est-RESET_TOFIELD) end
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return #eg==1 and tc:IsReason(REASON_EFFECT+REASON_BATTLE) and tc:IsType(TYPE_LINK) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function cm.spop2(e,tp)
	local tc=rscf.GetTargetCard()
	if not tc or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	rssf.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,nil,{"dis,dise",1})
end
