--鸿园的君主
local m=33310400
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(cm.spcon)
	e0:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e0)   

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.efftg)
	e1:SetOperation(cm.effop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(cm.reptg)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.stcon)
	e3:SetOperation(cm.stop)
	c:RegisterEffect(e3)
 
end
function cm.spfilter(c)
	return c:IsFaceupEx() and c.is_xs and c:IsType(TYPE_MONSTER)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function cm.filter(c,e,tp,eg,ep,ev,re,r,rp)
	if not c.is_xs and c:IsType(TYPE_MONSTER) then return false end
	local tre,trp,tev=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_CHAIN_ID)
	local te=c.resolve 
	if te then 
		if te:IsHasType(EFFECT_TYPE_IGNITION) then
			return not te:GetTarget() or te:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0)
		else
			return (not te:GetCondition() or te:GetCondition()(e,tp,eg,ep,tev-1,tre,r,trp)) and (not te:GetTarget() or te:GetTarget()(e,tp,eg,ep,tev-1,tre,r,trp,0))
		end
	end
	return false
end
function cm.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	aux.SelectFromOptions(tp,{true,aux.Stringid(m,1)})
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp,eg,ep,ev,re,r,rp)
	if #g==0 then 
		aux.SelectFromOptions(tp,{true,aux.Stringid(m,4)})
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(cm.atkval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		local te=tc.resolve
		Duel.ClearTargetCard()
		e:SetProperty(te:GetProperty())
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		tc:CreateEffectRelation(te)
		local tre,trp,tev=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_CHAIN_ID)
		if te:GetTarget() then te:GetTarget()(te,tp,eg,ep,tev-1,tre,r,trp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and g:GetCount()>0 then
			local tg=g:GetFirst()
			while tg do
				tg:CreateEffectRelation(te)
				tg=g:GetNext()
			end
		end
		if te:GetOperation() then te:GetOperation()(e,tp,eg,ep,tev-1,tre,r,trp) end
		tc:ReleaseEffectRelation(te)
		if g and g:GetCount()>0 then
			tg=g:GetFirst()
			while tg do
				tg:ReleaseEffectRelation(te)
				tg=g:GetNext()
			end
		end
		local at,tg=Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE,true)
		if at and tg and tg:IsContains(c) then --and c:GetBattleTarget() then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				--Duel.CalculateDamage(tc,c:GetBattleTarget()) 
				aux.SelectFromOptions(tp,{true,aux.Stringid(m,3)})
			end
		end
	end
end
function cm.damtg(e,c)
	return c==e:GetLabelObject()
end

function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and re)) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,5))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	--e2:SetCondition(cm.lpcon)
	e2:SetOperation(cm.lpop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)-2000)
end

function cm.stcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local tc2=Duel.GetAttackTarget()
	return tc.is_xs
end
function cm.stfilter(c)
	return c:IsCode(33310450) and not c:IsForbidden()
end
function cm.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end