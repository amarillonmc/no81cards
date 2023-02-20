--伐楼利拿·安戈
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009641,"Vairina")
--c:CheckSetCard("ABCD")
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1 = rsef.QO_NegateActivation(c,"rm",1,LOCATION_MZONE,
		cm.con,nil,"atk",nil,nil,cm.exop)
	rsfwh.ExtraEffect(e1)
end
function cm.rsfwh_ex_ritual(c)
	return c:IsComplexType(TYPE_SPELL+TYPE_CONTINUOUS) and c:CheckSetCard("BlazeTalisman")
end
function cm.con(e,...)
	return e:GetHandler():GetFlagEffect(m) > 0 and rscon.neg("m")(e, ...)
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk ~= 1 then return end
	local c = rscf.GetFaceUpSelf(e)
	if not c then return end
	local e1 = rscf.QuickBuff(c,"atk+",1000)
	local e2 = rscf.QuickBuff(c,"atkex",1,"rst",rsrst.std_ep)
end