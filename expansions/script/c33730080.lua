--键★断片 - 渚正立于坂道之下 || K.E.Y Fragments - Nagisa, Bottom of the Hill
--Scripted by: XGlitchy30

xpcall(function() require("expansions/script/glitchylib_vsnemo") end,function() require("script/glitchylib_vsnemo") end)

local s,id=GetID()
function s.initial_effect(c)
	c:SetCounterLimit(0x1460,1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	local e1x=e1:Clone()
	e1x:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1x)
	local e1y=e1:Clone()
	e1y:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e1y)
	--apply effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.applycon)
	e2:SetCost(s.apply)
	e2:SetTarget(s.defaulttg)
	e2:SetOperation(s.defaultop)
	c:RegisterEffect(e2)
	--light orb
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(s.spreg)
	c:RegisterEffect(e3)
	local e3x=e3:Clone()
	e3x:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3x)
	local e3y=e3:Clone()
	e3y:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3y)
	local e3z=Effect.CreateEffect(c)
	e3z:SetDescription(aux.Stringid(id,2))
	e3z:SetCategory(CATEGORY_COUNTER)
	e3z:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3z:SetRange(LOCATION_ONFIELD)
	e3z:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3z:SetCountLimit(1)
	e3z:SetCondition(s.ctcon)
	e3z:SetTarget(s.cttg)
	e3z:SetOperation(s.ctop)
	c:RegisterEffect(e3z)
end
function s.eqfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x460) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_SPELLCASTER+RACE_WARRIOR)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToChain(0) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(s.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end

function s.applycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler():GetEquipTarget()
end
function s.applyfilter(c,e,tp,chk,chain)
	if not c:IsFaceup() or not c:IsSetCard(0x460) then return false end
	local effs=global_card_effect_table[c]
	if #effs==0 then return false end
	for _,ce in ipairs(effs) do
		if ce and ce.GetLabel and ce:IsHasType(EFFECT_TYPE_ACTIONS) and not ce:IsHasType(EFFECT_TYPE_CONTINUOUS) and ce:GetRange()&LOCATION_MZONE~=0 then
			local _,eg,ep,ev,re,r,rp
			local check=true
			local event=ce:GetCode()
			if event and event~=0 then
				if event==EVENT_CHAINING and chk~=0 then
					if not chain or chain<=0 then
						check=false
					else
						local te2,p=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
						local tc=te2:GetHandler()
						local g=Group.FromCards(tc)
						eg,ep,ev,re,r,rp=g,p,chain,te2,REASON_EFFECT,p
					end
					
				elseif event~=EVENT_FREE_CHAIN then
					check=Duel.CheckEvent(event)
					if check then
						_,eg,ep,ev,re,r,rp=Duel.CheckEvent(event,true)
					end
				end
			end
			if check then
				local condition=ce:GetCondition()
				local target=ce:GetTarget()
				Debug.Message(not target or target(e,tp,eg,ep,ev,re,r,rp,0))
				if (not condition or condition(e,tp,eg,ep,ev,re,r,rp)) and (not target or target(e,tp,eg,ep,ev,re,r,rp,0)) then
					return true
				end
			end
		end
	end
	return false
end

function s.apply(e,tp,eg,ep,ev,re,r,rp,chk)
	local chain=Duel.GetCurrentChain()
	if chk==0 then return Duel.IsExistingMatchingCard(s.applyfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,chk,chain) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.applyfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,chk,chain-1)
	if #g>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		local choose_effect, choose_desc, choose_params = {}, {}, {}
		local effs=global_card_effect_table[tc]
		for _,ce in ipairs(effs) do
			if ce and ce.GetLabel and ce:IsHasType(EFFECT_TYPE_ACTIONS) and not ce:IsHasType(EFFECT_TYPE_CONTINUOUS) and ce:GetRange()&LOCATION_MZONE~=0 then
				local _,teg,tep,tev,tre,tr,trp
				local check=true
				local event=ce:GetCode()
				if event and event~=0 then
					if event==EVENT_CHAINING then
						if chain<=1 then
							check=false
						else
							local te2,p=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
							local tc=te2:GetHandler()
							local g=Group.FromCards(tc)
							teg,tep,tev,tre,tr,trp=g,p,chain,te2,REASON_EFFECT,p
						end
						
					elseif event~=EVENT_FREE_CHAIN then
						check=Duel.CheckEvent(event)
						if check then
							_,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(event,true)
						end
					end
				end
				
				if check then
					local condition=ce:GetCondition()
					local target=ce:GetTarget()
					if (not condition or condition(e,tp,teg,tep,tev,tre,tr,trp)) and (not target or target(e,tp,teg,tep,tev,tre,tr,trp,0)) then
						if type(teg)=="nil" then teg=false end
						if type(tep)=="nil" then tep=false end
						if type(tev)=="nil" then tev=false end
						if type(tre)=="nil" then tre=false end
						if type(tr) =="nil"  then tr=false  end
						if type(trp)=="nil" then trp=false end
						table.insert(choose_effect,ce)
						table.insert(choose_desc,ce:GetDescription())
						table.insert(choose_params,{teg,tep,tev,tre,tr,trp})
					end
				end
			end
		end
		if #choose_effect>0 then
			local opt=Duel.SelectOption(tp,table.unpack(choose_desc))+1
			local ce=choose_effect[opt]
			if ce and ce.GetLabel then
				s[Duel.GetCurrentChain()]=ce
				local params=choose_params[opt]
				local teg,tep,tev,tre,tr,trp
				if #params>0 then
					teg,tep,tev,tre,tr,trp=params[1],params[2],params[3],params[4],params[5],params[6]
					if type(teg)==false then teg=nil end
					if type(tep)==false then tep=nil end
					if type(tev)==false then tev=nil end
					if type(tre)==false then tre=nil end
					if type(tr) ==false then tr=nil  end
					if type(trp)==false then trp=nil end
				end
				e:SetProperty(ce:GetProperty())
				e:SetTarget(s.targetchk(teg,tep,tev,tre,tr,trp))
				e:SetOperation(s.operationchk(teg,tep,tev,tre,tr,trp))
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetReset(RESET_CHAIN)
	e1:SetLabelObject(e)
	e1:SetOperation(s.resetop)
	Duel.RegisterEffect(e1,tp)
