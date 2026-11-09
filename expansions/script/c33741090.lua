--Anifriends Black Mamba
function c33741090.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c33741090.sprcon)
	c:RegisterEffect(e1)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BATTLE_DAMAGE)
	e0:SetOperation(c33741090.damop)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES_OPPO+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c33741090.regcon)
	e2:SetOperation(c33741090.regop)
	c:RegisterEffect(e2)
	--
	if not c33741090.global_check then
		c33741090.global_check=true
		c33741090.effect_code={[0]={},[1]={}}
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetOperation(c33741090.clear)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c33741090.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c33741090.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return #c33741090.effect_code[tp]>=7 and Duel.GetFlagEffect(tp,33741090)==0 and Duel.GetMZoneCount(tp)>0
end
function c33741090.damop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then
		e:GetHandler():RegisterFlagEffect(33741090,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c33741090.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(33741090)>0
end
function c33741090.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c33741090.tgcon)
	e1:SetOperation(c33741090.tgop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c33741090.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c33741090.chkfilter(c)
	return c:IsSetCard(0x442) and not c:IsPublic()
end
function c33741090.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c33741090.chkfilter,tp,LOCATION_HAND,0,1,nil) or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 or not Duel.SelectYesNo(tp,aux.Stringid(33741090,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c33741090.chkfilter,tp,LOCATION_HAND,0,1,Duel.GetFieldGroupCount(tp,0,LOCATION_HAND),nil)
	Duel.ConfirmCards(1-tp,cg)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=g:Select(tp,#cg,#cg,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	Duel.Draw(1-tp,#sg+1,REASON_EFFECT)
end
function c33741090.clear(e,tp,eg,ep,ev,re,r,rp)
	c33741090.effect_code={[0]={},[1]={}}
end
function c33741090.checkop(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE)
	local ct=c33741090.effect_code[rp][code] and c33741090.effect_code[rp][code]+1 or 1
	if ct>1 then Duel.RegisterFlagEffect(rp,33741090,RESET_PHASE+PHASE_END,0,1) end
	c33741090.effect_code[rp][code]=ct
end
