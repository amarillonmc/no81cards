--机械加工 蝎子Mk-2
if not pcall(function() dofile("expansions/script/c40008000") end) then dofile("script/c40008000") end
local m,cm=rscf.DefineCard(40009435)
local m=40009435
local cm=_G["c"..m]
cm.named_with_Machining=1
function cm.Machining(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Machining
end
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_INSECT),1)
	c:EnableReviveLimit()
	local e1=rsef.QO(c,EVENT_CHAINING,"neg",{1,m},"neg","dsp,dcal",LOCATION_MZONE,rscon.negcon(cm.fun),rscost.cost2(cm.reg,Card.IsReleasable,"res",LOCATION_MZONE,0,2),rstg.negtg(),cm.negop)
	local e2=rsef.STO(c,EVENT_CHANGE_POS,"sp",{1,m+100},"sp","de",cm.spcon,nil,cm.sptg,cm.spop)
end
function cm.fun(e,tp,re,rp,tg,loc)
	return loc & rsloc.hg ~= 0
end
function cm.reg(g,e,tp)
	if g:IsExists(Card.IsPreviousType,1,nil,TYPE_NORMAL) then
		e:SetLabel(100)
	else
		e:SetLabel(0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and e:GetLabel()==100 then
		local e1 = rsef.FV_LIMIT_PLAYER({e:GetHandler(),tp},"act",cm.limit,nil,{0,1},nil,rsreset.pend)
	end
end
function cm.limit(e,re)
	return re:GetHandler():IsLocation(rsloc.hg)
end
function cm.spcon(e,tp)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if #g>0 and g:FilterCount(cm.spfilter,nil,e,tp)>0
		and rsop.SelectYesNo(tp,"sp") then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:FilterSelect(tp,cm.spfilter,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		ct = #g-1
	end
	if #g>0 then
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
end
