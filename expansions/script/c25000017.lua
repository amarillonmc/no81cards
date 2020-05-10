--双子斯菲亚
if not pcall(function() require("expansions/script/c25000011") end) then require("script/c25000011") end
local m,cm=rscf.DefineCard(25000017)
function cm.initial_effect(c)
	local e1=rsef.SV_CHANGE(c,"code",25000014)
	e1:SetRange(LOCATION_MZONE)
	local e2=rsgs.FusTypeFun(c,m,TYPE_LINK)
	local e3=rsef.QO(c,EVENT_CHAINING,{m,1},{1,m+200},"neg,des,sp","dsp,dcal",LOCATION_HAND+LOCATION_GRAVE,rscon.negcon(cm.cfilter,true),nil,cm.negtg,cm.negop)
end
function cm.cfilter(e,tp,re,rp,tg,loc,seq) 
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and re:GetHandler():GetSummonLocation()&LOCATION_EXTRA ~=0
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=aux.ExceptThisCard(e)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 and c then
		rssf.SpecialSummon(c)
	end
end