--渴求之魂 - 碧海
local m=33701451
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,4,cm.lcheck)
	c:EnableReviveLimit()
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.lpcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	c:RegisterEffect(e2)
	--Effect 2  
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,0))
	e12:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_MZONE)
	e12:SetHintTiming(TIMING_BATTLE_START+TIMING_BATTLE_END)
	e12:SetCountLimit(1)
	e12:SetCondition(cm.descon)
	e12:SetTarget(cm.destg)
	e12:SetOperation(cm.desop)
	c:RegisterEffect(e12)
	--Effect 3 
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(m,1))
	e21:SetType(EFFECT_TYPE_QUICK_O)
	e21:SetCode(EVENT_CHAINING)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCountLimit(1,m)
	e21:SetCondition(cm.chcon)
	e21:SetTarget(cm.chtg)
	e21:SetOperation(cm.chop)
	c:RegisterEffect(e21)
end
--link summon
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_XYZ)
end
--Effect 1
function cm.lpcon(e)
	local lp=Duel.GetLP(e:GetHandlerPlayer())
	return lp<=12000
end
--Effect 2
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil)
	local atk=g:GetSum(Card.GetAttack)
	if chk==0 then return atk>0 end 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetLinkedGroup():Filter(Card.IsFaceup,nil)
	local atk=g:GetSum(Card.GetAttack)
	if atk>0 and c:IsRelateToEffect(e) then
		if Duel.Recover(tp,atk,REASON_EFFECT)~=0 
			and Duel.IsPlayerCanDraw(1-tp,2)
			and Duel.SelectYesNo(1-tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			local def=g:GetSum(Card.GetDefense)
			if Duel.Draw(1-tp,2,REASON_EFFECT)~=0 
				and def>0 then
				Duel.BreakEffect()
				Duel.Recover(tp,def,REASON_EFFECT)
			end
		end
	end
end
--Effect 3 
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return  rp==1-tp
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(tp,2000,REASON_EFFECT)<=0 then return end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,2000,REASON_EFFECT)
end

