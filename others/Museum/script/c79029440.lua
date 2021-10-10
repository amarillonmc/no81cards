--黑钢国际·行动-代号·集结
function c79029440.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,79029440)
	e1:SetTarget(c79029440.drtg)
	e1:SetOperation(c79029440.drop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,19029440)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029440.sptg)
	e2:SetOperation(c79029440.spop)
	c:RegisterEffect(e2)
end
function c79029440.ckfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1904)
end
function c79029440.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c79029440.ckfil,tp,LOCATION_MZONE,0,nil)
	local x=g:GetClassCount(Card.GetCode)
	if chk==0 then return x>0 and Duel.IsPlayerCanDraw(tp,x) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(x)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,x)
end
function c79029440.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029440.splimit)
	Duel.RegisterEffect(e1,tp)
	if Duel.CheckLPCost(tp,2000) and Duel.SelectYesNo(tp,aux.Stringid(79029440,0)) then 
	Duel.BreakEffect()
	Duel.PayLPCost(tp,2000)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetOperation(c79029440.negop1)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp) 
	end
end
function c79029440.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xa900) and c:IsLocation(LOCATION_EXTRA)
end
function c79029440.negop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:GetControler()~=tp and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	Duel.NegateEffect(ev)
	e:Reset()
	end
end
function c79029440.scfil(c)
	return c:IsSynchroSummonable(nil) and c:IsSetCard(0x1904)
end
function c79029440.xyfil(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0x1904)
end
function c79029440.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c79029440.scfil,tp,LOCATION_EXTRA,0,1,nil,nil)
	local b2=Duel.IsExistingMatchingCard(c79029440.xyfil,tp,LOCATION_EXTRA,0,1,nil,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
	op=Duel.SelectOption(tp,aux.Stringid(79029440,1),aux.Stringid(79029440,2))
	elseif b1 then
	op=Duel.SelectOption(tp,aux.Stringid(79029440,1))
	else
	op=Duel.SelectOption(tp,aux.Stringid(79029440,2))+1 
	end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029440.spop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
	local g=Duel.GetMatchingGroup(c79029440.scfil,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
	else
	local g=Duel.GetMatchingGroup(c79029440.xyfil,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil) 
	end
	end
end








