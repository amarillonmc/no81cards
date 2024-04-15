if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetLabel(id)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return s.check end)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) s.check=false end)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return s.effcheck end)
		ge2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) s[s.effcheck]=false s.effcheck=false end)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCode(EVENT_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_CUSTOM+id)
		ge4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.Win(rp,0x1) end)
		Duel.RegisterEffect(ge4,0)
		local f1=Card.RegisterEffect
		Card.RegisterEffect=function(tc,te,bool)
			if te:IsActivated() or te:IsHasType(EFFECT_TYPE_CONTINUOUS) then
				local tg=te:GetTarget()
				if tg then
					te:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
						if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
						if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,0) end
						s.check=e
						tg(e,tp,eg,ep,ev,re,r,rp,1)
						s.check=false
					end)
				end
				local op=te:GetOperation()
				te:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
					s.check=e
					if op then op(e,tp,eg,ep,ev,re,r,rp) end
				end)
			end
			return f1(tc,te,bool)
		end
		local f2=Duel.RegisterEffect
		Duel.RegisterEffect=function(se,sp)
			if se:IsActivated() or se:IsHasType(EFFECT_TYPE_CONTINUOUS) then
				local tg=se:GetTarget()
				if tg then
					se:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
						if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
						if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,0) end
						s.check=e
						tg(e,tp,eg,ep,ev,re,r,rp,1)
						s.check=false
					end)
				end
				local op=se:GetOperation()
				se:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
					s.check=e
					if op then op(e,tp,eg,ep,ev,re,r,rp) end
				end)
			end
			return f2(se,sp)
		end
		local f3=Duel.SetChainLimitTillChainEnd
		Duel.SetChainLimitTillChainEnd=function(func)
			local check=false
			if s.check then check=s.check end
			local f=func
			func=function(re,rp,tp)
				local res=f(re,rp,tp)
				if re:GetLabel()==id and not res then if check then s.effcheck=re s[re]=check end return true else return res end
			end
			return f3(func)
		end
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function s.thfilter(c)
	return c:IsAttack(1300) and c:IsDefense(1200) and c:IsLevel(3) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)>0 and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,c:GetPosition(),true)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local res=eg and ep~=tp and eg:GetFirst():IsLocation(0x4)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local eff=nil
	if s[e] then eff=s[e] s[e]=false end
	if not res then return false end
	local le={}
	local le1={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	for _,v in pairs(le1) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,e,tp) then table.insert(le,v) end
	end
	local le2={Duel.IsPlayerAffectedByEffect(tp,EFFECT_ACTIVATE_COST)}
	for _,v in pairs(le2) do
		local cost=v:GetCost()
		if cost and not cost(v,e,tp) then
			local tg=v:GetTarget()
			if not tg or tg(v,e,tp) then table.insert(le,v) end
		end
	end
	local le3={c:IsHasEffect(EFFECT_CANNOT_TRIGGER)}
	for _,v in pairs(le3) do table.insert(le,v) end
	if eff then table.insert(le,eff) res=false end
	if #le==1 then
		local ae=le[1]
		local ac=ae:GetOwner()
		if ac and ac==tc and c:IsLocation(LOCATION_SZONE) then
			local ct=c:GetFlagEffectLabel(id) or 0
			local desc=ct+2
			if desc>6 then desc=6 end
			c:ResetFlagEffect(id)
			c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CONTROL,EFFECT_FLAG_CLIENT_HINT,0,ct+1,aux.Stringid(id,desc))
		end
	end
	local flag=c:GetFlagEffectLabel(id) or 0
	if flag==4 then
		c:RegisterFlagEffect(id+500,RESET_EVENT+RESETS_STANDARD+RESET_CONTROL+RESET_PHASE+PHASE_END,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(s.win)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		c:CreateEffectRelation(e1)
	end
	if chk==0 then return res end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
end
function s.win(e,tp,eg,ep,ev,re,r,rp)
	if e:GetOwner():IsRelateToEffect(e) and e:GetOwner():GetFlagEffect(id+500)>0 and Duel.Destroy(e:GetOwner(),REASON_EFFECT)~=0 then Duel.Hint(HINT_CARD,0,id) Duel.Win(1-tp,0x1) end
end
