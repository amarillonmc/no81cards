local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
	end
end
function s.cfilter(c,e,tp)
	local le={c:IsHasEffect(id)}
	if #le==0 then return false end
	local check=false
	for _,v in pairs(le) do
		local fe=v:GetLabelObject()
		local ftg=fe:GetTarget()
		local code=fe:GetCode()
		if code==0 or code==EVENT_FREE_CHAIN then
			if (not ftg or ftg(e,tp,nil,0,0,nil,0,0,0)) then check=true end
		else
			local cres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(code,true)
			if cres and (not ftg or ftg(e,tp,teg,tep,tev,tre,tr,trp,0)) then check=true end
		end
	end
	return check and c:IsAbleToGraveAsCost()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:IsCostChecked() and not c:IsPublic() and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(s.regop)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	local le={tc:IsHasEffect(id)}
	local off=1
	local ops={}
	local opval={}
	for i,v in pairs(le) do
		local fe=v:GetLabelObject()
		local ftg=fe:GetTarget()
		local code=fe:GetCode()
		if code==0 or code==EVENT_FREE_CHAIN then
			if (not ftg or ftg(fe,tp,nil,0,0,nil,0,0,0)) then
				ops[off]=v:GetDescription()
				opval[off-1]=i
				off=off+1
			end
		else
			local cres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(code,true)
			if cres and (not ftg or ftg(fe,tp,teg,tep,tev,tre,tr,trp,0)) then 
				ops[off]=v:GetDescription()
				opval[off-1]=i
				off=off+1
			end
		end
	end
	Duel.SendtoGrave(tc,REASON_COST)
	local te=le[1]:GetLabelObject()
	if #ops>1 then
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local s=opval[op]
		te=le[s]:GetLabelObject()
	end
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	local code=te:GetCode()
	if code==0 or code==EVENT_FREE_CHAIN then
		if tg then tg(e,tp,nil,0,0,nil,0,0,1) end
	else
		local cres,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(code,true)
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject() then
		e:Reset()
		return
	end
	if rp==tp then return end
	local ev0=Duel.GetCurrentChain()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:GetLabelObject(e)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(s.reset)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	c:ResetEffect(EFFECT_PUBLIC,RESET_CODE)
	if e:GetLabelObject() then e:GetLabelObject():Reset() end
	e:Reset()
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	local cp={}
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,te,bool)
		local pro1,pro2=te:GetProperty()
		if te:GetCategory()&CATEGORY_FUSION_SUMMON~=0 and pro1&EFFECT_FLAG_UNCOPYABLE==0 then table.insert(cp,te:Clone()) end
		return f(tc,te,bool)
	end
	local g=Duel.GetFieldGroup(0,0xff,0xff)
	for tc in aux.Next(g) do
		Duel.CreateToken(tp,tc:GetOriginalCode())
		for _,v in pairs(cp) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(id)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabelObject(v)
			tc:RegisterEffect(e1,true)
		end
		cp={}
	end
	Card.RegisterEffect=f
	e:Reset()
end
