--落幕的幸福
local m=33400655
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE+CATEGORY_TODECK)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,m)
	e0:SetTarget(cm.drtg)
	e0:SetOperation(cm.drop)
	c:RegisterEffect(e0) 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,m+10000)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.spcon2)
	c:RegisterEffect(e2)
end
function cm.refilter(c)
	return c:IsSetCard(0x9342,0xc342)and  c:IsAbleToDeck()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
  if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE)  and cm.refilter(chkc) end 
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,5,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,0,0)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp) 
if not Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,5,nil) then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,5,5,nil)   
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0  then 
		if g:IsExists(Card.IsSetCard,1,nil,0x9342) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) then
			 if  Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil)   
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			 end		
		end
		if g:IsExists(Card.IsSetCard,1,nil,0xc342) and Duel.IsPlayerCanDraw(tp,2) then
			 if  Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
				 Duel.Draw(tp,2,REASON_EFFECT)   
			 end
		end
	end 
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)==0 and e:GetHandler():GetFlagEffect(m)==0
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)>0 and e:GetHandler():GetFlagEffect(m)==0
end
function cm.refilter2(c)
	return c:IsSetCard(0x340,0x341) and c:IsFaceup()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
  if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp)  and cm.refilter2(chkc) end 
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.refilter2,tp,LOCATION_ONFIELD,0,1,nil) end
e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp) 
local c=e:GetHandler()
if not Duel.IsExistingMatchingCard(cm.refilter2,tp,LOCATION_ONFIELD,0,1,nil) then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.refilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
	 Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	 local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)  
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EFFECT_IMMUNE_EFFECT)
		e5:SetValue(cm.efilter)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e5)
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end