end
function s.targetchk(teg,tep,tev,tre,tr,trp)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local te=s[Duel.GetCurrentChain()]
				if chkc then
					local tg=te:GetTarget()
					return tg and tg(e,tp,teg,tep,tev,tre,tr,trp,chk,chkc)
				end
				if chk==0 then return true end
				if not te then return end
				e:SetProperty(te:GetProperty())
				local tg=te:GetTarget()
				if tg then tg(e,tp,teg,tep,tev,tre,tr,trp,chk) end
			end
end
function s.operationchk(teg,tep,tev,tre,tr,trp)
	return function(e,tp,eg,ep,ev,re,r,rp)
				local te=s[Duel.GetCurrentChain()]
				if not te then return end
				local op=te:GetOperation()
				if op then op(e,tp,teg,tep,tev,tre,tr,trp) end
			end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		te:SetTarget(s.defaulttg)
		te:SetOperation(s.defaultop)
	end
end
function s.defaulttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=s[Duel.GetCurrentChain()]
	if chkc then
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	end
	if chk==0 then return true end
	if not te then return end
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,chk) end
	Duel.ClearOperationInfo(0)
end
function s.defaultop(e,tp,eg,ep,ev,re,r,rp)
	local te=s[Duel.GetCurrentChain()]
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

function s.spreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,3,0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(s.upcon)
	e1:SetOperation(s.update_counter)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY,3)
	Duel.RegisterEffect(e1,tp)
end
function s.upcon(e,tp)
	local c=e:GetHandler()
	if c:GetFlagEffect(id)<=0 then
		c:SetTurnCounter(0)
		e:Reset()
		return false
	end
	return true
end
function s.update_counter(e,tp)
	local c=e:GetHandler()
	c:SetTurnCounter(c:GetTurnCounter()+1)
	c:SetFlagEffectLabel(id,c:GetFlagEffectLabel(id)+1)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(id)>0 and c:GetFlagEffectLabel(id)==3
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,c,1,0,0x1460)
	c:SetTurnCounter(0)
	c:ResetFlagEffect(id)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsCanAddCounter(0x1460,1,false,c:GetLocation()) then
		c:AddCounter(0x1460,1)
	end
end