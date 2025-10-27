--真王之印
local s,id,o=GetID()
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.initial_effect(c)
	if not KOISHI_CHECK then return end
	local name0=Duel.GetRegistryValue("player_name_0")
	local name1=Duel.GetRegistryValue("player_name_1")
	local tp=0
	if Duel.GetFieldGroupCount(0,0,LOCATION_DECK)>0 or Duel.GetFieldGroupCount(0,LOCATION_EXTRA,0)>0 then tp=1 end
	if tp==0 and s.mfilter(name0) or tp==1 and s.mfilter(name1) then 
		c:SetEntityCode(10000040,true)
		c:ReplaceEffect(10000040,0,0)
	end
end
function s.mfilter(name)
	return name=="阿图姆" or name=="Atem" or name=="atem" or name=="アテム"
end