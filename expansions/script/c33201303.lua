--殂世魇魔 苔壁怪
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
local m=33201303
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201300") end,function() require("script/c33201300") end)
function cm.initial_effect(c)
	VHisc_BeastHell.fler(c,m,0x0,0x10000)
	VHisc_BeastHell.gyer(c,m)
end
cm.VHisc_BeastHell=true

function cm.filter(c)
	return VHisc_Bh.ck(c) and c:IsType(TYPE_SPIRIT+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.fltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.flop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,ec) return ec:IsFaceup() end)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end