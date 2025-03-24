--「」据点
function c44401020.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--field effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISEFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(c44401020.effectfilter)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44401020,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa4a))
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(44401020,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c44401020.thtg)
	e3:SetOperation(c44401020.thop)
	c:RegisterEffect(e3)
	--spsummon
	--[[local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(44401020,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c44401020.spcon)
	e3:SetTarget(c44401020.sptg)
	e3:SetOperation(c44401020.spop)
	c:RegisterEffect(e3)]]--
end
function c44401020.cfilter(c,code)
	return c:IsCode(code) and c:IsFaceup()
end
function c44401020.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and Duel.IsExistingMatchingCard(c44401020.cfilter,p,LOCATION_REMOVED,0,1,nil,tc:GetCode())
end
function c44401020.thfilter(c)
	return c:IsSetCard(0xa4a) and c:IsFaceupEx() and c:IsAbleToHand()-- and c:IsType(TYPE_MONSTER)
end
function c44401020.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,nil)
		 and Duel.IsExistingMatchingCard(c44401020.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,nil)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(44401020,4))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c44401020.gcheck(sg,tp)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1 and sg:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)<=1
end
function c44401020.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c44401020.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,c44401020.gcheck,false,1,2)
	if #tg==0 then return end
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
	local hc=rg:GetFirst()
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) or hc) then return end
	if tc:IsRelateToEffect(e) then rg:AddCard(tc) end
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
	local og=Duel.GetOperatedGroup()
	if og:GetCount()==0 then return end
	local fid=e:GetHandler():GetFieldID()
	if og:IsContains(tc) then tc:RegisterFlagEffect(44401020,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(44401020,2)) end
	if hc and og:IsContains(hc) then hc:RegisterFlagEffect(44401020,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(44401020,3)) end
	og:KeepAlive()
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetLabel(fid)
	e0:SetLabelObject(og)
	e0:SetCountLimit(1)
	e0:SetCondition(c44401020.retcon)
	e0:SetOperation(c44401020.retop)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
end
function c44401020.retfilter(c,fid)
	return c:GetFlagEffectLabel(44401020)==fid
end
function c44401020.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(c44401020.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c44401020.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c44401020.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	for tc in aux.Next(sg) do
		if tc:IsPreviousLocation(LOCATION_MZONE) then
			local pos=tc:GetPreviousPosition()
			if pos==POS_FACEDOWN_ATTACK then
				pos=POS_FACEUP_ATTACK
			elseif pos==POS_FACEDOWN_DEFENSE then
				pos=POS_FACEUP_DEFENSE
			end
			Duel.ReturnToField(tc,pos)
		else
			Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
		end
	end
end
function c44401020.chkfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsType(TYPE_FUSION) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c44401020.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c44401020.chkfilter,1,nil,tp)
end
function c44401020.spfilter(c,e,tp)
	return c:IsSetCard(0xa4a) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsFaceup()
end
function c44401020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c44401020.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(44401020,3))
end
function c44401020.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c44401020.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c44401020.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	--Duel.RegisterEffect(e1,tp)
end
function c44401020.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_PSYCHO)
end
