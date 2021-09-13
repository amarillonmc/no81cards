--冰汽时代 信仰守护者
local m=33502221
local cm=_G["c"..m]
Duel.LoadScript("c33502200.lua")
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.effcon)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
		--
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_TOGRAVE)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_BATTLE_START)
	e11:SetTarget(cm.destg)
	e11:SetOperation(cm.desop)
	c:RegisterEffect(e11)
end
function cm.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.spfilter(c,e,tp)
	return c:IsSummonable(true,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,e:GetHandler())
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if g1:GetCount()>0 or g2:GetCount()>0 then
		if not Duel.IsPlayerAffectedByEffect(tp,33502206) then Duel.SetLP(tp,Duel.GetLP(tp)-1000) end
		if #g1>0 then
		local sg1=Duel.SendtoHand(g1,tp,REASON_EFFECT)
		if sg1>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local sc1=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,nil):Select(tp,1,sg1,nil)
		local tc1=sc1:GetFirst()
		while tc1 do
		Duel.Summon(tp,tc1,true,nil)
		tc1=sc1:GetNext() end
		end
end
		if #g2>0 then
		local sg2=Duel.SendtoHand(g2,1-tp,REASON_EFFECT)
		if sg2>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SUMMON)
		local sc2=Duel.GetMatchingGroup(cm.spfilter,tp,0,LOCATION_HAND,nil):Select(1-tp,1,sg2,nil)
		local tc2=sc2:GetFirst()
		while tc2 do
		Duel.Summon(tp,tc2,true,nil)
		tc2=sc2:GetNext() end
		end
end
	end
end
--e11
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local atk=c:GetAttack()
	if bc then
		if Duel.SendtoGrave(bc,REASON_EFFECT)~=0 then Duel.Damage(1-tp,atk,REASON_EFFECT) end
	end
end
