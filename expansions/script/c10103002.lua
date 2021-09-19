--界限龙王 努特
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10103002
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	c:EnableReviveLimit()  
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_MZONE,nil,rscost.rmxyz(1),rstg.target(rsop.list(cm.spfilter,"sp",LOCATION_GRAVE+LOCATION_HAND)),cm.spop)
	local e2=rsef.I(c,{m,1},{1,m+100},"sp",nil,LOCATION_MZONE,cm.spcon2,cm.spcost2,rstg.target(rsop.list(cm.spfilter2,"sp",LOCATION_DECK)),cm.spop2)
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end 
function cm.spop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end 
function cm.spcon2(e,tp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x337)
end
function cm.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetAttackAnnouncedCount()==0
		and c:CheckRemoveOverlayCard(tp,2,REASON_COST) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	c:RemoveOverlayCard(tp,2,2,REASON_COST)
end
function cm.spfilter2(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsSetCard(0x337) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spop2(e,tp)
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg>0 then
		rssf.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,nil,rssf.SummonBuff({0,0}))
	end
end