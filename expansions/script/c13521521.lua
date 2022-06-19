local m=13521521
local cm=_G["c"..m]
cm.name="异魔女龙 赛飞"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon
	aux.AddLinkProcedure(c,cm.matfilter,2,2,cm.matcheck)
	--Atk Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	--Pendulum Set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.isset(c)
	return c:GetCode()>=13521500 and c:GetCode()<=13521550
end
--Link Summon
function cm.matfilter(c)
	return cm.isset(c) and c:IsLinkType(TYPE_PENDULUM)
end
function cm.matcheck(g,lc)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
--Atk Up
function cm.atkfilter(c)
	return c:IsFaceup() and cm.isset(c)
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.atkfilter,c:GetControler(),LOCATION_EXTRA,0,nil)*400
end
--Pendulum Set
function cm.filter(c)
	return cm.isset(c) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.exfilter(c,tp)
	return c:IsControler(tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then return end
		local sg=tc:GetColumnGroup():Filter(cm.exfilter,nil,1-tp)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end