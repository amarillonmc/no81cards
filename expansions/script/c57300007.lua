--异次元潜伏者
local m=57300007
local cm=_G["c"..m]
function cm.initial_effect(c)
	--beremoved
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetOperation(cm.brmop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--removed
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)

end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE)
	if Duel.GetFlagEffect(tp,0x3520)==0 then
	Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
			 if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g2:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	if Duel.GetFlagEffect(tp,0x3520)==0 then
	Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end
function cm.brmop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFacedown() then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	if chk==0 then return e:GetHandler():GetFlagEffect(m+1)==0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(m+1,RESET_EVENT+0x4760000+RESET_PHASE+PHASE_END,0,1)
	if Duel.GetFlagEffect(tp,0x3520)==0 then
	Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	local c=e:GetHandler()
	local opt=0
	if c:IsAbleToHand() or c:IsSpecialSummonable() then
	opt=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
	elseif c:IsAbleToHand() and not c:IsSpecialSummonable() then
		opt=0
	elseif c:IsSpecialSummonable() and not c:IsAbleToHand() then
		opt=1
	else
		return
	end
	if opt==0 then 
	Duel.SendtoHand(c,tp,REASON_EFFECT)
	else
		if c:IsRelateToEffect(e) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
			Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
			return
			end
		Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
		end
	end
	if Duel.GetFlagEffect(tp,0x3520)==0 then
	Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end

--tg and op
	--if Duel.GetFlagEffect(tp,0x3520)~=0 then
	--Duel.ResetFlagEffect(tp,0x3520) end
	--if Duel.GetFlagEffect(tp,0x3520)==0 then
	--Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
--

