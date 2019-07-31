--窥屏02
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=65010013
local cm=_G["c"..m]
cm.card_code_list={65010001}
function cm.initial_effect(c)
	local e1=rsef.QO(c,EVENT_CHAINING,{m,0},{1,m},"neg","dsp,dcal",LOCATION_HAND,rscon.negcon(cm.filterfun,true),rscost.cost(Card.IsDiscardable,"dish"),cm.tg,cm.op)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE+LOCATION_MZONE)
	e2:SetCountLimit(1,m+100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2) 
end
function cm.filterfun(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(rscf.FilterFaceUp(Card.IsCode,65010001),tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsChainNegatable(ev)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(65010001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=rsef.SV_LIMIT({e:GetHandler(),g:GetFirst()},"atk",nil,nil,rsreset.est_pend)
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end