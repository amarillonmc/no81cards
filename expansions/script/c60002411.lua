--天堂殒落于此
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
if not cm.ttylyc_change_operation then
	cm.ttylyc_change_operation=true
	cm._remove=Duel.Remove
	Duel.Remove=function (g,pos,reason,...)
		if pos=POS_FACEDOWN and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_HAND,0,1,nil) then
			if aux.GetValueType(g)=="Card" then
				local ttylyc=Duel.SelectMatchingCard(tp,cm.fil,tp,LOCATION_HAND,0,1,1,nil)
				local e1=Effect.CreateEffect(ttylyc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				ttylyc:RegisterEffect(e1)
				cm._remove(g,POS_FACEUP,reason,...)
				local e1=Effect.CreateEffect(ttylyc)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_DISABLE_FIELD)
				e1:SetOperation(cm.disop)
				Duel.RegisterEffect(e1,tp)
			elseif aux.GetValueType(cg)=="Group" then
				local cc=g:Select(tp,1,1,nil)
				g:RemoveCard(cc)
				local ttylyc=Duel.SelectMatchingCard(tp,cm.fil,tp,LOCATION_HAND,0,1,1,nil)
				local e1=Effect.CreateEffect(ttylyc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				ttylyc:RegisterEffect(e1)
				cm._remove(g,pos,reason,...)
				cm._remove(cc,POS_FACEUP,reason,...)
				local e1=Effect.CreateEffect(ttylyc)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_DISABLE_FIELD)
				e1:SetOperation(cm.disop)
				Duel.RegisterEffect(e1,tp)
			end
		else
			cm._remove(g,pos,reason,...)
		end
		return Duel.GetOperatedGroup():GetCount()
	end
end
function cm.fil(c)
	return c:IsCode(m) and not c:IsPublic()
end
function cm.disop(e,tp)
	local c=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)
	if c==0 then return end
	local dis1=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	return dis1
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_REMOVED,0,nil)>=15
end
function cm.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_REMOVED,0,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_REMOVED,0,nil)
	Duel.ConfirmCards(tp,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end











