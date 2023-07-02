--独自转动的时钟
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(s.changecon)
	e1:SetOperation(s.changeop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.changecon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActivated()
end
function s.changeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetLabel(rp)
	e1:SetLabelObject(re)
	e1:SetCondition(s.necon)
	e1:SetOperation(s.neop)	
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.necon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetOperation() and e:GetLabelObject() and re==e:GetLabelObject()
end
function s.cfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.neop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	local te=e:GetLabelObject()
	if not p or not te then return end
	for i =1,10 do
		Duel.Hint(HINT_CARD,0,id+i)
	end
	local c=e:GetHandler()
	local fop=te:GetOperation()
	local fid=c:GetFieldID()
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if tg then
		local tc=tg:GetFirst()
		while tc do
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1,fid)
			tc=tg:GetNext()
		end
	end 
	local e1=Effect.CreateEffect(e:GetLabelObject():GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(re)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	e1:SetTarget(
	function (e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local fe=e:GetLabelObject()	 
		local ftg=fe:GetTarget()
		if chkc then return true end
		if chk==0 then return not fe:IsHasCategory(CATEGORY_DISABLE_SUMMON) end
		e:GetHandler():CreateEffectRelation(e)
		if fe:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			local fg=Duel.GetFieldGroup(tp,0xff,0xff):Filter(s.cfilter,nil,e:GetLabel())
			--因为SetLabelObject只能有一个所以采用了这个笨方法来记录对象
			if fg then 
				Duel.SetTargetCard(fg)
				local tc=fg:GetFirst()
				while tc do
					tc:CreateEffectRelation(e)
					tc=fg:GetNext()
				end
			end
		end
		if ftg then		 
			ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		end
	end
	)
	e1:SetOperation(
	function (e,tp,eg,ep,ev,re,r,rp)
		for i = 9,13 do
			Duel.Hint(HINT_CARD,0,id+i)
		end
		local fe=e:GetLabelObject()
		if e:GetHandler():IsType(TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD) and fe:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
		local fop=fe:GetOperation()
		fop(e,tp,eg,ep,ev,re,r,rp) 
		end
	)
	Duel.RegisterEffect(e1,p)
	Duel.ChangeChainOperation(ev,function (e,tp,eg,ep,ev,re,r,rp) end)
end