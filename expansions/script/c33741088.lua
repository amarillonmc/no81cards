--Anifriends Amazon Tree Boa
function c33741088.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c33741088.sprcon)
	c:RegisterEffect(e1)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BATTLE_DAMAGE)
	e0:SetOperation(c33741088.damop)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c33741088.regcon)
	e2:SetOperation(c33741088.regop)
	c:RegisterEffect(e2)
	--
	if not c33741088.global_check then
		c33741088.global_check=true
		c33741088.effect_code={[0]={},[1]={}}
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetOperation(c33741088.clear)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c33741088.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c33741088.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return #c33741088.effect_code[tp]>=5 and Duel.GetFlagEffect(tp,33741088)==0 and Duel.GetMZoneCount(tp)>0
end
function c33741088.damop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then
		e:GetHandler():RegisterFlagEffect(33741088,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c33741088.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(33741088)>0
end
function c33741088.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c33741088.tgcon)
	e1:SetOperation(c33741088.tgop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c33741088.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c33741088.tgfilter(c)
	return c:IsSetCard(0x442) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGrave()
end
function c33741088.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c33741088.tgfilter,tp,LOCATION_DECK,0,1,nil) or not Duel.SelectYesNo(tp,aux.Stringid(33741088,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c33741088.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_GRAVE) then return end
	Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
end
function c33741088.clear(e,tp,eg,ep,ev,re,r,rp)
	c33741088.effect_code={[0]={},[1]={}}
end
function c33741088.checkop(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE)
	local ct=c33741088.effect_code[rp][code] and c33741088.effect_code[rp][code]+1 or 1
	if ct>1 then Duel.RegisterFlagEffect(rp,33741088,RESET_PHASE+PHASE_END,0,1) end
	c33741088.effect_code[rp][code]=ct
end
