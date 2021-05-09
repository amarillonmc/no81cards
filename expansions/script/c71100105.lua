--死者的祈祷
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100105
local cm=_G["c"..m]
local code1=0x7d7 --死者
local code2=0x7d8 --死灵舞者
local code3=0x17d7 --行动力指示物
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--SpecialSummon
	local e1=bm.b.ce(c,bm.hint.sps,CATEGORY_COUNTER+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON,EFFECT_TYPE_QUICK_O,EVENT_FREE_CHAIN,{1,m},sz,bm.b.con,cm.cost(3),cm.sptar,cm.spop)
	c:RegisterEffect(e1)
	--set 
	local e2=bm.b.ce(c,bm.hint.set,nil,EFFECT_TYPE_QUICK_O,EVENT_FREE_CHAIN,{1,m},ga,cm.setcon,aux.bfgcost,cm.settg,cm.setop)
	e2:SetHintTiming(TIMING_END_PHASE)
	c:RegisterEffect(e2)
end
function cm.f(c,tp,ct)
	return c:IsCanRemoveCounter(tp,code3,ct,bm.re.c) and c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function cm.cost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local tg=e:GetHandler():GetColumnGroup():Filter(cm.f,nil,tp,ct)
		if chk==0 then return #tg>0 end
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		tc:RemoveCounter(tp,code3,ct,REASON_COST)
	end
end
function cm.sf(c,e,tp,ch)
	ch=c:IsCode(m-4) or (ch and c:IsRace(RACE_ZOMBIE))
	return ch and bm.c.go(c,mz,e,tp,bm.re.e,tp) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function cm.sptar(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=e:GetHandler():GetColumnGroup():Filter(bm.c.npos,nil,m-4)
	if chk==0 then return bm.c.get(e,tp,cm.sf,dk+ga,0,nil,e,tp,#sg>0):GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,dk+ga)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=c:GetColumnGroup():Filter(bm.c.npos,nil,m-4)
	local g=bm.c.get(e,tp,cm.sf,dk+ga,0,nil,e,tp,#sg>0)
	if #g<1 or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil)
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function cm.setf(c,e,tp)
	return bm.c.go(c,sz,e,tp,bm.re.e) and c:IsSetCard(code1)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bm.c.get(e,tp,cm.setf,dk,0,1,nil,e,tp):GetCount() end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setf,tp,dk,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end






