--迷石宫的降诞
function c60000029.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcEqual2(c,c60000029.filter,nil,c60000029.filter)
end
function c60000029.filter(c)
	return c:IsSetCard(0x625)
end
