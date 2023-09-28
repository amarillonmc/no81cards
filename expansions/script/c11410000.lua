--杏花宵
--23.09.08
local cm,m=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e0:SetOperation(cm.op)
	Duel.RegisterEffect(e0,0)
end
if not aux.GetMustMaterialGroup then
	aux.GetMustMaterialGroup=Duel.GetMustMaterial
	--[[function aux.GetMustMaterialGroup(tp,code)
		local g=Group.CreateGroup()
		local ce={Duel.IsPlayerAffectedByEffect(tp,code)}
		for _,te in ipairs(ce) do
			local tc=te:GetHandler()
			if tc then g:AddCard(tc) end
		end
		return g
	end--]]
end
local _IsTuner=Card.IsTuner
function Card.IsTuner(c,...)
	local ext_params={...}
	if #ext_params==0 then return true end
	return _IsTuner(c,...)
end
local _IsCanBeSynchroMaterial=Card.IsCanBeSynchroMaterial
function Card.IsCanBeSynchroMaterial(c,...)
	local ext_params={...}
	if #ext_params==0 then return _IsCanBeSynchroMaterial(c,...) end
	local sc=ext_params[1]
	local tp=sc:GetControler()
	if c:IsLocation(LOCATION_MZONE) and not c:IsControler(tp) then
		local mg=Duel.GetSynchroMaterial(tp)
		return mg:IsContains(c) and _IsCanBeSynchroMaterial(c,sc,...)
	end
	return _IsCanBeSynchroMaterial(c,...)
end
function cm.nfilter(c,g)
	return g:FilterCount(cm.sfilter,nil,c)<3
end
function cm.sfilter(c,sc)
	return c:GetOriginalCode()==sc:GetOriginalCode()
end
local KOISHI_CHECK=false
if Duel.Exile then KOISHI_CHECK=true end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_EXTRA,0,c)
	g=g:Filter(cm.nfilter,nil,g)
	local tc=nil
	local tg
	--if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	if #g>0 then tg=g:Select(tp,0,1,nil) end
	if tg and #tg>0 then tc=tg:GetFirst() end
	if KOISHI_CHECK then Duel.Exile(c,REASON_RULE) end
	if tc then
		Duel.SendtoDeck(Duel.CreateToken(tp,tc:GetOriginalCode()),tp,2,REASON_RULE)
	else
		Duel.Hint(HINT_CARD,0,m)
	end
end
if not require and dofile then function require(str) return dofile(str..".lua") end end
--[[if not require and Duel.LoadScript then
	function require(str)
		local name=str
		for word in string.gmatch(str,"%w+") do
			name=word
		end
		Duel.LoadScript(name..".lua")
		return true
	end
end--]]