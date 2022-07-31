--蹈险之烬羽·瑾
local m=11451733
local cm=_G["c"..m]
function cm.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DISCARD)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	if not EMBELLER_CHECK then
		EMBELLER_CHECK=true
		--decrease hand limit
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_END)
		ge1:SetOperation(cm.limit)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.limit(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	local ct=Duel.GetTurnCount()
	local eset={Duel.IsPlayerAffectedByEffect(p,EFFECT_HAND_LIMIT)}
	local flag=Duel.GetFlagEffectLabel(tp,11451731) or 0
	if #eset==0 and flag>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_HAND_LIMIT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(6-flag)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		Duel.RegisterEffect(e1,tp)
	elseif #eset>0 and flag>0 then
		for _,te in pairs(eset) do
			local val=te:GetValue()
			if aux.GetValueType(val)=="function" then
				te:SetValue(function(e,c) if Duel.GetTurnCount()==ct then return val(e,c)-flag else return val(e,c) end end)
			elseif aux.GetValueType(val)=="number" then
				te:SetValue(function(e,c) if Duel.GetTurnCount()==ct then return val-flag else return val end end)
			end
		end
	end
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_HAND_LIMIT)}
	local flag=Duel.GetFlagEffectLabel(tp,11451731) or 0
	local ht=6
	for _,te in pairs(eset) do ht=te:GetValue() end
	if chk==0 then return ht>=flag+2 end
	--limit
	flag=flag+2
	Duel.ResetFlagEffect(tp,11451731)
	local ct=math.max(math.min(flag+5,16),0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(11451731,ct))
	e1:SetLabel(flag)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(0x10000000+11451731)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.thfilter(c)
	return c:IsSetCard(0x6977) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
function cm.matfilter(c,tp)
	return ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove(tp,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO))) and c:IsSetCard(0x6977) and c:IsType(TYPE_MONSTER)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil,mg)
	local tc=g:GetFirst()
	if tc then
		--[[local _SetSynchroMaterial=Duel.SetSynchroMaterial
		Duel.SetSynchroMaterial=function(g)
									for tc in aux.Next(g) do
										local e1=Effect.CreateEffect(c)
										e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
										e1:SetType(EFFECT_TYPE_SINGLE)
										e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
										e1:SetValue(LOCATION_REMOVED)
										e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
										tc:RegisterEffect(e1,true)
									end
									_SetSynchroMaterial(g)
									Duel.SetSynchroMaterial=_SetSynchroMaterial
								end--]]
		local _SendtoGrave=Duel.SendtoGrave
		Duel.SendtoGrave=function(g,r)
							if r==REASON_MATERIAL+REASON_SYNCHRO then
								Duel.Remove(g,POS_FACEUP,r)
								Duel.SendtoGrave=_SendtoGrave
							else
								_SendtoGrave(g,r)
							end
						end
		Duel.SynchroSummon(tp,tc,nil,mg)
	end
end