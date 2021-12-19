--死者的看破
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100106
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
	--negate
	local e1=bm.b.ce(c,bm.hint.nege,CATEGORY_DISABLE,EFFECT_TYPE_QUICK_O,EVENT_CHAINING,{1,m},sz,function(e,tp,eg,ep,ev,re,r,rp,chk) return re and Duel.IsChainDisablable(ev) end,cm.cost(1),cm.distg,cm.disop)
	c:RegisterEffect(e1)
	--set 
	local e2=bm.b.ce(c,bm.hint.set,nil,EFFECT_TYPE_QUICK_O,EVENT_FREE_CHAIN,{1,m},ga,cm.setcon,aux.bfgcost,cm.settg,cm.setop)
	e2:SetHintTiming(TIMING_END_PHASE)
	c:RegisterEffect(e2)
end
function cm.f(c,tp,ct)
	return c:IsCanRemoveCounter(tp,code3,ct,bm.re.c) and c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsSetCard(code2)
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
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and c:GetColumnGroup():FilterCount(bm.c.npos,nil,m-4)>0 and Duel.SelectYesNo(tp,bm.hint.des) then
		Duel.Destroy(eg,bm.re.e)
	end
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function cm.setf(c,e,tp)
	return bm.c.go(c,sz,e,tp,bm.re.e) and c:IsSetCard(code1)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bm.c.get(e,tp,cm.setf,dk,0,nil,e,tp):GetCount()>0 end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setf,tp,dk,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end












