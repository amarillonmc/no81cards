--虚体
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174072)
function cm.initial_effect(c)
	aux.AddFusionProcFunRep(c,cm.ffilter,2,false) 
	local e1=rsef.SV_UPDATE(c,"atk",cm.atkval)
	local e2=rsef.SV(c,EFFECT_DIRECT_ATTACK)
	local e3=rsef.FC(c,EVENT_CHAINING,nil,nil,nil,LOCATION_MZONE,cm.cecon1,cm.ceop1)
	local e4=rsef.FC(c,EVENT_CHAIN_SOLVING,nil,nil,nil,LOCATION_MZONE,cm.cecon2,cm.ceop2)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return not sg or (sg:FilterCount(Card.IsLevelAbove,nil,1)==#sg and not sg:IsExists(Card.IsRace,1,c,c:GetRace()) and not  sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()) and not sg:IsExists(Card.IsLevel,1,c,c:GetLevel()))
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(rscf.fufilter(Card.IsCode,m),0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*2000
end
function cm.cecon1(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasCategory(CATEGORY_FUSION_SUMMON)
end
function cm.ceop1(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.cecon2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetFlagEffect(m)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,re,tp) and e:GetHandler():GetFlagEffect(m+100)==0
end
function cm.spfilter(c,e,tp)
	return c:IsCode(m) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
end
function cm.ceop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,0)) then return end
	c:RegisterFlagEffect(m+100,rsreset.est_pend,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.rep_op)
end
function cm.rep_op(e,tp,eg,ep,ev,re,r,rp)
	rshint.Card(m)
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,{SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP,nil,{"mat","cp"}},e,tp)
end
