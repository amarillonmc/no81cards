local m=53799249
local cm=_G["c"..m]
cm.name="食腐者 YUKHRK"
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,3,function(g,lc)return g:IsExists(Card.IsLinkRace,1,nil,RACE_WARRIOR)end)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)end)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end end)
	e1:SetTarget(cm.sstg)
	e1:SetOperation(cm.ssop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1 end)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(cm.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():GetFlagEffect(m)~=0 end)
	e4:SetValue(1000)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():GetFlagEffect(m)~=0 end)
	e5:SetTarget(cm.rctg)
	e5:SetOperation(cm.rcop)
	c:RegisterEffect(e5)
end
function cm.ssfilter(c)
	return (c:IsType(TYPE_FIELD) or c:GetType()&0x20002==0x20002) and c:IsSSetable()
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ssfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)~=0 then return end
	Duel.RegisterFlagEffect(tp,m,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.ssfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(cm.accon)
		tc:RegisterEffect(e1)
	end
end
function cm.accon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return c:IsFaceup() and c:IsCode(m) and c:IsType(TYPE_LINK)end,tp,LOCATION_ONFIELD,0,nil)
	if #g==0 then return true end
	for tc in aux.Next(g) do
		local lg=tc:GetLinkedGroup()
		if #lg==3 and not lg:IsExists(Card.IsCode,1,nil,m) and lg:GetClassCount(Card.GetCode)==3 then return false end
	end
	return true
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if #g==3 and not g:IsExists(aux.NOT(Card.IsLinkRace),2,nil,RACE_WARRIOR) then e:GetLabelObject():SetLabel(1) else e:GetLabelObject():SetLabel(0) end
end
function cm.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local rec=bc:GetBaseAttack()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function cm.rcop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
