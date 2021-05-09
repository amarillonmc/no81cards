--人形设计图
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100109
local cm=_G["c"..m]
local code1=0x7d7 --死者
local code2=0x7d8 --死灵舞者
local code3=0x17d7 --行动力指示物
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,m)
	c:RegisterEffect(e0)
	--maintain
	local e1=bm.b.ce(c,nil,nil,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS,EVENT_PHASE+PHASE_STANDBY,1,sz,cm.mtcon,bm.b.cost,bm.b.tar,cm.mtop)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--tohand
	local e2=bm.b.ce(c,bm.hint.th,CATEGORY_TOHAND+CATEGORY_SEARCH,EFFECT_TYPE_IGNITION,nil,{1,m+1},sz,bm.b.con,bm.b.cost,cm.tar,cm.op)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=bm.b.ce(c,bm.hint.sps,CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON,EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O,EVENT_TO_GRAVE,{1,m+2},nil,cm.spcon,bm.b.cost,cm.sptg,cm.spop)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	c:RegisterEffect(e3)
end
function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,bm.c.cpos,tp,of,0,1,1,nil,code1)
	Duel.SendtoGrave(g,bm.re.c)
end
function cm.f(c,e,tp)
	return bm.c.cpos(c,code2) and bm.c.go(c,ha,e,tp,bm.re.e) and c:IsType(TYPE_MONSTER)
end
function cm.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bm.c.has(e,tp,cm.f,dk,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,dk)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.f,tp,dk,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(of)
end
function cm.sf(c,e,tp)
	return c:IsSetCard(code2) and bm.c.go(c,mz,e,tp,bm.re.e,tp) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bm.c.has(e,tp,cm.sf,ha+ga,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,ha+ga)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=bm.c.get(e,tp,cm.sf,ha+ga,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end














