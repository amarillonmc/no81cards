--柩机之影衍生物
local m=40009699
local cm=_G["c"..m]
cm.named_with_Cardinal=1
function cm.initial_effect(c)	
end
function cm.Cardinal(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Cardinal
end

