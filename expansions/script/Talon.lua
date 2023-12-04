--塔隆·血魔2
Talon=Talon or {}
Talon.loaded_metatable_list={}
if not Talon.Taron_AddFlag then
	talon={}
	Talon.Taron_AddFlag=true
	Talon._set_code=Effect.SetCode
	Effect.SetCode=function (ue,code,...)
		if (code==EVENT_TO_GRAVE or code==EVENT_BE_MATERIAL or code==EVENT_BATTLE_DESTROYED) then
			local uid=ue:GetOwner():GetCode()
			talon[uid]=ue
		end
		Talon._set_code(ue,code,...)
	end
	for tc in aux.Next(Duel.GetMatchingGroup(nil,tp,0x1ff,0x1ff,nil)) do
		local ini=Talon.initial_effect
		Talon.initial_effect=function() end
		tc:ReplaceEffect(m,0)
		Talon.initial_effect=ini
		if tc.initial_effect then tc.initial_effect(tc) end
	end
end