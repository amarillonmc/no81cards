local m=53796106
local cm=_G["c"..m]
cm.name="大同"
local tableclone=function(tab,mytab)
	local res=mytab or {}
	for i,v in pairs(tab) do res[i]=v end
	return res
end
local readonly=function(tab)
	local meta={__index=tab,__newindex=function()end}
	local lock={}
	setmetatable(lock,meta)
	return lock
end
local _DTCard=tableclone(Card)
local _DTDuel=tableclone(Duel)
local _DTEffect=tableclone(Effect)
local _DTGroup=tableclone(Group)
local _DTDebug=tableclone(Debug)
Card.RegisterEffect=function(c,e,bool)
	if not cm.global_check then
	cm.global_check=true
	local ex1=_DTEffect.CreateEffect(c)
	_DTEffect.SetType(ex1,EFFECT_TYPE_FIELD)
	_DTEffect.SetProperty(ex1,EFFECT_FLAG_PLAYER_TARGET)
	_DTEffect.SetCode(ex1,EFFECT_CANNOT_LOSE_KOISHI)
	_DTEffect.SetTargetRange(ex1,1,1)
	_DTEffect.SetValue(ex1,1)
	_DTDuel.RegisterEffect(ex1,0)
	local ex2=_DTEffect.CreateEffect(c)
	_DTEffect.SetType(ex2,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	_DTEffect.SetCode(ex2,EVENT_ADJUST)
	_DTEffect.SetLabel(ex2,1,1)
	_DTEffect.SetLabelObject(ex2,ex1)
	_DTEffect.SetOperation(ex2,cm.adjustop)
	_DTDuel.RegisterEffect(ex2,0)
	local ex3=_DTEffect.CreateEffect(c)
	_DTEffect.SetType(ex3,EFFECT_TYPE_FIELD)
	_DTEffect.SetProperty(ex3,EFFECT_FLAG_PLAYER_TARGET)
	_DTEffect.SetCode(ex3,EFFECT_DRAW_COUNT)
	_DTEffect.SetTargetRange(ex3,1,1)
	_DTEffect.SetLabelObject(ex3,ex2)
	_DTEffect.SetCondition(ex3,function(e)return not Duel.CheckEvent(EVENT_PHASE_START+PHASE_DRAW)end)
	_DTEffect.SetValue(ex3,function(e)
		local p=_DTDuel.GetTurnPlayer()
		local le=_DTEffect.GetLabelObject(e)
		local ct1,ct2=_DTEffect.GetLabel(le)
		local ct=ct1
		if p==1 then ct=ct2 end
		local d=_DTDuel.GetFieldGroupCount(p,LOCATION_DECK,0)
		if ct>d and (_DTDuel.GetTurnCount()>1 or _DTDuel.GetMasterRule()<3) then
			if _DTDuel.GetFlagEffect(0,m+50)==0 then
			_DTDuel.RegisterFlagEffect(0,m+50,RESET_PHASE+PHASE_DRAW,0,1)
			local ex4=_DTEffect.CreateEffect(c)
			_DTEffect.SetType(ex4,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			_DTEffect.SetCode(ex4,EVENT_PHASE+PHASE_DRAW)
			_DTEffect.SetOperation(ex4,cm.drawcheck)
			_DTEffect.SetReset(ex4,RESET_PHASE+PHASE_DRAW)
			_DTDuel.RegisterEffect(ex4,0)
			end
			return 0
		else
			return ct
		end
	end)
	_DTDuel.RegisterEffect(ex3,0)
	local ex5=_DTEffect.CreateEffect(c)
	_DTEffect.SetType(ex5,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	_DTEffect.SetCode(ex5,EVENT_ADJUST)
	_DTEffect.SetLabelObject(ex5,ex3)
	_DTEffect.SetOperation(ex5,cm.adjustop2)
	_DTDuel.RegisterEffect(ex5,0)
	local ex6=_DTEffect.CreateEffect(c)
	_DTEffect.SetType(ex6,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	_DTEffect.SetCode(ex6,EVENT_TO_HAND)
	_DTEffect.SetOperation(ex6,cm.first)
	_DTDuel.RegisterEffect(ex6,0)
	Card.RegisterEffect=_DTCard.RegisterEffect
	end
	return _DTCard.RegisterEffect(c,e,bool)
end
Duel.Win=function(p,reason)
	if p==0 or p==1 then
		p=PLAYER_NONE
		reason=0x3
		_DTDuel.Hint(HINT_CARD,0,m)
	end
	return _DTDuel.Win(p,reason)
end
Duel.Draw=function(p,ct,reason)
	local dct=_DTDuel.GetFieldGroupCount(p,LOCATION_DECK,0)
	if dct<ct and (not _DTDuel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_DRAW) or reason&REASON_RULE~=0) then
		_DTDuel.RegisterFlagEffect(p,m,0,0,0)
		ct=dct
	end
	return _DTDuel.Draw(p,ct,reason)
end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	c:RegisterEffect(e1)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local r1,r2=false
	local le1={_DTDuel.IsPlayerAffectedByEffect(0,EFFECT_CANNOT_LOSE_KOISHI)}
	local le2={_DTDuel.IsPlayerAffectedByEffect(1,EFFECT_CANNOT_LOSE_KOISHI)}
	for _,v in pairs(le1) do if v~=_DTEffect.GetLabelObject(e) then r1=true end end
	for _,v in pairs(le2) do if v~=_DTEffect.GetLabelObject(e) then r2=true end end
	if (_DTDuel.GetLP(0)<=0 and not r1) or (_DTDuel.GetLP(1)<=0 and not r2) then
		if not (_DTDuel.GetLP(0)<=0 and not r1 and _DTDuel.GetLP(1)<=0 and not r2) then _DTDuel.Hint(HINT_CARD,0,m) end
		_DTDuel.Win(PLAYER_NONE,0x3)
	end
	local d1=_DTDuel.GetFlagEffect(0,m)
	local d2=_DTDuel.GetFlagEffect(1,m)
	if (d1>0 or d2>0) and not (d1>0 and d2>0) then
		_DTDuel.Hint(HINT_CARD,0,m)
		_DTDuel.Win(PLAYER_NONE,0x3)
	end
	_DTDuel.ResetFlagEffect(0,m)
	_DTDuel.ResetFlagEffect(1,m)
end
function cm.adjustop2(e,tp,eg,ep,ev,re,r,rp)
	local le1={_DTDuel.IsPlayerAffectedByEffect(0,EFFECT_DRAW_COUNT)}
	local le2={_DTDuel.IsPlayerAffectedByEffect(1,EFFECT_DRAW_COUNT)}
	local te=_DTEffect.GetLabelObject(e)
	local le=_DTEffect.GetLabelObject(te)
	local ct1,ct2=1,1
	for _,v in pairs(le1) do
		if v~=te then
			local val=_DTEffect.GetValue(v)
			if aux.GetValueType(val)=="function" then val=val(v,0) end
			ct1=val
		end
	end
	for _,v in pairs(le2) do
		if v~=te then
			local val=_DTEffect.GetValue(v)
			if aux.GetValueType(val)=="function" then val=val(v,1) end
			ct2=val
		end
	end
	_DTEffect.SetLabel(le,ct1,ct2)
end
function cm.drawcheck(e,tp,eg,ep,ev,re,r,rp)
	local p=_DTDuel.GetTurnPlayer()
	local d=_DTDuel.GetFieldGroupCount(p,LOCATION_DECK,0)
	if d>0 then _DTDuel.Draw(p,d,REASON_RULE) end
	_DTDuel.Hint(HINT_CARD,0,m)
	_DTDuel.Win(PLAYER_NONE,0x3)
end
function cm.first(e,tp,eg,ep,ev,re,r,rp)
	local p=1
	local c=_DTEffect.GetHandler(e)
	local tc=_DTGroup.GetFirst(eg)
	if _DTCard.GetControler(c)~=_DTCard.GetControler(tc) then p=0 end
	local ex6=_DTEffect.CreateEffect(c)
	_DTEffect.SetType(ex6,EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	_DTEffect.SetCode(ex6,EVENT_PREDRAW)
	_DTDuel.RegisterEffect(ex6,p)
	_DTEffect.Reset(e)
end
cm=readonly(cm)
