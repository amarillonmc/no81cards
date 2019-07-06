--残星倩影 不知灵慧
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33700992
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsss.TargetFunction(c)
	rsss.SpecialSummonRule(c,cm.con)
	rsss.MatFunction(c,cm.fun)
	local e3=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,4},nil,"dam","de",cm.setcon,nil,cm.settg,cm.setop)
end
function cm.con(e,tp)
	local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	return #g2>#g1
end
function cm.fun(rc)
	local e1=rsef.QO({rc,true},nil,{m,0},1,"sp",nil,LOCATION_MZONE,nil,nil,cm.tg,cm.op)
	return e1
end
function cm.setfilter(c,e,tp)
	if not c:IsSetCard(0x144d) then return false end
	if c:IsType(TYPE_MONSTER) then return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	else
		return c:IsSSetable()
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function cm.op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	if tc:IsType(TYPE_MONSTER) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	else
		Duel.SSet(tp,tc)
	end
	Duel.ConfirmCards(1-tp,tc)
end
function cm.setcon(e,tp,eg)
	local st=e:GetHandler():GetSummonType()
	return st==SUMMON_TYPE_SPECIAL+1
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
end
function cm.setop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	if tc:IsType(TYPE_MONSTER) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	else
		Duel.SSet(tp,tc)
	end
end