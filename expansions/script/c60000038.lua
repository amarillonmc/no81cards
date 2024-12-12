--掠雷冲
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000032)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(aux.exccon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.handcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),60000037)~=0
end
function cm.filter(c)
	return aux.IsCodeListed(c,60000032) and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,100)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(tp,100,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local b1=true
			local b2=true
			local b3=true
			if Duel.GetFlagEffect(tp,m+10000000)~=0 then
				b1=false
				if 1==1 then Duel.Damage(1-tp,600,REASON_EFFECT) end
			end
			if Duel.GetFlagEffect(tp,m+20000000)~=0 then
				b2=false
				local g=Duel.GetDecktopGroup(1-tp,1)
				if #g==1 then 
				Duel.DisableShuffleCheck()
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT) end
			end
			if Duel.GetFlagEffect(tp,m+30000000)~=0 then
				b3=false
				--atk
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetTargetRange(LOCATION_MZONE,0)
				e2:SetTarget(cm.atktg)
				e2:SetValue(400)
				Duel.RegisterEffect(e2,tp)
				local e3=e2:Clone()
				e3:SetCode(EFFECT_UPDATE_DEFENSE)
				Duel.RegisterEffect(e3,tp)
			end
			local op=0
			if b1 or b2 or b3 then op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,1)},{b2,aux.Stringid(m,2)},{b3,aux.Stringid(m,3)}) end
			if op==1 then Duel.RegisterFlagEffect(tp,m+10000000,0,0,1) 
			elseif op==2 then Duel.RegisterFlagEffect(tp,m+20000000,0,0,1) 
			elseif op==3 then Duel.RegisterFlagEffect(tp,m+30000000,0,0,1) end
		end
	end
end
function cm.atktg(e,c)
	return c:IsFaceup()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if g and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
			if Duel.GetFlagEffect(tp,m+10000000)~=0 then
				--b1=false
				if 1==1 then Duel.Damage(1-tp,600,REASON_EFFECT) end
			end
			if Duel.GetFlagEffect(tp,m+20000000)~=0 then
				--b2=false
				local g=Duel.GetDecktopGroup(1-tp,1)
				if #g==1 then 
				Duel.DisableShuffleCheck()
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT) end
			end
			if Duel.GetFlagEffect(tp,m+30000000)~=0 then
				--b3=false
				--atk
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetTargetRange(LOCATION_MZONE,0)
				e2:SetTarget(cm.atktg)
				e2:SetValue(400)
				Duel.RegisterEffect(e2,tp)
				local e3=e2:Clone()
				e3:SetCode(EFFECT_UPDATE_DEFENSE)
				Duel.RegisterEffect(e3,tp)
			end
		end
	end
end


