--幻叙 模型构建
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local g=Group.CreateGroup()
	aux.RegisterMergedDelayedEvent(c,id,EVENT_SUMMON_SUCCESS,g)
	aux.RegisterMergedDelayedEvent(c,id,EVENT_SPSUMMON_SUCCESS,g)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Send and Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id)
	e3:SetCost(s.tgcost)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
end
function s.spfilter(c,e,tp,att)
	return (c:GetAttribute()&att>0 or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x838) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local att=0
	local g=eg:Filter(Card.IsFaceup,nil)
	for tc in aux.Next(g) do
		att=att|tc:GetAttribute()
	end
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,att) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.actfilter(c,tp)
	return c:IsSetCard(0x838) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local att=0
	local g=eg:Filter(Card.IsFaceup,nil)
	for tc in aux.Next(g) do
		att=att|tc:GetAttribute()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,att)
	if #g>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			local fg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.actfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
			if #fg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local sc=fg:Select(tp,1,1,nil):GetFirst()
				Duel.MoveToField(sc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				local te=sc:GetActivateEffect()
				te:UseCountLimit(tp,1,true)
				local tep=sc:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				Duel.RaiseEvent(sc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
				local desc=te:GetDescription()
				if desc then
					Duel.Hint(HINT_OPSELECTED,tp,desc)
					Duel.Hint(HINT_OPSELECTED,1-tp,desc)
				end
			end
		end
	end
end
function s.tgfilter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local fid=tc:GetFieldID()
	if tc then
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.aclimit)
		e1:SetLabel(code)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,1,fid)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e2:SetCountLimit(1)
		e2:SetLabel(fid)
		e2:SetLabelObject(tc)
		e2:SetOperation(s.thop)
		e2:SetReset(RESET_PHASE+PHASE_STANDBY)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsOriginalCodeRule(e:GetLabel())
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	if tc and tc:IsLocation(LOCATION_GRAVE) and tc:GetFlagEffectLabel(id)==fid then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
