--[[
派系斗争
Battle of Preference
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
Duel.LoadScript("glitchylib_duodirection.lua")
function s.initial_effect(c)
	local e0=c:Activation(nil,nil,nil,nil,s.operation)
	aux.AddDuoDirectionProc(c,e0,id+1)
end
--E0
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local prop={}
	local np=c:GetNorthPlayer(tp)
	for p in aux.TurnPlayers() do
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATTRIBUTE)
		local att=Duel.AnnounceAttribute(p,1,ATTRIBUTE_ALL)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_RACE)
		local rac=Duel.AnnounceRace(p,1,RACE_ALL)
		if p==np then
			prop[np+1]={att,rac}
		elseif p==1-np then
			prop[2-np]={att,rac}
		end
	end
	aux.RegisterMaxxCEffect(c,id,nil,LOCATION_SZONE,EVENTS_SUMMON_SUCCESS,s.damcon(prop),s.damopOUT(prop,np),s.damopIN,s.flaglabel(prop,np),RESET_EVENT|RESETS_STANDARD)
end
function s.cfilter0(c,tab1,tab2)
	return c:IsFaceup() and (c:IsAttribute(tab1[1]|tab2[1]) or c:IsRace(tab1[2]|tab2[2]))
end
function s.cfilter1(c,att,rc)
	return c:IsFaceup() and (c:IsAttribute(att) or c:IsRace(rc))
end
function s.cfilter2(c,sump,att,rc)
	return c:IsSummonPlayer(sump) and s.cfilter1(c,att,rc)
end
function s.damcon(prop)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				return eg:IsExists(s.cfilter0,1,nil,prop[1],prop[2])
			end
end
function s.flaglabel(prop,np)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				return eg:FilterCount(s.cfilter2,nil,tp,table.unpack(prop[np+1])),
					eg:FilterCount(s.cfilter2,nil,tp,table.unpack(prop[2-np])),
					eg:FilterCount(s.cfilter2,nil,1-tp,table.unpack(prop[np+1])),
					eg:FilterCount(s.cfilter2,nil,1-tp,table.unpack(prop[2-np]))
			end
end
function s.damopOUT(prop,np)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				Duel.Hint(HINT_CARD,tp,id)
				for p in aux.TurnPlayers() do
					local nct,sct=eg:FilterCount(s.cfilter2,nil,p,table.unpack(prop[np+1])),eg:FilterCount(s.cfilter2,nil,p,table.unpack(prop[2-np]))
					if nct>0 then
						Duel.Recover(p,nct*500,REASON_EFFECT,true)
					end
					if sct>0 then
						Duel.Damage(p,sct*500,REASON_EFFECT,true)
					end
				end
				Duel.RDComplete()
			end
end
function s.damopIN(e,tp,eg,ep,ev,re,r,rp,n)
	Duel.Hint(HINT_CARD,tp,id)
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT|id)}
	for p in aux.TurnPlayers() do
		local nct,sct=0,0
		for _,fe in ipairs(eset) do
			local nct1,sct1,nct2,sct2=fe:GetLabel()
			if p==tp then
				nct,sct=nct+nct1,sct+sct1
			else
				nct,sct=nct+nct2,sct+sct2
			end
		end
		if nct>0 then
			Duel.Recover(p,nct*500,REASON_EFFECT,true)
		end
		if sct>0 then
			Duel.Damage(p,sct*500,REASON_EFFECT,true)
		end
	end
	Duel.RDComplete()
end