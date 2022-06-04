--夜刀神天香 毁灭
local m=33400312
local cm=_G["c"..m]
function cm.initial_effect(c)
	 c:EnableReviveLimit()
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCountLimit(1,m)
	e1:SetCondition(aux.bdcon)
	e1:SetOperation(cm.alsop)
	c:RegisterEffect(e1)
	 -- Double damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m+10000)
	e2:SetTarget(cm.dbtg)
	e2:SetOperation(cm.dbop)
	c:RegisterEffect(e2)
end
function cm.tdfilter1(c)
	return  c:IsAbleToDeck() 
end
function cm.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE+LOCATION_REMOVED
end
function cm.alsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	if Duel.IsExistingMatchingCard(cm.tdfilter1,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) then 
	   if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		   local tc=Duel.SelectMatchingCard(tp,cm.tdfilter1,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,2,nil)
		  Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
   if Duel.GetTurnPlayer()~=tp and Duel.IsExistingMatchingCard(cm.dbfilter,tp,LOCATION_MZONE,0,1,nil) then 
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	  local g=Duel.SelectMatchingCard(tp,cm.dbfilter,tp,LOCATION_MZONE,0,1,2,nil)
	  while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(cm.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetOwnerPlayer(tp)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	  end
   end
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function cm.dbfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x341)
end
function cm.dbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.dbfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.dbfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.dbfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.dbop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetCondition(cm.damcon)
		e1:SetOperation(cm.damop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(1,ev*2)
end