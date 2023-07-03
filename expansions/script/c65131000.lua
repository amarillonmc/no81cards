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
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_DISABLED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
local distable={}
local effectable={}
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffectLabel(re:GetOwnerPlayer(),id+1)==re:GetFieldID() then
		table.insert(distable,re)
		Duel.ResetFlagEffect(re:GetOwnerPlayer(),id+1)
	end
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
	Duel.RegisterFlagEffect(re:GetOwnerPlayer(),id+1,RESET_PHASE+PHASE_END,0,1,re:GetFieldID())
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
	local tlabel1,tlabel2,tlabel3=te:GetLabel()
	
	local fid=c:GetFieldID()
	local ftgpy=Duel.GetChainInfo(ev,CHAININFO_TARGET_PLAYER)
	local ftgpr=Duel.GetChainInfo(ev,CHAININFO_TARGET_PARAM)
	local ftgc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if ftgc then
		local tc=tg:GetFirst()
		while tc do
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1,fid)
			tc=tg:GetNext()
		end
	end
	table.insert(effectable,{re,te:GetLabelObject(),ftgc})
	local e1=Effect.CreateEffect(e:GetLabelObject():GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(fid,ftgpy,ftgpr,tlabel1,tlabel2,tlabel3,Duel.GetTurnCount())
	e1:SetLabelObject(re)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	e1:SetCondition(
		function (e,tp,eg,ep,ev,re,r,rp)	 
			local fid,ftgpy,ftgpr,tlabel1,tlabel2,tlabel3,turn=e:GetLabel()	  
			return Duel.GetTurnCount()~=turn
		end
	)
	e1:SetTarget(
	function (e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local fe=e:GetLabelObject()
		local fid,ftgpy,ftgpr=e:GetLabel()
		if chkc then return true end
		if chk==0 then
			local ftg=fe:GetTarget()
			local r1,r2 =true
			if ftg then
				local e1=Effect.CreateEffect(e:GetLabelObject():GetHandler())
				e1:SetType(EFFECT_TYPE_ACTIVATE)
				r1=ftg(e1,tp,eg,ep,ev,re,r,rp,0,false)
				local e2=Effect.CreateEffect(e:GetLabelObject():GetHandler())
				r2=ftg(e2,tp,eg,ep,ev,re,r,rp,0,false)
			end
			--防连锁素材的”这张卡的发动回合“效果
			--总之连锁素材能防
			return r1==r2 and not fe:IsHasCategory(CATEGORY_DISABLE_SUMMON) 
		end
		e:GetHandler():CreateEffectRelation(e)
		local fg=Duel.GetFieldGroup(tp,0xff,0xff):Filter(s.cfilter,nil,fid)
		--因为SetLabelObject只能有一个所以采用了这个笨方法来记录对象
		if fg then 
			Duel.SetTargetCard(fg)
			local tc=fg:GetFirst()
			while tc do
				tc:CreateEffectRelation(e)
				tc=fg:GetNext()
			end
		end
		--谢谢黑莲哥谢谢黑莲哥
		Duel.SetTargetPlayer(ftgpy)
		Duel.SetTargetParam(ftgpr)		  
	end
	)
	e1:SetOperation(
	function (e,tp,eg,ep,ev,re,r,rp)
		e:Reset()
		local fe=e:GetLabelObject()
		for i,value in ipairs(distable) do
			if value==fe then
				table.remove(distable,i)
				return
			end
		end
		
		local fid,ftgpy,ftgpr,tlabel1,tlabel2,tlabel3=e:GetLabel()
		for i = 9,13 do
			Duel.Hint(HINT_CARD,0,id+i)
		end
		if e:GetHandler():IsType(TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD) and fe:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
		e:SetLabel(tlabel1,tlabel2,tlabel3)
		local tlbo=getlbo(fe)
		--把原来的labelobject塞回去
		if tlbo~=nil then e:SetLabelObject(tlbo) end
		local fop=fe:GetOperation()
		fop(e,tp,eg,ep,ev,re,r,rp) 
	end
	)
	Duel.RegisterEffect(e1,p)
	Duel.ChangeChainOperation(ev,function (e,tp,eg,ep,ev,re,r,rp) end)
end
function getlbo(e)
	for i,value in ipairs(effectable) do
		if value[1]==e then
			local tlbo=value[2]
			table.remove(effectable,i)
			return tlbo
		end
	end
	return nil
end