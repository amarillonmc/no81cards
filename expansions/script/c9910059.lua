--艺术之都 巴黎
function c9910059.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910059+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910059.target)
	e1:SetOperation(c9910059.activate)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetValue(c9910059.indct)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c9910059.setcon)
	e4:SetTarget(c9910059.settg)
	e4:SetOperation(c9910059.setop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetOperation(c9910059.regop)
	c:RegisterEffect(e5)
end
function c9910059.filter(c)
	return ((c:IsLocation(LOCATION_GRAVE) and c:IsRace(RACE_FAIRY)) or c:IsLocation(LOCATION_HAND))
		and c:IsAbleToDeck()
end
function c9910059.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910059.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9910059.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9910059.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c9910059.indct(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetHandlerPlayer() then
		return 1
	else return 0 end
end
function c9910059.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local turnp=Duel.GetTurnPlayer()
	local tc=eg:GetFirst()
	while tc do
		if tc:GetSummonPlayer()==turnp then
			local flag=c:GetFlagEffectLabel(9910059)
			if flag then
				c:SetFlagEffectLabel(9910059,flag+1)
			else
				c:RegisterFlagEffect(9910059,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
			end
		end
		tc=eg:GetNext()
	end
end
function c9910059.setcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffectLabel(9910059)
	return ct and ct>=3
end
function c9910059.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910059.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		if Duel.ChangePosition(c,POS_FACEDOWN)~=1 then return end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
