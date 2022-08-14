local m=25000012
local cm=_G["c"..m]
cm.name="百年孤独"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.cfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_NORMAL) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetRace(),c:GetAttribute())
end
function cm.thfilter(c,rac,att)
	return c:IsRace(rac) and not c:IsAttribute(att) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,tp) and Duel.IsPlayerCanSummon(tp)
	end
	local rc=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,tp):GetFirst()
	Duel.SetTargetParam(rc:GetRace())
	Duel.RegisterFlagEffect(tp,m+Duel.GetCurrentChain()*10000,RESET_CHAIN,0,1,rc:GetAttribute())
	local c=e:GetHandler()
	for i=1,100 do
		if c:GetFlagEffect(m+i*10000)==0 then
			c:RegisterFlagEffect(m+i*10000,RESET_EVENT+RESETS_STANDARD,0,0,rc:GetCode())
			break
		end
	end
	Duel.Release(rc,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local rac,att=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM),Duel.GetFlagEffectLabel(tp,m+Duel.GetCurrentChain()*10000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,rac,att):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		if not tc:IsSummonable(true,nil) then return end
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetOperation(cm.regop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_NEGATED)
		e2:SetOperation(cm.rstop)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
		Duel.Summon(tp,tc,true,nil)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc,res=e:GetHandler(),eg:GetFirst(),false
	for i=1,100 do
		if c:GetFlagEffect(m+i*10000)==0 then break end
		if tc:GetCode()==c:GetFlagEffectLabel(m+i*10000) then res=true end
	end
	if not res then return end
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,POS_FACEDOWN)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	e:Reset()
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():Reset() end
	e:Reset()
end
