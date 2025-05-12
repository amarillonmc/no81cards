-- 面灵气 怒声的大蜘蛛面
Duel.LoadScript('c47310000.lua')
local s,id=GetID()

function s.effgain(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(s.ntrcon)
	e1:SetTarget(s.ntrtg)
	e1:SetOperation(s.ntrop)
	return e1
end
function s.ntrcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.ntrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function s.ntrop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc:IsRelateToBattle() then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end
function s.ntr(c)
	local e1=Hnk.become_target(c,id)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetTarget(s.ntrtg2)
	e1:SetOperation(s.ntrop2)
	c:RegisterEffect(e1)
end
function s.ntrfilter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function s.ntrtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ntrfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE,LOCATION_REASON_CONTROL) end
	local g=Duel.GetMatchingGroup(s.ntrfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function s.ntrop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,s.ntrfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.GetControl(g,tp,PHASE_END,1)
	end
end
function s.initial_effect(c)
    Hnk.hnk_equip(c,id,s.effgain(c))
    Hnk.anger_eq(c)
	s.ntr(c)
end