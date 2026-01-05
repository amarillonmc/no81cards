--殂世魇魔 双尖刃魔
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
local m=33201306
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201300") end,function() require("script/c33201300") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	VHisc_BeastHell.hand(c,m)
	VHisc_BeastHell.fler(c,m,0x8,0x10000)
	--extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
cm.VHisc_BeastHell=true

function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and c.VHisc_BeastHell and c:IsAbleToHand()
end
function cm.fltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil):GetCount()>1 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,0,0)
end
function cm.flop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,2,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end