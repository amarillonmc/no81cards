--「星光歌剧」台本-舞台少女心得
--if not pcall(function() require("expansions/script/c64839999") end) then require("script/c64839999") end
--local m,cm=rscf.DefineCard(64832037)
--function cm.initial_effect(c)
	--local e1=rsef.ACT(c)
	--local e2=rsef.I(c,{m,0},{1,m},nil,nil,LOCATION_SZONE,nil,rscost.cost(cm.tgfilter,"tg",rsloc.hd),nil,cm.limitop)
	--local e3=rsef.FV_INDESTRUCTABLE(c,"ct",nil,aux.TargetBoolFunction(Card.IsSummonType,SUMMON_TYPE_ADVANCE),{LOCATION_MZONE,0},nil,nil,"sa")
	--local e4=rsef.FTO(c,EVENT_PHASE+PHASE_END,{m,1},{1,m+1},nil,"tg",LOCATION_SZONE,nil,nil,rstg.target(cm.setfilter,nil,LOCATION_GRAVE),cm.setop)
--end
--function cm.setfilter(c)
	--return c:IsSetCard(0x6410) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
--end
--function cm.setop(e,tp)
	--local c=rscf.GetSelf(e)
	--local tc=rscf.GetTargetCard()
	--if not c or not tc or Duel.SSet(tp,tc)<=0 then return end   
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	--e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	--e1:SetValue(LOCATION_REMOVED)
	--tc:RegisterEffect(e1)
--end
--function cm.tgfilter(c)
	--return c:IsSetCard(0x6410) and c:IsAbleToGraveAsCost()
--end
--function cm.limitop(e,tp)
	--if not rscf.GetSelf(e) then return end
	--local e1=Effect.CreateEffect(e:GetHandler())
	--e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e1:SetCode(EVENT_SUMMON_SUCCESS)
	--e1:SetOperation(cm.sumsuc)
	--e1:SetReset(RESET_PHASE+PHASE_END)
	--Duel.RegisterEffect(e1,tp)
--end
--function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	--if not eg:GetFirst():IsSummonType(SUMMON_TYPE_ADVANCE) then return end
	--Duel.SetChainLimitTillChainEnd(cm.limit)
--end
--function cm.limit(e,ep,tp)
	--return ep==tp
--end

local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.efcost)
	e1:SetOperation(cm.efop)
	c:RegisterEffect(e1)
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.indtg)
	e1:SetValue(cm.indct)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SSET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m+10000000)
	e3:SetCondition(cm.sscon)
	e3:SetTarget(cm.sstg)
	e3:SetOperation(cm.ssop)
	c:RegisterEffect(e3)
end

function cm.costfilter(c)
	return c:IsSetCard(0x6410) and c:IsAbleToGraveAsCost()
end
function cm.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.limcon)
	e2:SetOperation(cm.limop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetOperation(cm.limop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end

function cm.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.limfil,1,e:GetHandler())
end
function cm.limfil(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsSummonPlayer(c:GetOwner())
end
function cm.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(cm.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(cm.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(m)
	e:Reset()
end
function cm.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(m)~=0 then
		Duel.SetChainLimitTillChainEnd(cm.chainlm)
	end
	e:GetHandler():ResetFlagEffect(m)
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end

function cm.indtg(e,c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end

function cm.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.ssfilter(c,e,tp)
	return c:IsSetCard(0x6410) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.ssfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(cm.ssfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,cm.ssfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SSET,g,1,0,0)
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1,true)
	end
end




