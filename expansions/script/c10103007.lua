--界限龙 布内
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10103007
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_HAND+LOCATION_MZONE,nil,nil,cm.rittg,cm.ritop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"des","de,tg",nil,nil,rstg.target(aux.TRUE,"des",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.desop)
	cm.rs_ghostdom_dragon_effect={e1,e2}
end
function cm.desop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.ritfilter(c,e,tp,m1)
	if not c:IsSetCard(0x1337) or c:GetType()&0x81~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,c:GetLevel(),"Equal")
	local res=mg:CheckSubGroup(cm.mfilter,1,c:GetLevel(),c,e:GetHandler())
	aux.GCheckAdditional=nil
	return res
end
function cm.mfilter(g,ritc,matc)
	return g:IsContains(matc) and Duel.GetMZoneCount(tp,g,tp)>0 and aux.RitualCheckGreater(g,ritc,ritc:GetLevel())
end
function cm.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsRace,nil,RACE_DRAGON)
		return Duel.IsExistingMatchingCard(cm.ritfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,mg1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.ritop(e,tp,eg,ep,ev,re,r,rp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsRace,nil,RACE_DRAGON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.ritfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,mg1):GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		Duel.SetSelectedCard(c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectSubGroup(tp,cm.mfilter,false,1,99,tc,c)
		aux.GCheckAdditional=nil
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end