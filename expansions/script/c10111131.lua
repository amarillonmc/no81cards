function c10111131.initial_effect(c)
	aux.AddCodeList(c,10111128)
	--fusion material
	c:EnableReviveLimit()
	--material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x8),c10111131.mfilter,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c10111131.splimit)
	c:RegisterEffect(e0)
    	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111131,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10111131)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c10111131.tgtg1)
	e1:SetOperation(c10111131.tgop1)
	c:RegisterEffect(e1)
    	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111131,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101111310)
	e2:SetTarget(c10111131.thtg)
	e2:SetOperation(c10111131.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10111131.regcon)
	e3:SetOperation(c10111131.regop)
	c:RegisterEffect(e3)
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e2:SetLabelObject(ng)
	e3:SetLabelObject(ng)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10111131,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_DRAW)
	e4:SetCondition(c10111131.spcon)
	e4:SetTarget(c10111131.sptg)
	e4:SetOperation(c10111131.spop)
	c:RegisterEffect(e4)
end
c10111131.fusion_effect=true
function c10111131.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc:IsCode(10111128)
end
function c10111131.mfilter(c)
	return c:IsLevelAbove(6) and c:IsSetCard(0x8) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c10111131.tgfilter(c)
	return not c:IsPublic() or c:IsType(TYPE_MONSTER)
end
function c10111131.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mc=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if chk==0 then return mc>0 or g and g:IsExists(c10111131.tgfilter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
end
function c10111131.tgop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c10111131.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c10111131.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=e:GetLabelObject()
	if c:GetFlagEffect(10111131)==0 then
		sg:Clear()
		c:RegisterFlagEffect(10111131,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
	end
	local g=eg:Filter(Card.IsControler,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(10111131,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
		sg:AddCard(tc)
		tc=g:GetNext()
	end
end
function c10111131.thfilter(c)
	return c:GetFlagEffect(10111131)~=0 and c:IsAbleToHand() and not c:IsCode(10111131) and c:IsLocation(LOCATION_GRAVE)
end
function c10111131.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ng=e:GetLabelObject()
	if chk==0 then return ng and ng:GetCount()>0 and ng:IsExists(c10111131.thfilter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c10111131.thop(e,tp,eg,ep,ev,re,r,rp)
	local ng=e:GetLabelObject()
	if not ng or ng:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=ng:FilterSelect(tp,aux.NecroValleyFilter(c10111131.thfilter),1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10111131.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW
end
function c10111131.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10111131.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and eg:IsExists(c10111131.spfilter,1,nil,e,tp) end
	if eg:GetCount()==1 then
		Duel.ConfirmCards(1-tp,eg)
		Duel.ShuffleHand(tp)
		Duel.SetTargetCard(eg)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,eg,1,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=eg:FilterSelect(tp,c10111131.spfilter,1,1,nil,e,tp)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.SetTargetCard(g)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function c10111131.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        Duel.Draw(tp,1,REASON_EFFECT)
	end
end