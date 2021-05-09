--死灵舞者·自动人形
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100103
local cm=_G["c"..m]
local code1=0x7d7 --死者
local code2=0x7d8 --死灵舞者
local code3=0x17d7 --行动力指示物
function cm.initial_effect(c)
	--c:EnableReviveLimit()
	c:EnableCounterPermit(code3)
	--counter and SpecialSummon
	local e1=bm.b.ce(c,nil,CATEGORY_COUNTER+CATEGORY_SPECIAL_SUMMON,EFFECT_TYPE_IGNITION,nil,{1,m},ga+ha,bm.b.con,cm.spcost,cm.sptg,cm.spop,nil)
	c:RegisterEffect(e1)
	--move
	local e3=bm.b.ce(c,bm.hint.tog,CATEGORY_COUNTER+CATEGORY_TOGRAVE,EFFECT_TYPE_IGNITION,nil,{1,m-1},mz,bm.b.con,cm.cost(9),cm.tar,cm.op,nil)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CUSTOM+71100104)
	c:RegisterEffect(e4)
end
function cm.spf(c,e,tp,oc)
	return bm.c.cpos(c,code1) and bm.c.go(c,ga,e,tp,bm.re.c) and bm.c.go(oc,mz,e,tp,bm.re.e,tp) and Duel.GetMZoneCount(tp,c)>0
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=bm.c.get(e,tp,cm.spf,of,0,nil,e,tp,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:Select(tp,1,1,nil,tp)
	Duel.SendtoGrave(tc,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return bm.c.has(e,tp,cm.spf,of,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,c:GetLocation())
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and bm.c.go(c,mz,e,tp,bm.re.e,tp) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1000)
			e1:SetReset(bm.r.s+bm.r.p+RESET_SELF_TURN)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
			c:CompleteProcedure()
	end
	Duel.SpecialSummonComplete()
	c:AddCounter(code3,9)
end
function cm.cost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,code3,ct,REASON_COST) end
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		e:GetHandler():RemoveCounter(tp,code3,ct,REASON_COST)
	end
end
function cm.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetColumnGroup():FilterCount(Card.IsControler,nil,1-tp)
	if c:IsControler(1-tp) then ct=ct+1 end
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,ct,tp,of)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	local ct=#g
	if c:IsControler(1-tp) then ct=ct+1 end
	if ct<=0 then return end
	Duel.SendtoGrave(g,bm.re.e)
end




