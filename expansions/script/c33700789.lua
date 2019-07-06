--VOICEROID 缘
if not pcall(function() require("expansions/script/c33700784") end) then require("script/c33700784") end
local m=33700789
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsvo.YukaLinkFunction(c)  
	--tg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetMutualLinkedGroup():FilterCount(Card.IsSetCard,nil,0x144c)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,ct,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=c:GetMutualLinkedGroup():FilterCount(Card.IsSetCard,nil,0x144c)
	if ct<=0 or not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.DiscardDeck(tp,ct,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:GetCount()<=0 then return end
	local fid=c:GetFieldID()
	local rct=1
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then rct=2 end
	for tc in aux.Next(g) do
		if tc:IsControler(tp) then
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,rct,fid)
		else
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,0,rct,fid)
		end
	end
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
	   e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	   e1:SetValue(Duel.GetTurnCount())
	else
	   e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	   e1:SetValue(0)
	end
	Duel.RegisterEffect(e1,tp)
end
function cm.spcfilter(c,fid,e,tp)
	return c:GetFlagEffectLabel(m)==fid and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
	local g=e:GetLabelObject()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=g:Filter(cm.spcfilter,nil,e:GetLabel(),e,tp)
	if sg:GetCount()<=0 or ft<=0 or (ft>=2 and sg:GetCount()>=2 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(cm.spcfilter,nil,e:GetLabel(),e,tp)
	g:DeleteGroup()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	ft=math.min(sg:GetCount(),ft)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=sg:Select(tp,ft,ft,nil)
	Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
end

