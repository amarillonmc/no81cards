--Re:SURGUM 面对于它
local m=60001079
local cm=_G["c"..m]

function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--effectgain
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,0))
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_CHAIN_SOLVING)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(cm.negcon)
	e8:SetOperation(cm.negop)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e9:SetRange(LOCATION_FZONE)
	e9:SetTargetRange(LOCATION_MZONE,0)
	e9:SetTarget(cm.eftg)
	e9:SetLabelObject(e8)
	c:RegisterEffect(e9)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCost(cm.cost)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.activate)
	c:RegisterEffect(e4)
	if not cm.surgum_check then
		cm.surgum_check=true
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
		e0:SetOperation(cm.flagcheck)
		c:RegisterEffect(e0)
	end
end

function cm.flagcheck(e,tp)
	local i=1
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0xff,0xff,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(m,0,0,1,10*m+tc:GetCode()+200*i)
			i=i+1
			tc=g:GetNext()
		end
	end
end

function cm.eftg(e,c)
	return c:IsSetCard(0x6621) and c:IsType(TYPE_MONSTER)
end

function cm.negcostfilter(c)
	return ((c:IsLocation(LOCATION_HAND) and c:IsAbleToGrave()) or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToDeck())) and c:IsOriginalCodeRule(24094653)
end

function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and rp==1-tp and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0 and 
	Duel.IsExistingMatchingCard(cm.negcostfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and 
	c:GetFlagEffect(c:GetFlagEffectLabel(m))==0
end

function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local k=c:GetCode()
	Debug.Message(k)
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_CARD,0,k)
		if Duel.NegateEffect(ev) and Duel.IsExistingMatchingCard(cm.negcostfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local g=Duel.SelectMatchingCard(tp,cm.negcostfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				if tc:IsLocation(LOCATION_HAND) then
					Duel.SendtoGrave(tc,REASON_EFFECT)
				else
					Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
				end
			end
		end
		c:RegisterFlagEffect(c:GetFlagEffectLabel(m),RESET_EVENT+RESETS_STANDARD,0,1)
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	end
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST,nil)
end

function cm.opsfilter(c,e,tp)
	return c:IsSetCard(0x6621) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_TUNER)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.opsfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and 
	Duel.GetLocationCountFromEx(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCountFromEx(tp)>0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.opsfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_EXTRA)
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	Duel.RegisterEffect(e2,tp)
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x6621)
end