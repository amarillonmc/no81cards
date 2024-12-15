local m=15005820
local cm=_G["c"..m]
cm.name="天翎渊的挂角"
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--SearchCard
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkfilter(c)
	return c:IsSetCard(0x5f43) and c:IsType(TYPE_SYNCHRO) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.checkfilter2(c,p)
	return c:GetSummonPlayer()==p
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local cg=eg:Filter(cm.checkfilter,nil)
	if #cg==0 then return end
	if cg:IsExists(cm.checkfilter2,1,nil,0) then
		Duel.RegisterFlagEffect(0,15005820,RESET_PHASE+PHASE_END,0,1)
	end
	if cg:IsExists(cm.checkfilter2,1,nil,1) then
		Duel.RegisterFlagEffect(1,15005820,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x5f43) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.tgfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelAbove(1)
		and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel(),c:GetCode())
end
function cm.thfilter(c,lv,code)
	return c:IsSetCard(0x5f43) and c:IsLevel(lv) and not c:IsCode(code)
		and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.pubfilter(c)
	return c:IsSetCard(0x5f43) and not c:IsPublic()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lv=tc:GetLevel()
		local code=tc:GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv,code)
		local tc=g:GetFirst()
		if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,tc)
			if Duel.IsExistingMatchingCard(cm.pubfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
				local pc=Duel.SelectMatchingCard(tp,cm.pubfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
				if pc then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetDescription(66)
					e1:SetCode(EFFECT_PUBLIC)
					e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
					pc:RegisterEffect(e1)
				end
			end
		end
	end
	Duel.ResetFlagEffect(tp,15005820)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.discon)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.discon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,15005820)==0
end
function cm.splimit(e,c)
	return not c:IsSetCard(0x5f43)
end