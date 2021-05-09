--死灵舞者·队长
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100104
local cm=_G["c"..m]
local code1=0x7d7 --死者
local code2=0x7d8 --死灵舞者
local code3=0x17d7 --行动力指示物
function cm.initial_effect(c)
	c:EnableCounterPermit(code3)
	--counter
	local e1=bm.b.ce(c,nil,CATEGORY_COUNTER,EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS,EVENT_SUMMON_SUCCESS,nil,nil,bm.b.con,bm.b.cost,bm.b.tar,function(e,tp,eg,ep,ev,re,r,rp) e:GetHandler():AddCounter(code3,6) end,nil)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--effect time
	local e3=bm.b.ce(c,nil,nil,EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O,EVENT_ATTACK_ANNOUNCE,{1,m},mz,cm.con,bm.b.cost,cm.tar,cm.op,nil)
	c:RegisterEffect(e3)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
end
function cm.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=bm.c.get(e,tp,bm.c.cpos,mz,0,e:GetHandler(),code2):GetCount()
	if chk==0 then return num>0 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RaiseEvent(c,EVENT_CUSTOM+71100104,e,0,tp,tp,0)
end