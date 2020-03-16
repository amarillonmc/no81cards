--星宫六喰 校服
local m=33400611
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,cm.xyzfilter,8,2)
	c:EnableReviveLimit() 
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(cm.actcon)
	c:RegisterEffect(e1)
--send to grave or remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCountLimit(1,m)
	e2:SetCondition(aux.bdcon)
	e2:SetCost(cm.discost)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
--double damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCountLimit(1,m+10000)
	e3:SetCondition(cm.dmcon)
	e3:SetTarget(cm.dmtg)
	e3:SetOperation(cm.dmop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(cm.dmcon2)
	c:RegisterEffect(e4)
end
function cm.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) 
end

function cm.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end   
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.tfilter(c)
	return c:IsAbleToRemove() or c:IsAbleToGrave()
end
function cm.thfilter(c)
	return c:IsSetCard(0x9342) and c:IsAbleToHand()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
			local g=Duel.GetMatchingGroup(cm.tfilter,tp,0,LOCATION_ONFIELD,nil)
			if g:GetCount()>0  then  
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
				local sg=g:Select(tp,1,1,nil)
				local tc=sg:GetFirst()
				local op
				if tc:IsAbleToRemove() and tc:IsAbleToGrave() then
				   op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
				elseif not tc:IsAbleToRemove() and tc:IsAbleToGrave() then
				   op=0
				elseif tc:IsAbleToRemove() and not tc:IsAbleToGrave() then
				   op=1
				end
				if op==0 then   Duel.SendtoGrave(tc,REASON_EFFECT) end
				if op==1 then   Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)end
				if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_REMOVED,0,1,nil)   then   
					if  Duel.SelectYesNo(tp,aux.Stringid(m,3)) then  
						local tc1=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
						Duel.SendtoHand(tc1,tp,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,tc1)
					end
				end
			end
end

function cm.dmcon(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)==0
end
function cm.dmcon2(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)>0
end
function cm.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x341) end
end
function cm.dmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ss=1
	if  Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) then 
			 if  Duel.SelectYesNo(tp,aux.Stringid(m,5)) then 
				Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
				ss=2
			 end
	end
	if not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x341) then return end 
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	   local tg1=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_MZONE,0,ss,ss,nil,0x341) 
			 local sc=tg1:GetFirst()
			 while sc do		   
			   local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
				e1:SetCondition(cm.damcon)
				e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e1)
					sc=tg1:GetNext()
			 end		  
end
function cm.damcon(e)
	return e:GetHandler():GetBattleTarget()~=nil
end