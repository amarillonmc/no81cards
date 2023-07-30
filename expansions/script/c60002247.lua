--霸瞳皇帝
local m=60002247
local cm=_G["c"..m]
function cm.initial_effect(c)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.thtg2)
	e1:SetOperation(cm.thop2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local tc=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
	if tc>1 then
		local g=Duel.SelectMatchingCard(p,Card.IsAbleToRemove,p,LOCATION_HAND,0,tc-1,tc-1,nil)
		if g:GetCount()==0 then return end
		Duel.Remove(g,nil,POS_FACEDOWN,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(p,g:GetCount(),REASON_EFFECT)
		if Duel.GetTurnCount()<=2 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2800)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	local def=c:GetDefense()
	local oatk=c:GetBaseAttack()
	local odef=c:GetBaseDefense()
	Duel.Damage(1-tp,atk,REASON_EFFECT)
	Duel.Recover(tp,def,REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(oatk*2)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(odef*2)
	c:RegisterEffect(e2)
end