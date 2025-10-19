--人理天裁 少当家
function c22024680.initial_effect(c)
	aux.AddCodeList(c,22020400)
	c:EnableReviveLimit()
	aux.EnableChangeCode(c,22022090,LOCATION_MZONE+LOCATION_GRAVE)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22024680,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,22024680)
	e1:SetCost(c22024680.spcost)
	e1:SetTarget(c22024680.sptg)
	e1:SetOperation(c22024680.spop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22024680,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,22024681)
	e2:SetTarget(c22024680.target)
	e2:SetOperation(c22024680.activate)
	c:RegisterEffect(e2)
	--to grave ere
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22024680,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,22024681)
	e3:SetCondition(c22024680.erecon)
	e3:SetCost(c22024680.erecost)
	e3:SetTarget(c22024680.target)
	e3:SetOperation(c22024680.activate)
	c:RegisterEffect(e3)
end
function c22024680.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not e:GetHandler():IsPublic() and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c22024680.splimit)
	e1:SetLabelObject(e)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c22024680.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se~=e:GetLabelObject()
end
function c22024680.spfilter1(c,e,tp)
	return c:IsCode(22023400) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c22024680.spfilter2,tp,LOCATION_EXTRA,0,1,c,e,tp) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22024680.spfilter2(c,e,tp)
	return c:IsCode(22023310) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22024680.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c22024680.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function c22024680.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c22024680.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c22024680.spfilter2,tp,LOCATION_EXTRA,0,1,1,g1:GetFirst(),e,tp)
	g1:Merge(g2)
	if g1:GetCount()>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=g1:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(22024680,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			tc=g1:GetNext()
		end
		Duel.SpecialSummonComplete()
		g1:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g1)
		e1:SetCondition(c22024680.rmcon)
		e1:SetOperation(c22024680.rmop)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.Hint(HINT_CARD,0,22023310)
	Duel.SelectOption(tp,aux.Stringid(22024680,2))
	Duel.Hint(HINT_CARD,0,22023400)
	Duel.SelectOption(tp,aux.Stringid(22024680,3))
	Duel.Hint(HINT_CARD,0,22024680)
	Duel.SelectOption(tp,aux.Stringid(22024680,4))
	Duel.SelectOption(tp,aux.Stringid(22024680,5))
end
function c22024680.rmfilter(c,fid)
	return c:GetFlagEffectLabel(22024680)==fid
end
function c22024680.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c22024680.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c22024680.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c22024680.rmfilter,nil,e:GetLabel())
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c22024680.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>=2
end
function c22024680.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local ct1=g1:GetCount()-2
	local ct2=g2:GetCount()-2
	if chk==0 then return Duel.IsPlayerCanSendtoGrave(tp) and Duel.IsPlayerCanSendtoGrave(1-tp)
		and ct1>0 and g1:IsExists(Card.IsAbleToGrave,1,nil,tp,POS_FACEDOWN,REASON_RULE) and ct2>0 and g2:IsExists(Card.IsAbleToGrave,1,nil,1-tp,POS_FACEDOWN,REASON_RULE) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,ct1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g2,ct2,0,0)
end
function c22024680.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSendtoGrave(tp) and not Duel.IsPlayerCanSendtoGrave(1-tp) then return end
	Duel.SelectOption(tp,aux.Stringid(22024680,6))
	Duel.SelectOption(tp,aux.Stringid(22024680,7))
	local g1=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local ct1=g1:GetCount()-2
	if ct1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=g1:FilterSelect(tp,Card.IsAbleToGrave,ct1,ct1,nil,tp,REASON_RULE)
		Duel.SendtoGrave(sg1,REASON_RULE,tp)
	end
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local ct2=g2:GetCount()-2
	if ct2>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg2=g2:FilterSelect(1-tp,Card.IsAbleToGrave,ct2,ct2,nil,1-tp,REASON_RULE)
		Duel.SendtoGrave(sg2,REASON_RULE,1-tp)
	end
end

function c22024680.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22024680.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end