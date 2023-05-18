local m=82209004
local cm=_G["c"..m]
--骇入猫
function cm.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCondition(cm.spcon)  
	c:RegisterEffect(e1)  
	--return to hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)  
	e2:SetOperation(cm.thop)  
	c:RegisterEffect(e2)  
	--cannot link material  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)  
	e3:SetValue(1)  
	c:RegisterEffect(e3)  
end
function cm.spcon(e,c)  
	if c==nil then return true end  
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0  
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0  
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  
end  
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())==0  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end  
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)  
	Duel.SetChainLimit(cm.chainlm)  
end  
function cm.chainlm(e,ep,tp)  
	return tp==ep or not e:GetHandler():IsType(TYPE_MONSTER)
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)  
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.HintSelection(g) 
		g:AddCard(e:GetHandler())
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
			local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)  
			if g2:GetCount()>0 then  
				Duel.BreakEffect()  
				Duel.SendtoDeck(g2,nil,1,REASON_EFFECT)  
			end
		end  
	end  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(0,1)  
	e1:SetValue(HALF_DAMAGE)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp) 
end  