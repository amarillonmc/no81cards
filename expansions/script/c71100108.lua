--死者的乱来
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100108
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
	local e1=bm.b.ce(c,nil,CATEGORY_DISABLE,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS,EVENT_CHAIN_SOLVING,nil,sz,cm.discon,bm.b.cost,bm.b.tar,cm.disop)
	c:RegisterEffect(e1)
	--set 
	local e2=bm.b.ce(c,bm.hint.set,nil,EFFECT_TYPE_QUICK_O,EVENT_FREE_CHAIN,{1,m},ga,cm.setcon,aux.bfgcost,cm.settg,cm.setop)
	e2:SetHintTiming(TIMING_END_PHASE)
	c:RegisterEffect(e2)
end
function cm.disf(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and (c:IsCanRemoveCounter(tp,code3,1,bm.re.e) or (c:IsLevelAbove(3) and c:IsCode(m-5)))
end
function cm.dfilter(c,tp)
	return c:IsSetCard(code2) and c:IsType(TYPE_MONSTER) and c:IsOnField() and c:IsControler(tp)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local net=CATEGORY_NEGATE 
	if re:IsHasCategory(CATEGORY_DISABLE) then net=CATEGORY_DISABLE end
	local ex,tg,tc=Duel.GetOperationInfo(ev,net)
	return e:GetHandler():GetColumnGroup():FilterCount(cm.disf,nil,tp)>0
		and re:IsHasCategory(net) and ex and tg~=nil 
		and tc+tg:FilterCount(cm.dfilter,nil,tp)-tg:GetCount()>0 and Duel.IsChainDisablable(ev)
		and e:GetHandler():GetFlagEffect(m)<=0
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local g=e:GetHandler():GetColumnGroup():Filter(cm.disf,nil,tp)
	if Duel.NegateEffect(ev) and #g>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if g:FilterCount(bm.c.npos,nil,m-5)>0 and Duel.SelectYesNo(tp,bm.hint.lvd) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(-2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			tc:RegisterEffect(e1)
		else
			tc:RemoveCounter(tp,code3,1,bm.re.e)
		end
	end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function cm.setf(c,e,tp)
	return bm.c.go(c,sz,e,tp,bm.re.e) and c:IsSetCard(code1)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bm.c.get(e,tp,cm.setf,dk,0,nil,e,tp):GetCount() end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setf,tp,dk,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end








