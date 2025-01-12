--迷托邦流栖 迷宿
local cm,m=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_MZONE)
	--c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--hint
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetOperation(cm.chkop)
	c:RegisterEffect(e5)
	if not PNFL_DESTROY_CHECK then
		PNFL_DESTROY_CHECK={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local code,code2=tc:GetCode()
		PNFL_DESTROY_CHECK[code]=true
		if code2 then PNFL_DESTROY_CHECK[code2]=true end
		tc=eg:GetNext()
	end
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for code=11451900,11451905 do
		if PNFL_DESTROY_CHECK[code] and c:GetFlagEffect(code+0xffffff)==0 then
			c:RegisterFlagEffect(code+0xffffff,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,6))
		end
	end
end
function cm.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT) --or c:IsLocation(LOCATION_REMOVED)) and not c:IsPreviousLocation(LOCATION_SZONE) and c:IsType(TYPE_MONSTER)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToHand() and c:GetSummonType()&SUMMON_TYPE_NORMAL==0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if chk==0 then return (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or 1==1) and (c:IsSummonable(true,nil) or (c:IsAbleToHand() and c:IsLocation(LOCATION_MZONE) and #g>0)) end
	g:AddCard(c)
	if c:IsLocation(LOCATION_HAND) then
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
	elseif c:IsLocation(LOCATION_MZONE) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,PLAYER_ALL,LOCATION_ONFIELD)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if c:IsLocation(LOCATION_MZONE) then
			local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToHand() and c:GetSummonType()&SUMMON_TYPE_NORMAL==0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
			if #g>0 then
				g:AddCard(c)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
				local sg=g:SelectSubGroup(tp,Group.IsContains,false,2,2,c)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
			end
		elseif c:IsSummonable(true,nil) then
			Duel.Summon(tp,c,true,nil)
		end
	end
end
function cm.dfilter(c)
	local code,code2=c:GetCode()
	return PNFL_DESTROY_CHECK[code] or (code2 and PNFL_DESTROY_CHECK[code2])
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.dfilter,1,nil)
end
function cm.thfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end