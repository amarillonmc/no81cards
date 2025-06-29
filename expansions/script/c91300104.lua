--星间魔法集束
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(s.actcon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkactivate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(1,1)
	e3:SetLabelObject(e2)
	e3:SetTarget(function(e,te,tp)return te==e:GetLabelObject()end)
	e3:SetOperation(s.costop)
	c:RegisterEffect(e3)
end
function s.confilter(c)
	return c:IsCode(91300100) and c:IsFaceup()
end
function s.desfilter(c,e) 
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanBeEffectTarget(e)
end
function s.actcon(e)
	return Duel.IsExistingMatchingCard(s.confilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.spfilter(c,e,tp)
	local b1=c:GetOriginalType()&TYPE_MONSTER>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	local b2=c:GetOriginalType()&TYPE_MONSTER==0 and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPE_MONSTER+TYPE_EFFECT,0,0,0,0,0,POS_FACEUP) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP)
	return b1 or b2
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,0,c,e)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and s.desfilter(chkc,e) end
	if chk==0 then return #g>0 end
	local tg1=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_ONFIELD,0,1,#g,c,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=tg1:Filter(s.spfilter,nil,e,tp)
	if #sg>0 then
		if #sg>ft then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=sg:Select(tp,ft,ft,nil)
		end
		local tg=sg:GetFirst()
		while tg do
			if tg:GetOriginalType()&TYPE_MONSTER==0 then
				local e1=Effect.CreateEffect(tg)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
				e1:SetReset(RESET_EVENT+0x47c0000)
				tg:RegisterEffect(e1,true)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_REMOVE_RACE)
				e2:SetValue(RACE_ALL)
				tg:RegisterEffect(e2,true)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
				e3:SetValue(0xff)
				tg:RegisterEffect(e3,true)
				local e4=e1:Clone()
				e4:SetCode(EFFECT_SET_BASE_ATTACK)
				e4:SetValue(0)
				tg:RegisterEffect(e4,true)
				local e5=e1:Clone()
				e5:SetCode(EFFECT_SET_BASE_DEFENSE)
				e5:SetValue(0)
				tg:RegisterEffect(e5,true)
				tg:SetStatus(STATUS_NO_LEVEL,true)
				cregister=Card.RegisterEffect
				Card.RegisterEffect=function(card,effect,flag)
					if effect:IsActivated() then
						local eff=effect:Clone()
						if eff:GetRange()&(LOCATION_SZONE+LOCATION_PZONE+LOCATION_FZONE)>0 then
							eff:SetRange(LOCATION_MZONE)
						end
						if eff:IsHasType(EFFECT_TYPE_ACTIVATE) then
							eff:SetType(EFFECT_TYPE_QUICK_O)
							if not eff:GetOperation() then return end
						end
						return cregister(card,eff,flag)
					end
					return cregister(card,effect,flag)
				end
				s.proeffects={}
				s.cloneeffects={}
				local _SetProperty=Effect.SetProperty
				local _Clone=Effect.Clone
				Effect.SetProperty=function(pe,prop1,prop2)
					if not prop2 then prop2=0 end
					if prop1&EFFECT_FLAG_UNCOPYABLE~=0 then
						s.proeffects[pe]={prop1,prop2}
						prop1=prop1&(~EFFECT_FLAG_UNCOPYABLE)
					else
						s.proeffects[pe]=nil
					end
					return _SetProperty(pe,prop1,prop2)
				end
				Effect.Clone=function(pe)
					local ce=_Clone(pe)
					s.cloneeffects[ce]=true
					if s.proeffects[pe] then
						s.proeffects[ce]=s.proeffects[pe]
					end
					return ce
				end
				tg:ReplaceEffect(tg:GetOriginalCode(),RESET_EVENT+0x47c0000)
				tg:SetStatus(STATUS_EFFECT_REPLACED,false)
				Effect.SetProperty=_SetProperty
				Effect.Clone=_Clone
				for ke,vp in pairs(s.proeffects) do
					local prop1,prop2=table.unpack(vp)
					ke:SetProperty(prop1|EFFECT_FLAG_UNCOPYABLE,prop2)
				end
				Card.RegisterEffect=cregister
			else
				local e1=Effect.CreateEffect(tg)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_ADD_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(TYPE_EFFECT)
				e1:SetReset(RESET_EVENT+0x47c0000)
				tg:RegisterEffect(e1,true)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_REMOVE_TYPE)
				e2:SetValue(TYPE_NORMAL)
				tg:RegisterEffect(e2,true)
				local e4=e1:Clone()
				e4:SetCode(EFFECT_SET_BASE_ATTACK)
				e4:SetValue(0)
				tg:RegisterEffect(e4,true)
				local e5=e1:Clone()
				e5:SetCode(EFFECT_SET_BASE_DEFENSE)
				e5:SetValue(0)
				tg:RegisterEffect(e5,true)
			end
			--aclimit
			local ge0=Effect.CreateEffect(tg)
			ge0:SetType(EFFECT_TYPE_FIELD)
			ge0:SetCode(EFFECT_ACTIVATE_COST)
			ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
			ge0:SetRange(LOCATION_MZONE)
			ge0:SetTargetRange(1,1)
			ge0:SetTarget(s.actarget1)
			ge0:SetOperation(s.costop1)
			ge0:SetReset(RESET_EVENT+0x47c0000)
			tg:RegisterEffect(ge0,true)
			tg=sg:GetNext()
		end
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
	Duel.SetTargetCard(tg1)
end
function s.actarget1(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function s.costop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local op=te:GetOperation()
	local res=false
	local tab=getmetatable(te:GetHandler())
	for _,f in pairs(tab) do
		if f and f==op then res=true end
	end
	if res then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(1,1)
		e1:SetValue(s.aclimit)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
	end
end
function s.aclimit(e,te,tp)
	if te:GetHandler()~=e:GetHandler() then return false end
	local op=te:GetOperation()
	local res=false
	local tab=getmetatable(te:GetHandler())
	for _,f in pairs(tab) do
		if f and f==op then res=true end
	end
	return res
end
function s.atkactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local dg=g:Filter(Card.IsRelateToEffect,nil,e)
	for dc in aux.Next(dg) do
		local tg=dc:GetColumnGroup():Filter(Card.IsLocation,nil,LOCATION_MZONE)
		for tc in aux.Next(tg) do
			local preatk=tc:GetAttack()
			local dec=Duel.GetMatchingGroupCount(function(c) return c:IsSetCard(0x854) and c:IsFaceup() end,tp,LOCATION_ONFIELD,0,nil)*800
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-dec)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local postatk=tc:GetAttack()
			local decatk=preatk-postatk
			if decatk>=0 and decatk<dec then Duel.Damage(1-tp,dec-decatk,REASON_EFFECT) end
		end
	end
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	tc:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(s.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function s.rsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e2:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e2)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
