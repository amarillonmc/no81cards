if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local m=10130002
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsqd.FlipFun(c,m,"sp",cm.tg,cm.op)
	local e2=rsef.FTO(c,EVENT_FLIP,{m,1},{1,m+100},"sp","de,dsp",LOCATION_HAND,cm.spcon,nil,rsop.target(cm.spfilter,"sp"),cm.spop)
	cm.QuantumDriver_EffectList={e1,e2}
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if #g<=0 then return end
	if not g:IsExists(rsqd.SetFilter,1,nil,e,tp) or not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=g:FilterSelect(tp,rsqd.SetFilter,1,1,nil,e,tp):GetFirst()
	rsqd.SetFun(tc,e,tp)
end
function cm.spcon(e,tp,eg)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
		Duel.ConfirmCards(1-tp,c)
	end
end