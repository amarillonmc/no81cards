--paranomain maxwell's demon
--21.06.24
local m=11451100
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Maxwell's Demon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.adjustop)
	c:RegisterEffect(e1)
end
function cm.filter(c,e)
	local tp=c:GetControler()
	return c:GetTextAttack()>=0 and c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0 and not c:IsImmuneToEffect(e)
end
function cm.atkfun(c,tp)
	if c:IsControler(tp) then return c:GetAttack()+0.5 end
	return c:GetAttack()
end
function cm.filter2(c,tp,atk)
	return cm.atkfun(c,tp)==atk
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL or c:IsStatus(STATUS_BATTLE_DESTROYED) then return end
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil,e)
	local g2=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil,e)
	if #g1==0 or #g2==0 then return end
	local _,atk1=g1:GetMinGroup(Card.GetAttack)
	local _,atk2=g2:GetMaxGroup(Card.GetAttack)
	if atk1>=atk2 then return end
	local g=g1+g2
	local g2goal=Group.CreateGroup()
	local sel=true
	for i=1,#g2 do
		local minc=g:GetMinGroup(cm.atkfun,tp):GetFirst()
		g2goal:AddCard(minc)
		if #g2goal==#g2 and #g:GetMinGroup(cm.atkfun,tp)==1 then sel=false end
		g:RemoveCard(minc)
	end
	if sel then
		local rg,exatk=g2goal:GetMaxGroup(cm.atkfun,tp)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		local sg=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,#rg,#rg,nil,tp,exatk)
		g2goal=Group.__sub(g2goal,rg)+sg
	end
	local exg1=Group.__band(g1,g2goal)
	local exg2=Group.__sub(g2,g2goal)
	Duel.HintSelection(exg1)
	Duel.HintSelection(exg2)
	Duel.SwapControl(exg1,exg2)
	Duel.Readjust()
end