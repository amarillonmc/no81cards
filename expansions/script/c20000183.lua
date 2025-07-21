--圣沌大忍者 波罗羯谛
dofile("expansions/script/c20000175.lua")
local cm, m = fu_HC.MInitial(nil, 9)
--e1
cm.e1 = fuef.QO():Cat("SP+GA"):Ran("M"):Ctl(1):Func("cos1,tg1,op1")
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
local e1g1 = fugf.MakeFilter("GR","IsSet+CanSp","5fd1,%1")
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #e1g1(tp,e) > 0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g = fugf.Select(tp, e1g1(tp,e), "GChk")
	if #g == 0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end