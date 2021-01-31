--对混沌病毒歼灭兵器 改造海兹王
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25001010)
function cm.initial_effect(c)
	local e1=rscf.SetSummonCondition(c,nil,rsval.spconbe) 
	local e2=rsef.I(c,{m,0},{1,m},"sp,tg",nil,LOCATION_GRAVE,nil,nil,cm.tg,cm.op)
	local e3=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},nil,"de,dsp",nil,nil,nil,cm.buffop)
end
function cm.buffop(e,tp)
	local c=e:GetHandler()
	local e1=rsef.FV_LIMIT({c,tp},"ctrl",nil,nil,{ LOCATION_MZONE,LOCATION_MZONE },nil,rsreset.pend,"sa")
	local e2=rsef.FV_LIMIT_PLAYER({c,tp},"td",nil,nil,{0,1},nil,rsreset.pend)
	local e3,e4=rsef.FV_LIMIT_PLAYER({c,tp},"tg,rm",nil,aux.TargetBoolFunction(Card.IsLocation,LOCATION_HAND),{0,1},nil,rsreset.pend)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
end
function cm.tgfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToGrave()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=rscf.GetSelf(e)
	local g=Duel.GetDecktopGroup(tp,5)
	if #g<5 then return end
	Duel.ConfirmDecktop(tp,5)
	if g:IsExists(cm.tgfilter,1,nil) and c and rscf.spfilter2()(c,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.DisableShuffleCheck()
		rshint.Select(tp,"tg")
		local tg=g:FilterSelect(tp,cm.tgfilter,1,3,nil)
		if Duel.SendtoGrave(tg,REASON_EFFECT)>0 then
			rssf.SpecialSummon(c)
		end 
		g:Sub(tg)
	end
	if #g>0 then
		Duel.SortDecktop(tp,tp,#g)
		for i=1,#g do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
end