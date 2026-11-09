--Anifriends Boomslang
function c33741091.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c33741091.sprcon)
	c:RegisterEffect(e1)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BATTLE_DAMAGE)
	e0:SetOperation(c33741091.damop)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c33741091.regcon)
	e2:SetOperation(c33741091.regop)
	c:RegisterEffect(e2)
	--
	if not c33741091.global_check then
		c33741091.global_check=true
		c33741091.effect_code={[0]={},[1]={}}
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetOperation(c33741091.clear)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c33741091.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c33741091.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return #c33741091.effect_code[tp]>=7 and Duel.GetFlagEffect(tp,33741091)==0 and Duel.GetMZoneCount(tp)>0
end
function c33741091.damop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then
		e:GetHandler():RegisterFlagEffect(33741091,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c33741091.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(33741091)>0
end
function c33741091.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnPlayer()==tp and 2 or 3
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(c33741091.tgcon)
	e1:SetOperation(c33741091.tgop)
	e1:SetReset(RESET_PHASE+PHASE_END,ct)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	Duel.RegisterEffect(e3,tp)
	local ce1=e1:Clone()
	ce1:SetCode(EVENT_CHAINING)
	ce1:SetCondition(c33741091.ctcon)
	ce1:SetOperation(c33741091.ctop)
	ce1:SetLabelObject(e1)
	Duel.RegisterEffect(ce1,tp)
	local ce2=ce1:Clone()
	ce2:SetCode(EVENT_SUMMON_SUCCESS)
	Duel.RegisterEffect(ce2,tp)
	local ce3=ce1:Clone()
	ce3:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(ce3,tp)
end
function c33741091.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetCode()==EVENT_CHAIN_SOLVING and rp~=tp or e:GetCode()~=EVENT_CHAIN_SOLVING and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c33741091.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local b1=ct>0 and Duel.IsPlayerCanDiscardDeck(1-tp,ct)
	local b2=Duel.IsExistingMatchingCard(Card.IsDiscardable,1-tp,LOCATION_HAND,0,1,nil)
	local b3=e:GetCode()==EVENT_CHAIN_SOLVING and Duel.IsChainDisablable(ev)
	local b4=e:GetCode()~=EVENT_CHAIN_SOLVING and aux.NegateSummonCondition(e,tp,eg,ep,ev,re,r,rp)
	if not (b1 or b2 or b3 or b4) then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(33741091,0)},
		{b2,aux.Stringid(33741091,1)},
		{b3,aux.Stringid(33741091,2)},
		{b4,aux.Stringid(33741091,3)})
	if op==1 then
		Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
	elseif op==2 then
		Duel.DiscardHand(1-tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
	elseif op==3 then
		Duel.NegateEffect(ev)
	elseif op==4 then
		Duel.NegateSummon(eg)
	end
end
function c33741091.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetCode()==EVENT_CHAINING and rp~=tp or e:GetCode()~=EVENT_CHAINING and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c33741091.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	e:GetLabelObject():SetLabel(ct+1)
end
function c33741091.clear(e,tp,eg,ep,ev,re,r,rp)
	c33741091.effect_code={[0]={},[1]={}}
end
function c33741091.checkop(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE)
	local ct=c33741091.effect_code[rp][code] and c33741091.effect_code[rp][code]+1 or 1
	if ct>1 then Duel.RegisterFlagEffect(rp,33741091,RESET_PHASE+PHASE_END,0,1) end
	c33741091.effect_code[rp][code]=ct
end
