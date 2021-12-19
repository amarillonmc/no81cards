--死者的修罗
--死者的祈祷
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100115
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
	local e1=bm.b.ce(c,aux.Stringid(64047146,0),CATEGORY_COUNTER+CATEGORY_TODECK,EFFECT_TYPE_QUICK_O,EVENT_FREE_CHAIN,{1,m},sz,bm.b.con,cm.cost,cm.sptar,cm.spop)
	c:RegisterEffect(e1)
	--set 
	local e2=bm.b.ce(c,bm.hint.set,nil,EFFECT_TYPE_QUICK_O,EVENT_FREE_CHAIN,{1,m},ga,cm.setcon,aux.bfgcost,cm.settg,cm.setop)
	e2:SetHintTiming(TIMING_END_PHASE)
	c:RegisterEffect(e2)
end
function cm.f(c,tp)
	return (c:IsCode(m-1) or c:IsCanRemoveCounter(tp,code3,1,bm.re.c)) and c:IsControler(tp) and c:IsType(TYPE_MONSTER) and bm.c.cpos(c,code2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=e:GetHandler():GetColumnGroup():Filter(cm.f,nil,tp)
	if chk==0 then return #tg>0 end
	if tg:FilterCount(Card.IsCode,nil,m-1)<1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		local ct=tc:GetCounter(code3)
		tc:RemoveCounter(tp,code3,ct,bm.re.c)
	end
end
function cm.sf(c)
	return bm.c.cpos(c,code1) and c:IsType(TYPE_TRAP)
end
function cm.sptar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bm.c.get(e,tp,cm.sf,rm,0,nil):GetCount()>2 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,0,rm)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=bm.c.get(e,tp,cm.sf,rm,0,nil)
	if #g<3 or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:Select(tp,3,3,nil)
	if #tg==3 then
		Duel.SendtoDeck(tg,nil,2,bm.re.e)
	end
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function cm.setf(c,e,tp)
	return bm.c.go(c,sz,e,tp,bm.re.e) and c:IsSetCard(code1)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bm.c.get(e,tp,cm.setf,dk,0,1,nil,e,tp):GetCount()>0 end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setf,tp,dk,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end






