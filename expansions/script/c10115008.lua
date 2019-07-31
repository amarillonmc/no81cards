--炼金生命体·守序
if not pcall(function() require("expansions/script/c10115001") end) then require("script/c10115001") end
local m=10115008
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.spcon,cm.spop)
	local e2=rsab.MaterialGainEffectFun(c,m,"des,sp",rstg.target(rsop.list({cm.desfilter,"des",true},{cm.spfilter,"sp",LOCATION_EXTRA })),cm.matop)
end
function cm.spcfilter(c)
	return c:IsSetCard(0x3331) and not c:IsPublic()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_HAND,0,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.spcfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function cm.desfilter(c)
	return c:IsDestructable() and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function cm.spfilter(c,e,tp)
	return not c:IsCode(e:GetHandler():GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x3330)
end
function cm.matop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or Duel.Destroy(c,REASON_EFFECT)<=0 or Duel.GetLocationCountFromEx(tp)<=0 then return end
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #sg>0 then
		rssf.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,nil,rssf.SummonBuff({0,0}))
	end
end