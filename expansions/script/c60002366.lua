--苔丝·格雷迈恩
local cm,m,o=GetID()
function cm.initial_effect(c)
	Tess_g=Group.CreateGroup()
	Tess_g:KeepAlive()
	GM_g=Group.CreateGroup()
	GM_g:KeepAlive()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(cm.con2)
	e1:SetOperation(cm.op2)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(cm.rmcon)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.con2(e,tp)
	return Duel.GetFlagEffect(tp,m)==0
end
function cm.op2(e,tp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_DECK,LOCATION_HAND+LOCATION_DECK,nil) 
	GM_g:Merge(g)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1000)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	if Tess_g:GetCount()~=0 then
		local bc=Tess_g:GetFirst()
		while bc do
			if not GM_g:IsContains(bc) then
				local ac=Duel.CreateToken(tp,bc:GetCode())
				if ac:CheckActivateEffect(false,false,false)~=nil then
					if ac:IsType(TYPE_FIELD) then
						Duel.MoveToField(ac,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
						Duel.RaiseEvent(ac,4179255,te,0,tp,tp,Duel.GetCurrentChain())
					else
						Duel.MoveToField(ac,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
					end
					local te=ac:GetActivateEffect()
					te:UseCountLimit(tp,1,true)
					cm.ActivateCard(ac,tp,e)
					if not (ac:IsType(TYPE_CONTINUOUS) or ac:IsType(TYPE_FIELD) or ac:IsType(TYPE_EQUIP)) then
						Duel.SendtoGrave(ac,REASON_RULE)
					end
				end
			end
			bc=Tess_g:GetNext()
		end
	end
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Tess_g:AddCard(re:GetHandler())
end  
function cm.ActivateCard(c,tp,oe)
	local e=c:GetActivateEffect()
	local cos,tg,op=e:GetCost(),e:GetTarget(),e:GetOperation()
	if e and (not cos or cos(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
		oe:SetProperty(e:GetProperty())
		local code=c:GetOriginalCode()
		Duel.Hint(HINT_CARD,tp,code)
		Duel.Hint(HINT_CARD,1-tp,code)
		e:UseCountLimit(tp,1,true)
		c:CreateEffectRelation(e)
		if cos then cos(e,p,eg,ep,ev,re,r,rp,1) end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and #g~=0 then
			local tg=g:GetFirst()
			while tg do
				tg:CreateEffectRelation(e)
				tg=g:GetNext()
			end
		end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		c:ReleaseEffectRelation(e)
		if g then
			tg=g:GetFirst()
			while tg do
				tg:ReleaseEffectRelation(e)
				tg=g:GetNext()
			end
		end
	end
end




