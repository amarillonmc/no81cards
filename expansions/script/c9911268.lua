--连接新月世界的漏洞
function c9911268.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9911268+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911268.target)
	e1:SetOperation(c9911268.activate)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911268,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CUSTOM+9911268)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c9911268.mvcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9911268.mvtg)
	e2:SetOperation(c9911268.mvop)
	c:RegisterEffect(e2)
	if not c9911268.global_check then
		c9911268.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetCondition(c9911268.regcon)
		ge1:SetOperation(c9911268.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911268.cfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp)
		and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=tp)
end
function c9911268.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(c9911268.cfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c9911268.cfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c9911268.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,9911268)
	Duel.RaiseEvent(g,EVENT_CUSTOM+9911268,re,r,rp,ep,e:GetLabel())
end
function c9911268.thfilter(c)
	return c:IsSetCard(0x9956) and c:IsAbleToHand()
end
function c9911268.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911268.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911268.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c9911268.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9911268.mvcon1)
	e1:SetOperation(c9911268.mvop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetLabelObject(g)
	e3:SetCondition(c9911268.regcon2)
	e3:SetOperation(c9911268.regop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetLabelObject(g)
	e5:SetCondition(c9911268.mvcon2)
	e5:SetOperation(c9911268.mvop2)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e6:SetLabelObject(g)
	e6:SetOperation(c9911268.clearop)
	Duel.RegisterEffect(e6,tp)
end
function c9911268.mvcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911268)==0 and eg:IsExists(Card.IsControler,1,nil,tp) and not Duel.IsChainSolving()
end
function c9911268.mvfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c9911268.mvop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,9911268)>0 then return end
	Duel.Hint(HINT_CARD,0,9911268)
	Duel.RegisterFlagEffect(tp,9911268,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911268,0))
	local tc=eg:FilterSelect(tp,c9911268.mvfilter,1,1,nil,tp):GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
function c9911268.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911268)==0 and eg:IsExists(Card.IsControler,1,nil,tp) and Duel.IsChainSolving()
end
function c9911268.regop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Merge(eg:Filter(Card.IsControler,nil,tp))
end
function c9911268.mvcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911268)==0 and e:GetLabelObject():GetCount()>0
end
function c9911268.mvop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,9911268)>0 then return end
	Duel.Hint(HINT_CARD,0,9911268)
	Duel.RegisterFlagEffect(tp,9911268,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local g=e:GetLabelObject()
	local tg=g:Filter(c9911268.mvfilter,nil,tp)
	g:DeleteGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911268,0))
	local tc=tg:Select(tp,1,1,nil):GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
function c9911268.clearop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g then g:DeleteGroup() end
	e:Reset()
end
function c9911268.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return (ev==tp or ev==PLAYER_ALL) and eg:IsContains(e:GetHandler())
end
function c9911268.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetChainLimit(aux.FALSE)
end
function c9911268.mvop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
