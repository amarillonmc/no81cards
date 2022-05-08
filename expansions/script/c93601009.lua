--混沌No.89 电脑城 系统地狱
local m=93601009
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3)
	c:EnableReviveLimit()
	--banish extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.excost)
	e1:SetTarget(cm.extg)
	e1:SetOperation(cm.exop)
	c:RegisterEffect(e1)
	--remove
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(m,1))
	ea:SetCategory(CATEGORY_REMOVE)
	ea:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	ea:SetCode(EVENT_BATTLE_START)
	ea:SetCountLimit(1)
	ea:SetCondition(cm.condition)
	ea:SetTarget(cm.rmtg)
	ea:SetOperation(cm.rmop)
	c:RegisterEffect(ea)
end
aux.xyz_number[m]=89
function cm.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.dmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function cm.dmfilter1(c,att)
	return c:IsFaceup() and c:IsAbleToRemove() and c:IsAttribute(att)
end
function cm.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil,tp,POS_FACEDOWN) and
	Duel.IsExistingMatchingCard(cm.dmfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE)
end
function cm.filter2(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN) and Duel.IsExistingMatchingCard(cm.dmfilter1,tp,0,LOCATION_MZONE,1,nil,c:GetAttribute())
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,cm.filter2,1,1,nil,tp)
	if Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)~=0 then
		Duel.ShuffleExtra(1-tp)
		local og=Duel.GetOperatedGroup()
		local rc=og:GetFirst()
		local att=rc:GetAttribute()
		local g=Duel.SelectMatchingCard(tp,cm.dmfilter1,tp,0,LOCATION_MZONE,1,1,nil,att)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function cm.filter(c)
   return c:IsType(TYPE_XYZ) and c:IsRace(RACE_PSYCHO)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:GetOverlayGroup():IsExists(cm.filter,1,nil) and bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsControler(1-tp) and tc:IsAbleToRemove(tp,POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end