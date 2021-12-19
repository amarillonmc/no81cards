--深眠症
--21.11.19
local m=11450000
local cm=_G["c"..m]
local tableclone=function(tab,mytab)
	local res=mytab or {}
	for i,v in pairs(tab) do res[i]=v end
	return res
end
local readonly=function(tab)
	local meta={__index=tab,__newindex=function() assert(false,'不准偷偷改我的lua！色狼！！\n') end}
	local lock={}
	setmetatable(lock,meta)
	return lock
end
local _Card=tableclone(Card)
local _Duel=tableclone(Duel)
local _Effect=tableclone(Effect)
Card.RegisterEffect=function(c,e,bool)
	local e0=_Effect.CreateEffect(c) 
	_Effect.SetType(e0,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	_Effect.SetCode(e0,EVENT_PHASE_START+PHASE_DRAW)
	_Effect.SetOperation(e0,cm.op)
	_Duel.RegisterEffect(e0,0)
	Card.RegisterEffect=_Card.RegisterEffect
	_Card.RegisterEffect(c,e,bool)
end
function cm.initial_effect(c)
	local e0=_Effect.CreateEffect(c)
	c:RegisterEffect(e0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	_Duel.Hint(HINT_CARD,0,m)
	_Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,1))
	local ct0=_Duel.GetMatchingGroupCount(_Card.IsCode,0,0xff,0,nil,m)
	local ct1=_Duel.GetMatchingGroupCount(_Card.IsCode,0,0,0xff,nil,m)
	if ct0>0 then _Duel.AnnounceCard(1,0,OPCODE_ISTYPE) end
	if ct1>0 then _Duel.AnnounceCard(0,0,OPCODE_ISTYPE) end
	--[[local i=1
	while _Duel.GetLP(1-tp)>0 do
		_Duel.SetLP(1-tp,_Duel.GetLP(1-tp)-100*i)
		i=i+1
	end--]]
end
cm=readonly(cm)