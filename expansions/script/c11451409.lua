--traveler saga mirageruin
--21.04.10
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--canttg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(cm.tglimit)
	--c:RegisterEffect(e2)
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_CUSTOM+11451409)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.con)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ADJUST)
	e6:SetRange(LOCATION_SZONE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetOperation(cm.merge)
	--c:RegisterEffect(e6)
	local e5=e4:Clone()
	e5:SetCode(11451409)
	--e5:SetCondition(cm.con2)
	--c:RegisterEffect(e5)
	--Equip limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_EQUIP_LIMIT)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--[[if not PNFL_SP_ACTIVATE then
		PNFL_SP_ACTIVATE=true
		local _MoveToField=Duel.MoveToField
		function Duel.MoveToField(tc,...)
			local res=_MoveToField(tc,...)
			local te=tc:GetActivateEffect()
			if te then
				local fid=tc:GetFieldID()
				local cost=te:GetCost() or aux.TRUE
				local cost2=function(e,tp,eg,ep,ev,re,r,rp,chk)
								if chk==0 then return cost(e,tp,eg,ep,ev,re,r,rp,0) end
								cost(e,tp,eg,ep,ev,re,r,rp,1)
								if fid==tc:GetFieldID() then
									Duel.RaiseEvent(tc,11451409,te,0,tp,tp,Duel.GetCurrentChain())
								end
								e:SetCost(cost)
							end
				te:SetCost(cost2)
			end
			return res
		end
	end--]]
	if not PNFL_TOFIELD_CHECK then
		PNFL_TOFIELD_CHECK=true
		local _Equip=Duel.Equip
		Duel.Equip=function(p,c,...)
			if not (c:IsControler(p) and c:IsLocation(LOCATION_SZONE)) then c:RegisterFlagEffect(11451409,RESET_CHAIN,0,1) c:RegisterFlagEffect(11451409,RESET_CHAIN,0,1) end
			local res=_Equip(p,c,...)
			if c:IsHasEffect(EFFECT_EQUIP_LIMIT) then
				c:ResetFlagEffect(11451409)
				cm.desop2(e,0,Group.FromCards(c),0,0,e,0,0)
			end
			return res
		end
		local _CRegisterEffect=Card.RegisterEffect
		function Card.RegisterEffect(c,e,bool)
			local res=_CRegisterEffect(c,e,bool)
			if e:GetCode()==EFFECT_EQUIP_LIMIT and c:GetFlagEffect(11451409)>0 then
				c:ResetFlagEffect(11451409)
				cm.desop2(e,0,Group.FromCards(c),0,0,e,0,0)
			end
			return res
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetCondition(cm.descon)
		e1:SetOperation(cm.desop2)
		Duel.RegisterEffect(e1,0)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e2,0)
		local e11=e1:Clone()
		e11:SetCode(EVENT_SUMMON_NEGATED)
		Duel.RegisterEffect(e11,0)
		local e21=e1:Clone()
		e21:SetCode(EVENT_SPSUMMON_NEGATED)
		Duel.RegisterEffect(e21,0)
		local e3=e1:Clone()
		e3:SetCode(EVENT_MOVE)
		Duel.RegisterEffect(e3,0)
		local e4=e1:Clone()
		e4:SetCode(EVENT_CHAINING)
		e4:SetCondition(cm.descon3)
		e4:SetOperation(cm.desop3)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_SUMMON)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetTargetRange(1,1)
		e5:SetTarget(cm.costchk)
		Duel.RegisterEffect(e5,0)
	end
end
cm.traveler_saga=true
function cm.costchk(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_DUAL)~=SUMMON_TYPE_DUAL then return false end
	if c:GetFlagEffect(11451409)==0 then c:RegisterFlagEffect(11451409,RESET_EVENT+RESETS_STANDARD,0,1) end
	return false
end
function cm.filter12(c,e)
	if not (c:IsOnField() and (c:IsFacedown() or c:IsStatus(STATUS_EFFECT_ENABLED))) or c:GetFlagEffect(11451409)>1 then return false end
	if e:GetCode()==EVENT_MOVE then
		local b1,g1=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
		local b2,g2=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
		return (not b1 or not g1:IsContains(c)) and (not b2 or not g2:IsContains(c)) and not c:IsPreviousLocation(LOCATION_ONFIELD)
	end
	return not ((e:GetCode()==EVENT_SUMMON_SUCCESS or e:GetCode()==EVENT_SUMMON_NEGATED) and c:GetFlagEffect(11451409)>0) and not c:IsPreviousLocation(LOCATION_SZONE)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter12,1,nil,e)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()>0 and Duel.GetFlagEffect(0,11451409)==0 then
		cm.desop3(e,tp,eg,ep,ev,re,r,rp)
	else
		Duel.RaiseEvent(eg,EVENT_CUSTOM+11451409,re,r,rp,ep,ev)
	end
end
function cm.descon3(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetFieldID()==re:GetHandler():GetRealFieldID()
end
function cm.desop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+11451409,re,r,rp,ep,ev)
end
function cm.merge(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if not tc then return end
	if tc:GetFlagEffect(m+0xffffff+c:GetFieldID())==0 then
		tc:RegisterFlagEffect(m+0xffffff+c:GetFieldID(),RESET_EVENT+RESETS_STANDARD,0,1,tc:GetAttack())
	end
	if tc:GetAttack()>tc:GetFlagEffectLabel(m+0xffffff+c:GetFieldID()) then Duel.RaiseEvent(tc,EVENT_CUSTOM+m,re,r,rp,ep,ev) end
	tc:SetFlagEffectLabel(m+0xffffff+c:GetFieldID(),tc:GetAttack())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and eg:IsExists(function(c) return (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsLocation(LOCATION_SZONE)) and c:IsOnField() end,1,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,1,nil)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,1,nil)
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if og:IsExists(Card.IsType,2,nil,TYPE_MONSTER) or og:IsExists(Card.IsType,2,nil,TYPE_SPELL) or og:IsExists(Card.IsType,2,nil,TYPE_TRAP) then
		local g2=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		if #g2>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g2:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
	--[[if og:IsExists(Card.IsType,1,nil,TYPE_MONSTER) and c:GetFlagEffect(m+9)==0 then
		c:RegisterFlagEffect(m+9,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	end
	if og:IsExists(Card.IsType,1,nil,TYPE_SPELL) and c:GetFlagEffect(m+10)==0 then
		c:RegisterFlagEffect(m+10,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	end
	if og:IsExists(Card.IsType,1,nil,TYPE_TRAP) and c:GetFlagEffect(m+11)==0 then
		c:RegisterFlagEffect(m+11,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	end--]]
end
function cm.tglimit(e,re,rp)
	local c=e:GetHandler()
	return (c:GetFlagEffect(m+9)>0 and re:IsActiveType(TYPE_MONSTER)) or (c:GetFlagEffect(m+10)>0 and re:IsActiveType(TYPE_SPELL)) or (c:GetFlagEffect(m+11)>0 and re:IsActiveType(TYPE_TRAP))
end