--庞克恶魔·戴莫尼亚
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--attackup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(cm.incon)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetCondition(cm.incon)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(cm.regop)
	c:RegisterEffect(e5)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCountLimit(1)
	e7:SetCondition(cm.drcon)
	e7:SetTarget(cm.drtg)
	e7:SetOperation(cm.drop)
	e7:SetLabelObject(e5)
	c:RegisterEffect(e7)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==ep then
		Duel.RegisterFlagEffect(ep,m,0,0,1)
	end
end
function cm.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Damage(tp,1,REASON_EFFECT)~=0 and Duel.GetFlagEffect(tp,m)>=7 and c:IsRelateToEffect(e) then
		c:AddCounter(0x624,1)
		Duel.RegisterFlagEffect(tp,60002148,0,0,1)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x624)
	e:SetLabel(ct)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel()
	return ct>0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.filter(c,tp)
	return c:IsCanHaveCounter(0x624) and Duel.IsCanAddCounter(tp,0x624,1,c) and c:IsAbleToHand() and c:IsRace(RACE_FIEND)
end