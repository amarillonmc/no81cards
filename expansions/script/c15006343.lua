local m=15006343
local cm=_G["c"..m]
cm.name="折折界灵 千纸姬"
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x5f45),2,true)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.postg)
	e1:SetOperation(cm.posop)
	c:RegisterEffect(e1)
	--d/d
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FLIP)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.ddcon)
	e2:SetTarget(cm.ddtg)
	e2:SetOperation(cm.ddop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,m+1)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP)
	c:RegisterEffect(e4)
	--pos
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCountLimit(1,m+2)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(cm.pcost)
	e5:SetTarget(cm.ptg)
	e5:SetOperation(cm.pop)
	c:RegisterEffect(e5)
end
function cm.posfilter(c)
	local b1=c:IsPosition(POS_FACEUP_ATTACK) and (c:IsCanTurnSet() or c:IsCanChangePosition())
	local b2=c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanTurnSet()
	local b3=c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsCanChangePosition()
	local b4=c:IsPosition(POS_FACEDOWN_ATTACK) and c:IsCanChangePosition()
	return b1 or b2 or b3 or b4
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,cm.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsPosition(POS_ATTACK) then Duel.ChangePosition(tc,POS_DEFENSE)
	elseif tc:IsPosition(POS_FACEUP_DEFENSE) then Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	elseif tc:IsPosition(POS_FACEDOWN_DEFENSE) then Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end
end
function cm.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function cm.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cm.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Draw(p,1,REASON_EFFECT)
end
function cm.thfilter(c,tp)
	return c:IsSetCard(0x5f45) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or (c:IsCode(15006361) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		if tc:IsCode(15006361) and tc:GetActivateEffect() and tc:GetActivateEffect():IsActivatable(tp,true,true) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
		if Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			local sg=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,1,nil)
			if #sg>0 then
				Duel.BreakEffect()
				Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end
function cm.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local x=1
	if e:GetHandler():IsPosition(POS_FACEDOWN) then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
		x=2
	end
	e:SetLabel(x)
end
function cm.pfilter(c,res)
	return c:IsPosition(POS_DEFENSE) and ((c:IsFacedown() and c:IsCanChangePosition()) or (res==2 and c:IsFaceup() and c:IsCanTurnSet()))
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()
	local g=Duel.GetMatchingGroup(cm.pfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,res)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	local res=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,cm.pfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,res)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local pos=0
		if res==2 and tc:IsFaceup() then pos=POS_FACEDOWN_DEFENSE
		else pos=Duel.SelectPosition(tp,tc,POS_FACEUP) end
		Duel.ChangePosition(tc,pos)
	end
end