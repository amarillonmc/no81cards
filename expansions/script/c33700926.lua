--鲸落
function c33700926.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c33700926.cost)
	c:RegisterEffect(e1)  
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700926,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(function(e,tp) return Duel.GetTurnPlayer()==tp end)
	e2:SetTarget(c33700926.tgtg)
	e2:SetOperation(c33700926.tgop)
	c:RegisterEffect(e2)  
	e2:SetLabelObject(e1)
end
function c33700926.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ac=e:GetLabelObject():GetLabel()
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ac)
end
function c33700926.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local p,val=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.DiscardDeck(p,val,REASON_EFFECT)<=0 then return end
	local g=Duel.GetOperatedGroup()
	local fid=c:GetFieldID()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e1:SetLabel(fid)
	e1:SetCondition(c33700926.spcon)
	e1:SetOperation(c33700926.spop)
	e1:SetReset(RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e1,tp)
	for tc in aux.Next(g) do 
		if tc:IsType(TYPE_MONSTER) then
			tc:RegisterFlagEffect(33700926,RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2,fid)
		elseif tc:GetType()==TYPE_SPELL then
			local ae=tc:GetActivateEffect()
			if tc:GetLocation()==LOCATION_GRAVE and ae then
				local e1=Effect.CreateEffect(tc)
				e1:SetDescription(ae:GetDescription())
				e1:SetType(EFFECT_TYPE_IGNITION)
				e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
				e1:SetCountLimit(1,33700926)
				e1:SetRange(LOCATION_GRAVE)
				e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
				e1:SetCondition(c33700926.spellcon)
				e1:SetTarget(c33700926.spelltg)
				e1:SetOperation(c33700926.spellop)
				tc:RegisterEffect(e1)
			end 
		end
	end
end
function c33700926.spellcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end
function c33700926.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ae=e:GetHandler():GetActivateEffect()
	local ftg=ae:GetTarget()
	if chk==0 then
		return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	if ae:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else e:SetProperty(0) end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c33700926.spellop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetHandler():GetActivateEffect()
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function c33700926.spfilter(c,e,tp)
	return c:GetFlagEffectLabel(33700926)==e:GetLabel() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700926.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33700926.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and tp==Duel.GetTurnPlayer()
end
function c33700926.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_CARD,0,33700926)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33700926.spfilter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c33700926.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,3000)/1000)
	local t={}
	for i=1,m do
		t[i]=i*1000
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	e:SetLabel(ac/1000)
end