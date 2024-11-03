--小小的寻宝鼠妖·纳兹琳地
local cm,m=GetID()
function c23400105.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.thtg2)
	e4:SetOperation(cm.thop2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,aux.FALSE)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return  Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0 and Duel.GetCustomActivityCount(m,1-tp,ACTIVITY_CHAIN)~=0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e3,true)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e4,true)
			local e5=e3:Clone()
			e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL+RESET_PHASE+PHASE_END)
			e5:SetValue(1)
			c:RegisterEffect(e5,true)
			local e6=e5:Clone()
			e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e6,true)
end
function cm.same_check(c,mc)
	local flag=0
	if c:GetRace()==mc:GetRace() then flag=flag+1 end
	if c:GetAttribute()==mc:GetAttribute() then flag=flag+1 end
	if c:GetLevel()==mc:GetLevel() then flag=flag+1 end
	return flag==1
end
function cm.filter1(c,tp)
	return c:IsType(TYPE_MONSTER) and  c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_HAND,0,1,nil,tp,c)
end
function cm.filter2(c,tp,mc)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and cm.same_check(c,mc)
		and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_DECK,0,1,nil,c)
end
function cm.filter3(c,mc)
	local lv=mc:GetLevel()
	local rc=mc:GetRace()
	local ab=mc:GetAttribute()
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:IsRace(rc) and c:IsLevel(lv) and c:IsAttribute(ab)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	if g1:GetCount()==0 then return end
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_HAND,0,1,1,nil,tp,g1:GetFirst())
	if g2:GetCount()~=0 and Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)~=0 then
		local g3=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_DECK,0,1,1,nil,g2:GetFirst())
	if g3:GetCount()~=0 and Duel.Remove(g3,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g1:Merge(g2)
		g1:Merge(g3)
			if g1:GetCount()>0 then
			local tg=g1:Select(tp,1,1,nil):GetFirst()
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			g1:RemoveCard(tg)
			local tc=g1:GetFirst()
				while tc do 
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				if Duel.GetTurnPlayer()~=tp then
					e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
				else
					e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
				end
				tc:RegisterEffect(e1)
				tc=g1:GetNext()
				end
			end
		end
	end
end
function cm.filter11(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and  c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(cm.filter12,tp,LOCATION_HAND,0,1,nil,tp,c)
end
function cm.filter12(c,tp,mc)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove() 
		and Duel.IsExistingMatchingCard(cm.filter13,tp,LOCATION_DECK,0,1,nil,c,mc)
end
function cm.filter13(c,mc,nc)
	return  (c:GetOriginalType()==TYPE_TRAP or c:GetOriginalType()==TYPE_SPELL) and c:GetCode()~=mc:GetCode() and c:GetCode()~=nc:GetCode() and c:IsAbleToHand()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter11,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,cm.filter11,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	if g1:GetCount()==0 then return end
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,cm.filter12,tp,LOCATION_HAND,0,1,1,nil,tp,g1:GetFirst())
	if g2:GetCount()~=0 and Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)~=0 then
		local g3=Duel.SelectMatchingCard(tp,cm.filter13,tp,LOCATION_DECK,0,1,1,nil,g1:GetFirst(),g2:GetFirst())
	if g3:GetCount()~=0  then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc2=g3:GetFirst()
				Duel.SendtoHand(g3,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g3)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(1,0)
				e1:SetValue(cm.aclimit)
				e1:SetLabel(tc2:GetCode())
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				local tc=g1:GetFirst()
				while tc do 
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				if Duel.GetTurnPlayer()~=tp then
					e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
				else
					e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
				end
				tc:RegisterEffect(e1)
				tc=g1:GetNext()
			end
		end
	end
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) 
end