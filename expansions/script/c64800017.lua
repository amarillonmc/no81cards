--杰作拼图7753-「教皇」
local m=64800017
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
 --
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.tgcon)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
 --to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.retg)
	e4:SetOperation(cm.reop)
	c:RegisterEffect(e4)
end
function cm.tgfil(c,tp)
	return c:IsControler(tp) and c:IsOnField()
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return Duel.GetFlagEffect(tp,m)==0 and ep~=tp and e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK) and ((not g) or  (not g:IsExists(cm.tgfil,1,nil,tp))) 
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
 if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)  and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
	if e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)~=0 then 
			local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
			local tc=g2:GetFirst()
			while tc do
				local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_IMMUNE_EFFECT)
				e4:SetValue(cm.efilter)
				e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
				e4:SetOwnerPlayer(tp)
				tc:RegisterEffect(e4)
				tc=g2:GetNext()
			end
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
 end
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and d  end
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	   local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_RULE)
	end
end