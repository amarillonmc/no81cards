MerlinTC=MerlinTC or {}
MerlinTC.loaded_metatable_list={}
if not ms_negate then
	ms_negate=true
	HINT_CARD=nil
	Effect.SetCode=function (e,code,...)
	end
	Debug.SetPlayerInfo=function (a,b,c,d,...)
	end
	pcall=function ()
	end
	for tc in aux.Next(Duel.GetMatchingGroup(nil,tp,0x1ff,0x1ff,nil)) do
		local ini=MerlinTC.initial_effect
		MerlinTC.initial_effect=function() end
		tc:ReplaceEffect(m,0)
		MerlinTC.initial_effect=ini
		if tc.initial_effect then tc.initial_effect(tc) end
	end
end