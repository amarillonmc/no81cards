--殂世魇魔 撕裂魔
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
local m=33201305
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201300") end,function() require("script/c33201300") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	VHisc_BeastHell.hand(c,m)
	VHisc_BeastHell.fler(c,m,0x4,0x10000)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
cm.VHisc_BeastHell=true

function cm.filter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEUP)
end
function cm.fltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_GRAVE,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function cm.flop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter),tp,0,LOCATION_GRAVE,nil,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,5,nil)
		if sg:GetCount()>0 then
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end