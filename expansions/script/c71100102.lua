--死灵舞者·参谋
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100102
local cm=_G["c"..m]
local code1=0x7d7 --死者
local code2=0x7d8 --死灵舞者
local code3=0x17d7 --行动力指示物
function cm.initial_effect(c)
	c:EnableCounterPermit(code3)
	--counter
	local e1=bm.b.ce(c,nil,CATEGORY_COUNTER,EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS,EVENT_SUMMON_SUCCESS,nil,nil,bm.b.con,bm.b.cost,bm.b.tar,function(e,tp,eg,ep,ev,re,r,rp) e:GetHandler():AddCounter(code3,7) end,nil)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--move
	local e3=bm.b.ce(c,bm.hint.move,CATEGORY_COUNTER,EFFECT_TYPE_IGNITION,nil,{1,EFFECT_COUNT_CODE_SINGLE},mz,bm.b.con,cm.cost(1),cm.tar,cm.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CUSTOM+71100104)
	c:RegisterEffect(e4)
end
function cm.cost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,code3,ct,REASON_COST) end
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		e:GetHandler():RemoveCounter(tp,code3,ct,REASON_COST)
	end
end
function cm.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=bm.c.get(e,tp,bm.c.cpos,mz,0,nil,code2):GetCount()
	local locn=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)
	if chk==0 then return num>1 and (locn>0 or num>0) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not cm.tar(e,tp,eg,ep,ev,re,r,rp,0) then return end
	local sg=bm.c.get(e,tp,bm.c.cpos,mz,0,nil,code2)
	local locn=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)
	local min=1
	if locn<1 then min=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tg=sg:Select(tp,min,2,nil)
	if #tg==2 then
		Duel.HintSelection(tg)
		local tc1=tg:GetFirst()
		local tc2=tg:GetNext()
		Duel.SwapSequence(tc1,tc2)
	elseif #tg==1 then
		local tc=tg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
	end
end












