--黄泉-远辞畴昔-
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60010029)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(cm.retcon)
	e3:SetOperation(cm.retop1)
	c:RegisterEffect(e3)
	
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)   
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.ffil(c)
	return c:IsCode(60010029) and c:IsFaceup()
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then
		Duel.RegisterFlagEffect(rp,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp,tc)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,m)>=9 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetTurnPlayer()==tp
end
function cm.retop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		if #g~=0 and Duel.IsExistingMatchingCard(cm.ffil,tp,LOCATION_FZONE,0,1,nil) then
			Duel.SendtoGrave(g,REASON_EFFECT)
			if #Duel.GetOperatedGroup()>=5 then
				Duel.SelectOption(tp,aux.Stringid(m,0))
				Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,0))
				Duel.SelectOption(tp,aux.Stringid(m,1))
				Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,1))
				e:GetHandler():SetCardData(CARDDATA_CODE,m+1) 
			end
		end
	end
	end
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return ag:GetClassCount(Card.GetRace)==ag:GetCount() and ag:GetClassCount(Card.GetAttribute)==ag:GetCount()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,1,nil)  end  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetTargetRange(LOCATION_ONFIELD,0)
		e2:SetTarget(cm.indtg)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end 
end  
function cm.indtg(e,c)
	return c:IsFacedown()
end