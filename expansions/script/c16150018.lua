--天命之启示 大王术使
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16150018,"TENMEIDAIOUJYUTSUTSUKAI")
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,m) 
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2) 
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,1000+m)
	e3:SetCost(cm.cost)
	e3:SetCondition(cm.discon)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
	--change
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_CONTROL+CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_SPSUMMON)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,100+m)
	e4:SetCost(cm.cost)
	e4:SetCondition(cm.condition1)
	e4:SetTarget(cm.target1)
	e4:SetOperation(cm.operation1)
	c:RegisterEffect(e4)
	local e4_1=e4:Clone()
	e4_1:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e4_1)
	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,3))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m)
	e5:SetCost(cm.cost)
	e5:SetCondition(cm.con1)
	e5:SetTarget(cm.acttg)
	e5:SetOperation(cm.actop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCondition(cm.con2)
	c:RegisterEffect(e6)
end
function cm.rfilter(c)
	return rk.check(c,"DAIOUGU") and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function cm.sprfilter(c,sc)
	local g=c:GetEquipGroup()
	return g and g:IsExists(cm.rfilter,1,nil) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsReleasable()
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil,c)
	return g and g:GetCount()>0
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=g:Select(tp,1,1,nil,c)
	local mc=g1:GetFirst()
	local tg=mc:GetEquipGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=tg:FilterSelect(tp,Card.IsAbleToHandAsCost,1,#tg,nil)
	Duel.SendtoHand(g2,tp,REASON_COST)
	Duel.Release(g1,REASON_COST)
end 
function cm.costfilter2(c,tp)
	return c:IsType(TYPE_SPELL) and (c:IsFaceup() or c:IsControler(tp)) and c:IsReleasable()
end 
function cm.costfilter3(c)
	return c:IsReleasable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.costfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	if c:GetEquipGroup() and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,16150020) then
		local g2=Duel.GetReleaseGroup(tp,true)
		local g3=Duel.GetMatchingGroup(cm.costfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
		g:Merge(g2)
		g:Merge(g3)
	end
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:Select(tp,1,1,nil)
	Duel.Release(sg,REASON_COST)
	sg:KeepAlive()
	e:SetLabelObject(sg)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) or (e:GetHandler():GetEquipGroup() and e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,16150020)))
		and Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function cm.ctfilter(c,tp)
	return (c:IsControlerCanBeChanged() or (Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0 and c:CheckUniqueOnField(tp) and c:IsControlerCanBeChanged(false))) and c:IsControler(1-tp)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.ctfilter,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,eg,1,0,0)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(cm.ctfilter,nil,tp)
	local c=e:GetHandler()
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,0)
	local ct2=Duel.GetLocationCount(tp,LOCATION_SZONE,0)
	if sg:GetCount()>0 then
		if sg:GetCount()<ct then ct=sg:GetCount() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
		local g=sg:Select(tp,1,ct+ct2,nil)
		for tc in aux.Next(g) do
			Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
			local op=2
			local a=c:IsControlerCanBeChanged()
			local b=Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0 and c:CheckUniqueOnField(tp) and c:IsControlerCanBeChanged(false)
			if a and b then
				op=Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5))
			elseif a then
				op=Duel.SelectOption(tp,aux.Stringid(m,4))
			else	
				op=Duel.SelectOption(tp,aux.Stringid(m,5))+1
			end
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_ADJUST)
			e0:SetRange(LOCATION_MZONE)
			e0:SetReset(RESET_EVENT+0x7e0000)
			e0:SetCondition(function (e,tp)
								return e:GetHandler():IsLocation(LOCATION_MZONE)
							end
							)
			tc:RegisterEffect(e0,true)
			if op==0 then
			e0:SetOperation(	function (e,sp)
									Duel.GetControl(tc,tp)
								end
							)
			elseif op==1 then
			e0:SetOperation(	function (e,sp)
									
				if not Duel.Equip(tp,tc,c,false,true) then return end
				--equip limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetLabelObject(c)
				e1:SetValue(cm.eqlimit)
				tc:RegisterEffect(e1,true)
								end
							)
			end
		end
		Duel.EquipComplete()
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.con2(e,tp)
	return not Duel.IsPlayerAffectedByEffect(tp,16150008) 
end
function cm.con1(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,16150008)
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function cm.eqfilter(c,tp)
	return (rk.check(c,"DAIOU") or rk.check(c,"OUMEI") or c:IsSetCard(0xccd)) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cm.actop(e,tp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.eqfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if not Duel.Equip(tp,tc,c) then return end
			--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(c)
			e1:SetValue(cm.eqlimit)
			tc:RegisterEffect(e1)
		end
	end
	local rc=e:GetLabelObject():GetFirst()
	if rk.check(rc,"OUMEI") or c:IsSetCard(0xccd) then
		local te=rc:GetActivateEffect()
		local tep=rc:GetControler()
		if not te then
			return 
		else
			local condition=te:GetCondition()
			local cost=te:GetCost()
			local target=te:GetTarget()
			local operation=te:GetOperation()
			if te:IsActivatable(tep)
				and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
				and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
				and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) and operation and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
				Duel.ClearTargetCard()
				e:SetProperty(te:GetProperty())
				Duel.Hint(HINT_CARD,0,rc:GetOriginalCode())
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if g and g:GetCount()>0 then
					local ac=g:GetFirst()
					while ac do
						ac:CreateEffectRelation(te)
						ac=g:GetNext()
					end
				end
				if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
				if g and g:GetCount()>0 then
					local sc=g:GetFirst()
					while sc do
						sc:ReleaseEffectRelation(te)
						sc=g:GetNext()
					end
				end
			end
		end
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end