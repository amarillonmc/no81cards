--忘却之海
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000052)
function cm.initial_effect(c)
	c:EnableCounterPermit(0x34) 
	local e1=rsef.ACT(c,nil,nil,{1,m})
	e1:SetCondition(rscon.excard(Card.IsFacedown,LOCATION_REMOVED))
	e1:SetOperation(cm.act)
	local e4=rsef.QO(c,nil,{m,0},{1,m+100},"rm",nil,LOCATION_SZONE,nil,rscost.rmct(0x34,3),cm.rmtg,cm.rmop)
	local e5=rsef.QO(c,nil,{m,1},{1,m+100},"sp",nil,LOCATION_SZONE,nil,rscost.rmct(0x34,3),rsop.target(rssb.ssfilter(true),"sp",LOCATION_REMOVED),cm.spop)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function cm.act(e,tp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	if ct>0 then
		c:AddCounter(0x34,ct)
	end
end
function cm.ctfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR+RACE_FIEND) and c:GetSummonPlayer()==tp
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.ctfilter,1,nil,tp) then
		e:GetHandler():AddCounter(0x34,1)
	end
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,5)
	if chk==0 then return g:FilterCount(rssb.rmfilter,nil)==5 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function cm.rmop(e,tp)
	local g=Duel.GetDecktopGroup(tp,5)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function cm.spop(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	if #g<=0 then return end
	Duel.ConfirmCards(1-tp,g)
	rsop.SelectSpecialSummon(tp,rssb.ssfilter(true),tp,LOCATION_REMOVED,0,1,1,nil,{0,tp,tp,true,false,POS_FACEUP},e,tp)
end