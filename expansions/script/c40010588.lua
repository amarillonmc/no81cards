--佳音的萌芽 格拉希娅
local m=40010588
local cm=_G["c"..m]
cm.named_with_WorldTreemarchingband=1
function cm.WorldTreemarchingband(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_WorldTreemarchingband
end
function cm.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)	
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	--e3:SetCountLimit(1,64749612)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)

	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(cm.damop)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_MOVE)
		ge2:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge2,0)
	end 
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_END and eg:Filter(cm.chfliter,nil):GetCount()>0 then
		eg:Filter(cm.chfliter,nil):ForEach(function(c) Duel.RegisterFlagEffect(rp,m,RESET_PHASE+PHASE_STANDBY,0,1) end)
		--local ct=Duel.GetFlagEffect(rp,m)

		--Debug.Message("check:")
		--Debug.Message(ct)

	end
end
function cm.chfliter(c) 
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_MZONE)
end 
---
function cm.thfilter(c)
	return cm.WorldTreemarchingband(c) and not c:IsCode(m) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	local seq=c:GetSequence()
	--local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	local ct=Duel.GetFlagEffect(tp,m)
	--local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)

	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then
		Duel.MoveSequence(c,seq+1)

		--Debug.Message("OP:")
		--Debug.Message(ct)

		if ct>0 then
			Duel.Damage(1-tp,ct*400,REASON_EFFECT)
		end
	else
		if Duel.IsPlayerAffectedByEffect(tp,40010592) and seq<3 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+2) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.MoveSequence(c,seq+2)
			if ct>0  then
				Duel.Damage(1-tp,ct*400,REASON_EFFECT)
			end
		else
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end